//
//  ViewController.swift
//  ParityCubeAssignment
//
//  Created by apple on 11/01/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.call()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func call(){
        ApiReqClass.sharedApiReq.fetchTopPopularDealsReq(inpParam: nil) { (isError, result, httpResponse) in
            if (!isError){
                print("No error")
                print("response is \(result)")
            }
        }
    }
}

