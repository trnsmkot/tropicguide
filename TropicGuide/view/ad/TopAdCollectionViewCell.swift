//
//  TopAdCollectionViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class TopAdCollectionViewCell: UICollectionViewCell {

    private var categoryImageView = UIImageView()
    private var title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(item: TopAdItem) {
        if let coverUrl = item.image {
            categoryImageView.kf.indicatorType = .activity
            categoryImageView.kf.setImage(with: URL(string: coverUrl))
        } else {
            // TODO ...
        }

        title.text = item.title?.uppercased() ?? ""
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
        titleWrapper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleWrapper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleWrapper.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width - 40).isActive = true

        let titleBG = UIView()
        titleBG.backgroundColor = .black
        titleBG.alpha = 0.6
        titleBG.translatesAutoresizingMaskIntoConstraints = false
        titleWrapper.addSubview(titleBG)
        titleWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: titleBG)
        titleWrapper.addConstraintsWithFormat(format: "V:|[v0]|", views: titleBG)

        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.numberOfLines = 2
        title.textAlignment = .center
        title.textColor = .white
        titleWrapper.addSubview(title)
        titleWrapper.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)
        titleWrapper.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: title)


    }
}
