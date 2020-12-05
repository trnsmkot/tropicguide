//
//  DistrictTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class PointTableViewCell: UITableViewCell {

    private var categoryImageView = UIImageView()
    private var title = UILabel()
    private var distr = UILabel()
    private var distrBG = UIView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(item: PointItemShort) {
        if let coverUrl = item.cover {
            categoryImageView.kf.indicatorType = .activity
            categoryImageView.kf.setImage(with: URL(string: coverUrl))
        } else {
            // TODO ...
        }

        title.text = item.name?.uppercased() ?? ""
        if let text = item.district {
             distr.text = text
        } else {
            distrBG.isHidden = true
        }
       
    }

    private func setupViews() {
        contentView.backgroundColor = .mainBgGray

        categoryImageView.backgroundColor = .lightGray
        categoryImageView.contentMode = .scaleAspectFill
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.cornerRadius = 5

        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryImageView)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: categoryImageView)
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0]|", views: categoryImageView)


        let titleWrapper = UIView()
        titleWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleWrapper)
        contentView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: titleWrapper)
        contentView.addConstraintsWithFormat(format: "V:[v0]-5-|", views: titleWrapper)
        titleWrapper.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width - 50).isActive = true

        let titleBG = UIView()
        titleBG.backgroundColor = .black
        titleBG.alpha = 0.6
        titleBG.translatesAutoresizingMaskIntoConstraints = false
        titleWrapper.addSubview(titleBG)
        titleWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: titleBG)
        titleWrapper.addConstraintsWithFormat(format: "V:|[v0]|", views: titleBG)

        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .white
        title.numberOfLines = 2
        titleWrapper.addSubview(title)
        titleWrapper.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)
        titleWrapper.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: title)
        
        let distrWrapper = UIView()
        distrWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distrWrapper)
        contentView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: distrWrapper)
        contentView.addConstraintsWithFormat(format: "V:|-15-[v0]", views: distrWrapper)
        distrWrapper.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width - 50).isActive = true
        
        distrBG.backgroundColor = .black
        distrBG.alpha = 0.5
        distrBG.translatesAutoresizingMaskIntoConstraints = false
        distrWrapper.addSubview(distrBG)
        distrWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: distrBG)
        distrWrapper.addConstraintsWithFormat(format: "V:|[v0]|", views: distrBG)
        
        distr.translatesAutoresizingMaskIntoConstraints = false
        distr.font = UIFont.systemFont(ofSize: 12)
        distr.textColor = .white
        distr.numberOfLines = 1
        distrWrapper.addSubview(distr)
        distrWrapper.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: distr)
        distrWrapper.addConstraintsWithFormat(format: "V:|-3-[v0]-3-|", views: distr)


    }
}
