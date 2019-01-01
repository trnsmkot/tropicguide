//
//  TopAdCollectionViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    private var pointImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(item: PointImage) {
        if let url = item.path {
            pointImageView.kf.indicatorType = .activity
            pointImageView.kf.setImage(with: URL(string: url))
        } else {
            // TODO ...
        }
    }

    private func setupViews() {
        contentView.backgroundColor = .mainBgGray

        pointImageView.backgroundColor = .lightGray
        pointImageView.contentMode = .scaleAspectFill
        pointImageView.clipsToBounds = true

        pointImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pointImageView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: pointImageView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: pointImageView)
    }
}
