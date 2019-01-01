//
//  TourCategoryTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import Kingfisher


class PointCategoryTableViewCell: UITableViewCell {

    private var title = UILabel()
    private var rightImageView = UIImageView()
    private var iconImageView = UIImageView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(category: PointCategory) {
        title.text = category.name ?? ""
        if let iconUrl = category.icon {
            iconImageView.kf.indicatorType = .activity
            iconImageView.kf.setImage(with: URL(string: iconUrl))
        } else {
            // TODO ...
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .mainBgGray

        let contentWrapper = UIView()
        contentWrapper.backgroundColor = .white
        contentWrapper.layer.cornerRadius = 5
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(contentWrapper)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: contentWrapper)
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0]|", views: contentWrapper)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(iconImageView)
        contentWrapper.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: iconImageView)

        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.numberOfLines = 2
        title.textColor = .black
        contentWrapper.addSubview(title)
        contentWrapper.addConstraintsWithFormat(format: "V:|[v0]|", views: title)

        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.image = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
        rightImageView.tintColor = .lightGray
        rightImageView.contentMode = .scaleAspectFit
        contentWrapper.addSubview(rightImageView)
        contentWrapper.addConstraintsWithFormat(format: "V:|-15-[v0]-15-|", views: rightImageView)

        contentWrapper.addConstraintsWithFormat(format: "H:|-10-[v0(20)]-10-[v1]-10-[v2(10)]-10-|", views: iconImageView, title, rightImageView)
    }
}
