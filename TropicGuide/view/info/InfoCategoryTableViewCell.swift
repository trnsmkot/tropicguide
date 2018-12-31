//
//  TourCategoryTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class InfoCategoryTableViewCell: UITableViewCell {

    private var title = UILabel()
    private var rightImageView = UIImageView()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(category: InfoCategory) {
        title.text = category.name ?? ""
    }

    private func setupViews() {
        contentView.backgroundColor = .mainBgGray

        let contentWrapper = UIView()
        contentWrapper.backgroundColor = .white
        contentWrapper.layer.cornerRadius = 5
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(contentWrapper)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: contentWrapper)
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0]|", views: contentWrapper)

        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = .black
        contentWrapper.addSubview(title)
        contentWrapper.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: title)

        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.image = UIImage(named: "right")?.withRenderingMode(.alwaysTemplate)
        rightImageView.tintColor = .lightGray
        rightImageView.contentMode = .scaleAspectFit
        contentWrapper.addSubview(rightImageView)
        contentWrapper.addConstraintsWithFormat(format: "V:|-15-[v0]-15-|", views: rightImageView)

        contentWrapper.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1(10)]-10-|", views: title, rightImageView)
    }
}
