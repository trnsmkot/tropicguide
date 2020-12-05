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
    var zoomImageView = UIImageView()
    var heightImageConstraint: NSLayoutConstraint?
    var navigator: Navigator?
    var imageUrl: String?
    
    var point: PointItemShort?
    var tour: TourItem?

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
            case .IMAGE: setupImageViews(item: item)
            case .INSTA: setupInstaViews(item: item)
            case .TEXT: setupTextViews(item: item)
            case .LINK: setupLinkViews(item: item)
            case .TOUR: setupLinkViews(item: item)
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

        let notCleanText = (item.text ?? "").replacingOccurrences(of: "\r\n", with: "", options: .literal, range: nil)
//        let notCleanText = item.text ?? ""
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

        zoomImageView.translatesAutoresizingMaskIntoConstraints = false
        zoomImageView.layer.shadowColor = UIColor.lightGray.cgColor
        zoomImageView.layer.shadowOffset = CGSize(width: 5, height: 5)
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.image = UIImage(named: "zoom-in")?.withRenderingMode(.alwaysTemplate)
        zoomImageView.tintColor = .white
        zoomImageView.isUserInteractionEnabled = true
        contentView.addSubview(zoomImageView)
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: zoomImageView)
        contentView.addConstraintsWithFormat(format: "H:[v0(40)]-20-|", views: zoomImageView)

        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImageZoomViewController)))

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


        self.imageUrl = item.imagePath
        if let imageUrl = item.imagePath {
            descImageView.kf.indicatorType = .activity
            descImageView.kf.setImage(with: URL(string: imageUrl))
        }
    }
    
    private func setupLinkViews(item: CommonDescription) {
        descImageView.translatesAutoresizingMaskIntoConstraints = false
        descImageView.contentMode = .scaleAspectFill
        descImageView.clipsToBounds = true
        descImageView.layer.cornerRadius = 2
        contentView.addSubview(descImageView)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: descImageView)

        heightImageConstraint = descImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width / 16 * 9)
        heightImageConstraint?.priority = UILayoutPriority.defaultHigh
        heightImageConstraint?.isActive = true


        let title = UILabel()
        title.text = item.title
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = .black
        contentView.addSubview(title)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)

        let desc = UILabel()
        desc.numberOfLines = 100
        desc.text = item.text
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.systemFont(ofSize: 14)
        desc.textColor = .black
        contentView.addSubview(desc)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: desc)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Read more", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(.simpleBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        if (item.type == .LINK) {
            button.addTarget(self, action: #selector(openPointContentViewController), for: .touchUpInside)
        }
        if (item.type == .TOUR) {
            button.addTarget(self, action: #selector(openTourContentViewController), for: .touchUpInside)
        }
        contentView.addSubview(button)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: button)
        
        contentView.addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-5-[v2]-5-[v3]-20-|", views: descImageView, title, desc, button)

        if let pointId =  item.pointId {
            self.point = PointItemShort()
            self.point?.id = pointId
            
            if let title = item.title {
                let array = title.split(separator: ".")
                if (array.count > 1) {
                    self.point?.name = "\(array[1])"
                }
            }
            
            self.tour = TourItem()
            self.tour?.id = pointId
        }
        
        self.imageUrl = item.imagePath
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
        button.setTitle("Open Instagram", for: .normal)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(openPointContentViewController), for: .touchUpInside)
        contentView.addSubview(button)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: button)

        contentView.addConstraintsWithFormat(format: "V:|[v0]-5-[v1(40)]-10-|", views: descImageView, button)
    }

    @objc func openInstagram() {
        let instagramHooks = "instagram://user?username=" + instaAccount
        let instagramUrl = URL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl!) {
            UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(URL(string: instaBrowserUrl)!, options: [:], completionHandler: nil)
        }
    }

    @objc func openImageZoomViewController() {
        navigator?.openZoomImageViewControllerByCategory(imageUrl)
    }
    
    @objc func openTourContentViewController() {
        if let tour = self.tour {
            navigator?.openTourContentViewController(tour)
        }
    }
    
    @objc func openPointContentViewController() {
        if let point = self.point {
            navigator?.openPointContentViewController(point)
        }
    }
}
