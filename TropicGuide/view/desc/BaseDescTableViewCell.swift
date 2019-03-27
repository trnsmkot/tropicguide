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
        contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        switch (item.type) {
        case .IMAGE:
            setupImageViews(item: item)
        case .INSTA:
            setupInstaViews(item: item)
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
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)

        let desc = UILabel()
        desc.numberOfLines = 100
        
        let notCleanText = item.text ?? ""
        let regex = try! NSRegularExpression(pattern: "<[^>]*>", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, notCleanText.count)
        let cleanedText = regex.stringByReplacingMatches(in: notCleanText, options: [], range: range, withTemplate: "\r\n")
        
        desc.text = cleanedText
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.textColor = .black
        contentView.addSubview(desc)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: desc)

        contentView.addConstraintsWithFormat(format: "V:|-5-[v0]-8-[v1]-20-|", views: title, desc)
    }

    private func setupImageViews(item: CommonDescription) {

        descImageView.translatesAutoresizingMaskIntoConstraints = false
        descImageView.contentMode = .scaleAspectFill
        descImageView.clipsToBounds = true
        descImageView.layer.cornerRadius = 2
        contentView.addSubview(descImageView)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: descImageView)

        heightImageConstraint = descImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width / 4 * 3)
        heightImageConstraint?.priority = UILayoutPriority.defaultHigh
        heightImageConstraint?.isActive = true


        let title = UILabel()
        title.text = item.text
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = .black
        contentView.addSubview(title)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)

        contentView.addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-20-|", views: descImageView, title)


        if let imageUrl = item.imagePath {
            descImageView.kf.indicatorType = .activity
            descImageView.kf.setImage(with: URL(string: imageUrl))
        }
    }

    private var instaAccount = ""
    private var instaBrowserUrl = ""

    private func setupInstaViews(item: CommonDescription) {
        if let array = item.text?.split(separator: "|"), array.count > 1 {
            instaBrowserUrl = String(array[0])
            instaAccount = String(array[1])
        }

        descImageView.translatesAutoresizingMaskIntoConstraints = false
        descImageView.contentMode = .scaleAspectFit
        descImageView.clipsToBounds = true
        descImageView.layer.cornerRadius = 2
        contentView.addSubview(descImageView)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: descImageView)

        heightImageConstraint = descImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width)
        heightImageConstraint?.priority = UILayoutPriority.defaultHigh
        heightImageConstraint?.isActive = true

        //instagram
        let titleWrapper = UIView()
        titleWrapper.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleWrapper)
        contentView.addConstraintsWithFormat(format: "H:|-15-[v0]", views: titleWrapper)
        contentView.addConstraintsWithFormat(format: "V:|-5-[v0]", views: titleWrapper)

        let titleBG = UIView()
        titleBG.backgroundColor = .black
        titleBG.alpha = 0.6
        titleBG.translatesAutoresizingMaskIntoConstraints = false
        titleWrapper.addSubview(titleBG)
        titleWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: titleBG)
        titleWrapper.addConstraintsWithFormat(format: "V:|[v0]|", views: titleBG)

        let instaLogo = UIImageView()
        instaLogo.translatesAutoresizingMaskIntoConstraints = false
        instaLogo.image = UIImage(named: "instagram")?.withRenderingMode(.alwaysTemplate)
        instaLogo.contentMode = .scaleAspectFit
        instaLogo.tintColor = .white
        titleWrapper.addSubview(instaLogo)
        titleWrapper.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: instaLogo)

        let title = UILabel()
        title.text = instaAccount
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .white
        titleWrapper.addSubview(title)
        titleWrapper.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: title)

        titleWrapper.addConstraintsWithFormat(format: "H:|-5-[v0(30)]-10-[v1]-10-|", views: instaLogo, title)


        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Открыть в Instagram", for: .normal)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        contentView.addSubview(button)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: button)

        contentView.addConstraintsWithFormat(format: "V:|[v0]-5-[v1(40)]-10-|", views: descImageView, button)
    }

    @objc func openInstagram() {
        let instagramHooks = "instagram://user?username=" + instaAccount
        let instagramUrl = URL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            UIApplication.shared.openURL(instagramUrl!)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(URL(string: instaBrowserUrl)!)
        }
    }
}
