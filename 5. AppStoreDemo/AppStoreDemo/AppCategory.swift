//
//  AppCategory.swift
//  AppStoreDemo
//
//  Created by Ryan Kim on 9/3/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class AppCategory {
    var name: String?
    var apps: [App]?
    var type: String?
    
    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory]) -> ()) {
        let dataURL = "https://api.letsbuildthatapp.com/appstore/featured"
        
        guard let url = URL(string: dataURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                 let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                
                var appCategories = [AppCategory]()
                
                for dict in json["categories"] as! [[String:AnyObject]] {
                    let appCategory = AppCategory()
                    appCategory.name = dict["name"] as? String
                    appCategory.type = dict["type"] as? String
                    
                    let appDictionary = dict["apps"] as! [[String: AnyObject]]
                    var apps = [App]()
                    
                    for app in appDictionary {
                        let indivApp = App()
                        for item in app {
                            switch item.key {
                                case "Category":
                                    indivApp.category = item.value as? String
                                case "Id":
                                    indivApp.id = item.value as? Int
                                case "Name":
                                    indivApp.name = item.value as? String
                                case "Price":
                                    indivApp.price = item.value as? Float
                                case "ImageName":
                                    indivApp.imageName = item.value as? String
                                default:
                                print("Not needed")
                            }
                        }
                        apps.append(indivApp)
                    }
                    appCategory.apps = apps
                    appCategories.append(appCategory)
                }
                DispatchQueue.main.async {
                    completionHandler(appCategories)
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
        
        

    }

}


