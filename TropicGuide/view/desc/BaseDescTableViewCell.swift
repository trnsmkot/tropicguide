//
//  BaseDescTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import Kingfisher

class BaseDescTableViewCell: UITableViewCell {

    var descImageView = UIImageView()
    var heightImageConstraint: NSLayoutConstraint?

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(item: CommonDescription) {
        switch (item.type) {
        case .IMAGE:
            setupImageViews(item: item)
        case .INSTA:
            print("INSTA")
        case .TEXT:
            setupTextViews(item: item)
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .white
    }

    private func setupTextViews(item: CommonDescription) {

        let title = UILabel()
        title.text = item.title
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .black
        contentView.addSubview(title)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: title)

        let desc = UILabel()
        desc.numberOfLines = 100
        desc.text = item.text
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.textColor = .black
        contentView.addSubview(desc)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: desc)

        contentView.addConstraintsWithFormat(format: "V:|-5-[v0]-8-[v1]-20-|", views: title, desc)
    }

    private func setupImageViews(item: CommonDescription) {

        descImageView.translatesAutoresizingMaskIntoConstraints = false
        descImageView.contentMode = .scaleAspectFit
        descImageView.clipsToBounds = true
        descImageView.layer.cornerRadius = 2
        contentView.addSubview(descImageView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: descImageView)

        heightImageConstraint = descImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width / 16 * 9)
        heightImageConstraint?.priority = UILayoutPriority.defaultHigh
        heightImageConstraint?.isActive = true


        let title = UILabel()
        title.text = item.text
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = .black
        contentView.addSubview(title)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: title)

        contentView.addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-20-|", views: descImageView, title)

//        if let imageUrl = item.imagePath {
//            descImageView.kf.indicatorType = .activity
//            descImageView.kf.setImage(with: URL(string: imageUrl)) { result in
//                switch result {
//                case .success(let value):
////                    descImageView.image = value.image
//                    print(value.image.size.width, value.image.size.height)
//                    let width = (self.contentView.frame.width + 40) / value.image.size.width * value.image.size.height
//
//
////                    let aspect = value.image.size.width / value.image.size.height
////                    let constraint = NSLayoutConstraint(item: descImageView, attribute: .width, relatedBy: .equal, toItem: descImageView, attribute: .height, multiplier: aspect, constant: 0.0)
////                    constraint.priority = UILayoutPriority.required
////                    descImageView.addConstraint(constraint)
//
//                    heightImageConstraint.constant =  self.contentView.frame.width / value.image.size.width * value.image.size.height
//                case .failure(let error):
//                    print("Job failed: \(error.localizedDescription)")
//                }
//            }
//        }


    }
}
