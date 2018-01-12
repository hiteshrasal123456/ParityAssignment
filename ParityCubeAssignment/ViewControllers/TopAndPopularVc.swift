//
//  TopAndPopularVc.swift
//  ParityCubeAssignment
//
//  Created by apple on 11/01/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class TopAndPopularVc: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    @IBOutlet weak var segmentDeal: UISegmentedControl!
    @IBOutlet weak var tblViewDeals: UITableView!
    var popularDealArray : [PopularDealsListModel] = []
    var popularDealcache:NSCache<AnyObject, AnyObject>!
    var topDealArray : [TopDealsListModel] = []
    var topDealcache:NSCache<AnyObject, AnyObject>!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var isTop : Bool!
    var isPopular : Bool!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        // Do any additional setup after loading the view.
        
        isTop = true
        isPopular = false
        
        self.tblViewDeals.register(UINib(nibName : "DealsCell" , bundle : nil), forCellReuseIdentifier: "DealsCellIdef");
        self.fetchDeals()
        
        

        
        
        self.tblViewDeals.reloadData();
        self.popularDealcache = NSCache()
        self.topDealcache = NSCache()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Api Call
    func fetchDeals() {
        ApiReqClass.sharedApiReq.fetchTopPopularDealsReq(inpParam: nil) { (isError, result, httpResponse) in
            
            
            
            
            if (!isError){
                
                let resultDict = result as! NSDictionary
                
                let respDict = resultDict.value(forKey: "result") as! NSDictionary
                 let popularDealsModel = PopularDealsModel(dictionary: respDict);
                self.popularDealArray = popularDealsModel.popularDealsArray
                
                let topDealsModel = TopDealsModel(dictionary: respDict);
                self.topDealArray = topDealsModel.topDealsArray
                
                DispatchQueue.main.async(execute: {
                    self.segmentDeal.selectedSegmentIndex = 0
                    self.segmentDeal.sendActions(for: UIControlEvents.valueChanged)
                })
            
            }else{
                let errorMsg = result
                
                    print("error message is \(errorMsg)")
                
                
            }
           
        }
        
    }
    
  //  MARK: - TableView methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isTop {
            if self.topDealArray.count > 0 {
                return self.topDealArray.count
            }else{
                return 0
            }
        }else if isPopular{
            if self.popularDealArray.count > 0 {
                return self.popularDealArray.count
            }else{
                return 0
            }
        }else{
            return 0
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DealsCellIdef", for: indexPath) as! DealsCell;
        
        self.setTopPopularList(tableView: tableView, cell: cell,  indexPath: indexPath as NSIndexPath)
        return cell ;
    }
    
    @IBAction func segmentDealAction(_ sender: Any) {
        
        switch self.segmentDeal.selectedSegmentIndex {
        case 0:
            isTop = true
            isPopular = false
            DispatchQueue.main.async(execute: {
                self.tblViewDeals.reloadData()
            })
            
        break
            
        case 1:
            isTop = false
            isPopular = true
            DispatchQueue.main.async(execute: {
                self.tblViewDeals.reloadData()
            })
            break
        default:
            break
        }
    }
    
    func setTopPopularList(tableView : UITableView , cell :DealsCell , indexPath : NSIndexPath ) {
        
        
        if isTop {
            cell.lblTitle.text = self.topDealArray[indexPath.row].title
            //
            
            cell.lblDescription.text = self.topDealArray[indexPath.row].dealDescription
            if (self.topDealcache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                print("Cached image used")
                cell.imgView.image = self.topDealcache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }else{
                let imgUrl = self.topDealArray[indexPath.row].imgUrl
                let url:URL! = URL(string: imgUrl!)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async(execute: { () -> Void in
                           
                            if let updateCell = tableView.cellForRow(at: indexPath as IndexPath) as? DealsCell {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.imgView.image = img
                                self.topDealcache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            }
            
        }else if isPopular{
            cell.lblTitle.text = self.popularDealArray[indexPath.row].title
            
            cell.lblDescription.text = self.popularDealArray[indexPath.row].dealDescription
            if (self.popularDealcache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                print("Cached image used")
                cell.imgView.image = self.popularDealcache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }else{
                // 3
                let imgUrl = self.popularDealArray[indexPath.row].imgUrl
                let url:URL! = URL(string: imgUrl!)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async(execute: { () -> Void in
                           
                            if let updateCell = tableView.cellForRow(at: indexPath as IndexPath) as? DealsCell {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.imgView.image = img
                                self.popularDealcache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            }
        }
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
