//
//  TourTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import Kingfisher

class TourTableViewCell: UITableViewCell {

    private var categoryImageView = UIImageView()
    private var title = UILabel()
    private var price = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(tour: TourItem) {
        if let coverUrl = tour.cover {
            categoryImageView.kf.indicatorType = .activity
            categoryImageView.kf.setImage(with: URL(string: coverUrl))
        } else {
            // TODO ...
        }

        title.text = tour.ruDesc?.name?.uppercased() ?? ""
        price.text = tour.price?.uppercased() ?? ""
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
//        contentView.addConstraintsWithFormat(format: "V:[v0]-30-|", views: titleWrapper)
        titleWrapper.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width - 30).isActive = true

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


        let priceWrapper = UIView()
        priceWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceWrapper)
        contentView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: priceWrapper)
        priceWrapper.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width - 30).isActive = true

        let priceBG = UIView()
        priceBG.backgroundColor = .black
        priceBG.alpha = 0.6
        priceBG.translatesAutoresizingMaskIntoConstraints = false
        priceWrapper.addSubview(priceBG)
        priceWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: priceBG)
        priceWrapper.addConstraintsWithFormat(format: "V:|[v0]|", views: priceBG)

        price.translatesAutoresizingMaskIntoConstraints = false
        price.font = UIFont.systemFont(ofSize: 14)
        price.textColor = .white
        priceWrapper.addSubview(price)
        priceWrapper.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: price)
        priceWrapper.addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: price)

        contentView.addConstraintsWithFormat(format: "V:[v0]-3-[v1]-5-|", views: titleWrapper, priceWrapper)
    }
}
