//
//  TourCategoryTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class TourCategoryTableViewCell: UITableViewCell {

    private var categoryImageView = UIImageView()
    private var title = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(category: TourCategory) {
        if let coverUrl = category.cover {
            categoryImageView.kf.indicatorType = .activity
            categoryImageView.kf.setImage(with: URL(string: coverUrl))
        } else {
            // TODO ...
        }

        title.text = category.name?.uppercased() ?? ""
    }

    private func setupViews() {
        categoryImageView.backgroundColor = .lightGray
        categoryImageView.contentMode = .scaleAspectFill
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.cornerRadius = 5

        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryImageView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: categoryImageView)
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0]|", views: categoryImageView)


        let titleWrapper = UIView()
        titleWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleWrapper)
        titleWrapper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleWrapper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

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
        titleWrapper.addSubview(title)
        titleWrapper.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)
        titleWrapper.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: title)


    }
}
