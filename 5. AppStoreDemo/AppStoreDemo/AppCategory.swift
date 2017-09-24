//
//  AppCategory.swift
//  AppStoreDemo
//
//  Created by Ryan Kim on 9/3/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class AppCategory: Decodable {
    var name: String?
    var apps: [App]?
    var type: String?
    
    static func fetchFeaturedApps(completionHandler: @escaping (FeaturedApp) -> ()) {
        let dataURL = "https://api.letsbuildthatapp.com/appstore/featured"
        
        guard let url = URL(string: dataURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let featuredApp = try JSONDecoder().decode(FeaturedApp.self, from: data)

                DispatchQueue.main.async {
                    completionHandler(featuredApp)
                }
                
            } catch let jsonErr {
                print(jsonErr)
            }
        }.resume()
        
        

    }

}


