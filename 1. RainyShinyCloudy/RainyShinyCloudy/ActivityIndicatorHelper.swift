//
//  ActivityIndicatorHelper.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/12/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation
import UIKit

func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    let mainContainer: UIView = UIView(frame: viewContainer.frame)
    mainContainer.center = viewContainer.center
    mainContainer.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
    mainContainer.alpha = 0.7
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = true
    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
    viewBackgroundLoading.center = viewContainer.center
    viewBackgroundLoading.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
    viewBackgroundLoading.alpha = 1
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    
    let loadingText: UILabel = UILabel(frame: CGRect(x: 0 ,y: 0 ,width: 250,height: 30))
    loadingText.center = CGPoint(x: mainContainer.frame.size.width / 2, y: mainContainer.frame.size.height / 2 + 60)
    loadingText.text = "Retrieving the data..."
    loadingText.numberOfLines = 2
    loadingText.textAlignment = .center
    loadingText.textColor = UIColor.black
    
    if startAnimate!{
        viewContainer.addSubview(mainContainer)
        mainContainer.addSubview(viewBackgroundLoading)
        mainContainer.addSubview(loadingText)
        viewBackgroundLoading.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }else{
        for subview in viewContainer.subviews{
            if subview.tag == 789456123{
                subview.removeFromSuperview()
            }
        }
    }
    return activityIndicatorView
}
