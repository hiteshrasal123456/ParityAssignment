//
//  TopDealsModel.swift
//  ParityCubeAssignment
//
//  Created by apple on 11/01/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class TopDealsModel: NSObject {
    var dictionary = NSMutableDictionary()//to initialize dictionary
    var array : Array<NSDictionary>? // array contains dictionary object
    //Standard approach to bind model in array
    var topDealsArray : [TopDealsListModel] = [] // array initialization with accept rolemodle class object
    
    
    
    // as is used for type cast to set object type
    //Mirrorloginmodle init method accept dictionary
    init(dictionary : NSDictionary) {
        
        self.dictionary = NSMutableDictionary(dictionary: dictionary)
        array = self.dictionary.value(forKey: "top") as? Array
        
        if let arr = array {
            
            //for in loop format
            for dic in arr {
                let topDealsListModel = TopDealsListModel.init(dict: dic )
                topDealsArray.append(topDealsListModel)
                //Standard approach to retrive optional value ( Optional chaining)
                //if let data = optional variable
                
                
            }
        }
        
    }
}
class TopDealsListModel: NSObject {
    var dictionary = NSMutableDictionary()
    var title : String?  {
        get
        {
            
            return dictionary.value(forKey: "deal_category_name") as? String
        }
        set {
            dictionary.setValue(newValue, forKey: "deal_category_name")
        }
    }
    
    var imgUrl : String?  {
        get
        {
            
            return dictionary.value(forKey: "pic_thumb") as? String
        }
        set {
            dictionary.setValue(newValue, forKey: "pic_thumb")
        }
    }
    
    var dealDescription : String?  {
        get
        {
            
            return dictionary.value(forKey: "title") as? String
        }
        set {
            dictionary.setValue(newValue, forKey: "title")
        }
    }
    
    init(dict : NSDictionary) {
        dictionary = NSMutableDictionary(dictionary: dict)
    }
    
}
