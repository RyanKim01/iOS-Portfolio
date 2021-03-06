//
//  AppDetailVC.swift
//  AppStoreDemo
//
//  Created by Ryan Kim on 9/24/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class AppDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let headerID = "headerID"
    
    var app: App?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! AppDetailHeader
        header.app = app
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

class AppDetailHeader: BaseCell {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    var app: App? {
        didSet {
            if let imageName = app?.ImageName {
                imageView.image = UIImage(named: imageName)
            }
            nameLabel.text = app?.Name
            
            if let price = app?.Price {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let segmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = .darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "TEST"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Buy", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
    imageView.translatesAutoresizingMaskIntoConstraints = false
        
       addConstraints(VisualFormat: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
       addConstraints(VisualFormat: "V:|-14-[v0(100)]|", views: imageView)
        
        addConstraints(VisualFormat: "V:|-14-[v0(20)]", views: nameLabel)
        
       addConstraints(VisualFormat: "H:|-40-[v0]-40-|", views: segmentedControl)
       addConstraints(VisualFormat: "V:[v0(34)]-8-|", views: segmentedControl)
        
        addConstraints(VisualFormat: "H:[v0(60)]-20-|", views: buyButton)
        addConstraints(VisualFormat: "V:[v0(32)]-59-|", views: buyButton)
        
        addConstraints(VisualFormat: "H:|[v0]|", views: dividerLineView)
        addConstraints(VisualFormat: "V:[v0(0.5)]|", views: dividerLineView)
        
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}

extension UIView {
    func addConstraints(VisualFormat: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: VisualFormat, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
