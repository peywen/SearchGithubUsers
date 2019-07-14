//
//  UserCell.swift
//  searchUser2
//
//  Created by Serena on 2019/7/13.
//  Copyright © 2019 Serena. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell {
    private var imageView: UIImageView
    private var nameLabel: UILabel
    public var imageUrl: String? {
        didSet {
            if let imageUrl = self.imageUrl {
                self.imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
            }
        }
    }
    
    public var name: String? {
        didSet {
            if let name = self.name {
                self.nameLabel.text = name
            }
        }
    }
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect.zero)
        nameLabel = UILabel(frame: CGRect.zero)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        imageView.addSubview(nameLabel)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: ["imageView": imageView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: nil, views: ["imageView": imageView]))
        
        imageView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        imageView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20.0))
        imageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[nameLabel]-|", options: [], metrics: [:], views: ["nameLabel": nameLabel]))
        
        nameLabel.text = ""
        nameLabel.font = UIFont(name: "Helvetica", size: 16.0)
        nameLabel.textColor = .white
        nameLabel.backgroundColor = .black
        nameLabel.alpha = 0.7
        nameLabel.textAlignment = .center
    }
    
    func updateCellWithModel(model: User?) {
        guard let model = model else { return }
        self.imageUrl = model.avatar_url
        self.name = model.login
    }
}
