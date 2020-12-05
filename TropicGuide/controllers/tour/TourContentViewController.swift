//
//  InfosViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class TourContentViewController: BaseViewController, UICollectionViewDelegateFlowLayout {

    private let descTableViewCellIdentifier = "descTableViewCellIdentifier"
    private let collectionViewCellIdentifier = "imageTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    private let imageDataSource = BehaviorRelay<[TourItemImage]>(value: [])

    var tourItem: TourItem?

    let pageControl = UIPageControl()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()

    private var scrollView: UIScrollView?
    private let shortDesc = UILabel()
    private var titleLabel = UILabel()
    private var fullDescText: NSAttributedString?

    private let whatIncluded = UILabel()
    private let whatNotIncluded = UILabel()
    private let whatTakeWithMe = UILabel()

    private let programs = UILabel()

    private let phoneLabel = UILabel()

    private let programsWrapper = UIView()
    private var programList: [NSAttributedString?] = []
    private var programDescList: [NSAttributedString?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = tourItem?.ruDesc?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        if let id = tourItem?.id {
            TourViewModal.shared.getTourById(id: id)?
                    .subscribe(onNext: { response in
                        if response.successful, let data = response.data, let tour = data {
                            self.navigationItem.title = tour.ruDesc?.name ?? ""
                            self.titleLabel.text = tour.ruDesc?.name ?? ""
                            
                            self.imageDataSource.accept(tour.images)
                            self.pageControl.numberOfPages = self.imageDataSource.value.count

                            let style = "<style> *{ font-family: 'SF Pro Display', 'SF Pro Text', 'Arial'; font-size: 14px;} ul {} ul li {margin-bottom:5px;}</style>"

                            self.tourItem?.ruDesc = tour.ruDesc
                            self.shortDesc.text = tour.ruDesc?.shortDescription
                            self.fullDescText = (style + (tour.ruDesc?.description ?? "")).htmlToAttributedString

                            self.programs.attributedText = (style + "<b style=\"font-size: 20px;color:#47c9e5;\">Programs and prices</b>").htmlToAttributedString
                            self.buildPrograms(tour: tour, style: style)

                            let whatIncludedText = tour.ruDesc?.whatIncluded?.replacingOccurrences(of: "<br>", with: "")
                            self.whatIncluded.attributedText = (style + "<b style=\"font-size: 18px;color: #01cb68;\">Included</b><br><br>" + (whatIncludedText ?? "")).htmlToAttributedString
                            
                            let whatNotIncludedText = tour.ruDesc?.whatNotIncluded?.replacingOccurrences(of: "<br>", with: "")
                            self.whatNotIncluded.attributedText = (style + "<b style=\"font-size: 18px;color: #eb7591;\">Not included</b><br><br>" + (whatNotIncludedText ?? "")).htmlToAttributedString
                            
                            let whatTakeWithMeText = tour.ruDesc?.whatTakeWithMe?.replacingOccurrences(of: "<br>", with: "")
                            self.whatTakeWithMe.attributedText = (style + "<b style=\"font-size: 18px;\">Take with you</b><br><br>" + (whatTakeWithMeText ?? "")).htmlToAttributedString

                            self.phoneLabel.text = tour.phone

                            let width = self.view.frame.width - 20
                            let shortDescHeight: CGFloat = tour.ruDesc?.shortDescription?.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 16)) ?? 0
                            let whatIncludedHeight: CGFloat = self.whatIncluded.attributedText?.height(withConstrainedWidth: width) ?? 0
                            let whatNotIncludedHeight: CGFloat = self.whatNotIncluded.attributedText?.height(withConstrainedWidth: width) ?? 0
                            let whatTakeWithMeHeight: CGFloat = self.whatTakeWithMe.attributedText?.height(withConstrainedWidth: width) ?? 0

                            let programsHeight: CGFloat = self.programs.attributedText?.height(withConstrainedWidth: width) ?? 0

                            var height: CGFloat = 420 + self.view.frame.width / 16 * 9
                            height += shortDescHeight + 60 + whatIncludedHeight + whatNotIncludedHeight + whatTakeWithMeHeight + programsHeight

                            for program in self.programList {
                                height += program?.height(withConstrainedWidth: width) ?? 0
                            }
                            height += CGFloat(self.programList.count * 90)

                            self.scrollView?.contentSize = CGSize(width: self.view.frame.width, height: height)
                            self.view.layoutIfNeeded()
                        } else {
                            // Вывести ошибку получения данных ?
                        }

                        self.spinner.end()

                    }, onError: { error in
                        CustomLogger.instance.reportError(error: error)

                        self.spinner.end()
                        // Вывести ошибку получения данных ?
                    }).disposed(by: disposeBag)
        }
    }

    private func sendTourOrder(name: String, phone: String, comment: String) {
        if let id = tourItem?.id {
            spinner.start()
            TourViewModal.shared.sendTourOrder(id: id, name: name, phone: phone, comment: comment)?
                    .subscribe(onNext: { response in
                        if response.successful, let data = response.data, let result = data {
                            if (result == "ERROR") {
                                // TODO
                            } else {
                                let alert = UIAlertController(title: "Request submitted successfully", message: "Contact number: \(self.phoneLabel.text ?? ""), WhatsApp, Viber, Telegram", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        self.spinner.end()

                    }, onError: { error in
                        CustomLogger.instance.reportError(error: error)
                        self.spinner.end()
                        // Вывести ошибку получения данных ?
                    }).disposed(by: disposeBag)
        }
    }

    @objc func showOrderForm() {
//        let alert = UIAlertController(title: "Оставить заявку", message: "Заполните данные для обратной связи", preferredStyle: .alert)
//        alert.addTextField { (textField) in
//            textField.placeholder = "Имя"
//        }
//        alert.addTextField { (textField) in
//            textField.placeholder = "Телефон"
//            textField.keyboardType = .phonePad
//        }
//        alert.addTextField { (textField) in
//            textField.placeholder = "Комментарий"
//        }
//
//        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { [weak alert] (_) in
//            if let name = alert?.textFields?[0], let phone = alert?.textFields?[1], let comment = alert?.textFields?[2] {
//                self.sendTourOrder(name: name.text ?? "", phone: phone.text ?? "", comment: comment.text ?? "")
//            }
//        }))
//
//        self.present(alert, animated: true, completion: nil)
        
        
        let adViewController = WebViewController()
        adViewController.pageTitle = tourItem?.ruDesc?.name ?? ""
        adViewController.pageURL = "https://phuket-tropic-tours.ru/frame/booking/form/\(tourItem?.id ?? 0)/tropicguide/"
        navigationController?.pushViewController(adViewController, animated: true)
    }

    private func buildPrograms(tour: TourItem, style: String) {

        if let programs = tour.ruDesc?.programs {
            for program in programs {
                if (!program.hidden) {
                    var programAsHtml = style
                    programAsHtml += "<div><b style=\"font-size:20px;\">\(program.name ?? "")</b></div>";
//                    programAsHtml += "<b>Цены:</b> "
                    
                    if (program.isPrivate) {
                        programAsHtml += "Price on request"
                    } else {
                        let prices = program.prices.filter { $0.price > 0  }
                        for (index, price) in prices.enumerated() {
                            programAsHtml += "\(price.name ?? ""): <b style=\"font-size:16px;\">\(price.price)</b>฿"
                            if (index < prices.count - 1) {
                                programAsHtml += ", "
                            }
                        }
                    }
                    
//                    programAsHtml += "<br>"
//                    programAsHtml += "<b>Дни:</b> \(program.schedule ?? "")<br>"
//                    if let longTime = program.longTime, longTime != "0" {
//                          programAsHtml += "<b>Продолжительность:</b> \(longTime)ч.<br>"
//                    }
//
//                    if (program.showStartTime) {
//                        programAsHtml += "<b>Начало:</b> \(program.startTime ?? "")<br>"
//                    }
//
//                    programAsHtml += "<b>Гид:</b> \(program.guide == 0 ? "Русский гид" : program.guide == 1 ? "Английский гид" : "Без гида")<br>"
//                    programAsHtml += program.description ?? ""
                    self.programList.append(programAsHtml.htmlToAttributedString)
                    var programDescription = ""
                    if let desc = program.description  {
                        programDescription += "<br>"
                        programDescription += "<b>Program days:</b> \(program.schedule ?? "")<br>"
                        
                        if let longTime = program.longTime, longTime != "0" {
                            programDescription += "<b>Duration:</b> \(longTime)ч.<br>"
                        }
                        if (program.showStartTime) {
                            programDescription += "<b>Start:</b> \(program.startTime ?? "")<br>"
                        }
                        
                        programDescription += "<b>Guide:</b> \(program.guide == 0 ? "Russian guide" : program.guide == 1 ? "English guide" : "No guide")<br><br><br>"
                        programDescription += desc
                    }
                    self.programDescList.append((style + programDescription).htmlToAttributedString)
                }
            }
        }

        var previewLabel: UIView?
//        var previewButton: UIButton?
        for (index, program) in self.programList.enumerated() {
            let programLabel = UILabel()
            programLabel.translatesAutoresizingMaskIntoConstraints = false
            programLabel.numberOfLines = 0
            programLabel.attributedText = program
            programsWrapper.addSubview(programLabel)


            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("    Open description", for: .normal)
            button.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.tintColor = .darkGray
//            button.titleLabel?.textAlignment = .left
            button.contentHorizontalAlignment = .left
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//            button.contentHorizontalAlignment = .center
            button.setTitleColor(.darkGray, for: .normal)
            button.backgroundColor = .mainBgGray
            button.addTarget(self, action: #selector(showProgramDesc), for: .touchUpInside)
            button.tag = index
            programsWrapper.addSubview(button)
            
            let separator = UIView()
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.backgroundColor = .white
            programsWrapper.addSubview(separator)

//            programsWrapper.addConstraintsWithFormat(format: "H:|[v0]-20-[v1(40)]|", views: programLabel, button)
//            programLabel.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
           
            programsWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: programLabel)
            programsWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: button)
             programsWrapper.addConstraintsWithFormat(format: "H:|[v0]|", views: separator)

            if (index == 0) {
                programsWrapper.addConstraintsWithFormat(format: "V:|-10-[v0]-10-[v1(35)]-10-[v2(20)]", views: programLabel, button, separator)
//                programsWrapper.addConstraintsWithFormat(format: "V:|[v0]", views: programLabel)
//                programsWrapper.addConstraintsWithFormat(format: "V:|[v0]", views: button)
            }

            if (index == self.programList.count - 1) {
             
                
               
                
                programsWrapper.addConstraintsWithFormat(format: "V:[v0]-10-[v1(35)]-10-[v2(20)]|", views: programLabel, button, separator)
//                programsWrapper.addConstraintsWithFormat(format: "V:[v0]-30-|", views: programLabel)
//                programsWrapper.addConstraintsWithFormat(format: "V:[v0]-30-|", views: button)
            }

            if (index > 0) {
                if let previewLabel = previewLabel {
                    programsWrapper.addConstraintsWithFormat(format: "V:[v0]-10-[v1]-10-[v2(35)]-10-[v3(20)]", views: previewLabel, programLabel, button, separator)
//                    programsWrapper.addConstraintsWithFormat(format: "V:[v0]-10-[v1]", views: previewLabel, programLabel)
//                    programsWrapper.addConstraintsWithFormat(format: "V:[v0]-10-[v1]", views: previewButton ,button)
                }
            }
            previewLabel = separator
        }
    }

    @objc func showProgramDesc(_ sender: UIButton?) {
        if let button = sender {
            let index = button.tag
            let program = self.tourItem?.ruDesc?.programs?[index]
            let programText = self.programDescList[index]
            navigator?.openDescViewControllerByCategory(title: program?.name, desc: programText)
        }
    }

    private func setupViews() {
        view.backgroundColor = .white

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView!.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView!)

//        let titleFont = UIFont.systemFont(ofSize: 24)
//        let titleText = tourItem?.ruDesc?.name ?? ""
//        let titleHeight = heightForView(text: titleText, font: titleFont, width: view.frame.width - 40)

        let cellHeight = view.frame.width / 16 * 9
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        scrollView!.addSubview(header)

        titleLabel = UILabel(frame: CGRect(x: 10, y: cellHeight + 20, width: view.frame.width - 20, height: 60))
        titleLabel.text = tourItem?.ruDesc?.name ?? ""
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 24)

//        let line = UIView(frame: CGRect(x: 10, y: cellHeight + 80, width: view.frame.width - 20, height: 1))
//        line.backgroundColor = .lightGray

        setupImageViews(parent: header, width: view.frame.size.width)
        header.addSubview(titleLabel)
//        header.addSubview(line)

        shortDesc.translatesAutoresizingMaskIntoConstraints = false
        shortDesc.numberOfLines = 0
        scrollView!.addSubview(shortDesc)

        let button0 = UIButton()
        button0.translatesAutoresizingMaskIntoConstraints = false
        button0.setTitle("Submit your application", for: .normal)
        button0.contentHorizontalAlignment = .center
        button0.setTitleColor(.white, for: .normal)
        button0.backgroundColor = .simpleBlue
        button0.addTarget(self, action: #selector(showOrderForm), for: .touchUpInside)
        scrollView!.addSubview(button0)


        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.setTitle("Additional info", for: .normal)
        button1.contentHorizontalAlignment = .center
        button1.setTitleColor(.white, for: .normal)
        button1.backgroundColor = .lightGray
        button1.addTarget(self, action: #selector(showExtendedDesc), for: .touchUpInside)
        scrollView!.addSubview(button1)

        programs.translatesAutoresizingMaskIntoConstraints = false
        programs.numberOfLines = 0
        scrollView!.addSubview(programs)


        programsWrapper.translatesAutoresizingMaskIntoConstraints = false
        programsWrapper.backgroundColor = .mainBgGray
        scrollView?.addSubview(programsWrapper)


        whatIncluded.translatesAutoresizingMaskIntoConstraints = false
        whatIncluded.numberOfLines = 0
        scrollView!.addSubview(whatIncluded)

        whatNotIncluded.translatesAutoresizingMaskIntoConstraints = false
        whatNotIncluded.numberOfLines = 0
        scrollView!.addSubview(whatNotIncluded)

        whatTakeWithMe.translatesAutoresizingMaskIntoConstraints = false
        whatTakeWithMe.numberOfLines = 0
        scrollView!.addSubview(whatTakeWithMe)


        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit your application", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .simpleBlue
        button.addTarget(self, action: #selector(showOrderForm), for: .touchUpInside)
        scrollView!.addSubview(button)

        let orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.textAlignment = .center
        orLabel.text = "or"
        scrollView!.addSubview(orLabel)

        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.font = UIFont.systemFont(ofSize: 20)
        phoneLabel.textAlignment = .center
        scrollView!.addSubview(phoneLabel)


        let msgBlock = UIView()
        msgBlock.translatesAutoresizingMaskIntoConstraints = false
        scrollView!.addSubview(msgBlock)

        buildMessengers(parent: msgBlock)

        let width = view.frame.size.width - 20
        scrollView!.addConstraintsWithFormat(format: "H:|[v0(\(width))]", views: header)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: shortDesc)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: programs)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: programsWrapper)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: whatIncluded)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: whatNotIncluded)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: whatTakeWithMe)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: orLabel)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: phoneLabel)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: msgBlock)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: button)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: button0)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: button1)
        scrollView!.addConstraintsWithFormat(
                format: "V:|[v0(\(80 + cellHeight))]-20-[v1]-10-[v2]-10-[v3]-40-[v4]-20-[v5]-20-[v6]-10-[v7]-10-[v8]-10-[v9(40)]-10-[v10]-10-[v11][v12(50)]",
                views: header, shortDesc, button0, button1, programs, programsWrapper, whatIncluded, whatNotIncluded, whatTakeWithMe, button, orLabel, phoneLabel, msgBlock)


    }

    private func setupImageViews(parent: UIView, width: CGFloat) {
        let cellHeight = width / 16 * 9

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        parent.addSubview(collectionView)

        let zoomImageView = UIImageView(frame: CGRect(x: view.frame.width - 50, y: 10, width: 40, height: 40))
        zoomImageView.contentMode = .scaleAspectFit
        zoomImageView.image = UIImage(named: "zoom-in")?.withRenderingMode(.alwaysTemplate)
        zoomImageView.tintColor = .white
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImageZoomViewController)))
        parent.addSubview(zoomImageView)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .simpleBlue
        parent.addSubview(pageControl)

        parent.addConstraintsWithFormat(format: "H:|[v0(\(width))]", views: collectionView)
        parent.addConstraintsWithFormat(format: "H:|[v0(\(width))]", views: pageControl)
        parent.addConstraintsWithFormat(format: "V:|[v0(\(cellHeight))][v1(20)]", views: collectionView, pageControl)

        self.imageDataSource.asObservable()
                .bind(to: collectionView.rx.items(cellIdentifier: collectionViewCellIdentifier)) { row, item, cell in
                    guard let addCell = cell as? ImageCollectionViewCell else {
                        return
                    }
                    addCell.setTourData(item: item)
                }.disposed(by: self.disposeBag)
    }

    @objc func showExtendedDesc() {
        navigator?.openDescViewControllerByCategory(title: tourItem?.ruDesc?.name, desc: fullDescText)
    }

    @objc func openImageZoomViewController() {
        let imageUrl = self.imageDataSource.value[self.pageControl.currentPage].originalPath
        navigator?.openZoomImageViewControllerByCategory(imageUrl)
    }

    private func buildMessengers(parent: UIView) {
        let phoneImage = UIImageView(image: UIImage(named: "phone"))
        phoneImage.translatesAutoresizingMaskIntoConstraints = false
        phoneImage.isUserInteractionEnabled = true
        phoneImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callPhone)))
        parent.addSubview(phoneImage)

        let whatsappImage = UIImageView(image: UIImage(named: "whatsapp"))
        whatsappImage.translatesAutoresizingMaskIntoConstraints = false
        whatsappImage.isUserInteractionEnabled = true
        whatsappImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callWhatsApp)))
        parent.addSubview(whatsappImage)

        let viber = UIImageView(image: UIImage(named: "viber"))
        viber.translatesAutoresizingMaskIntoConstraints = false
        viber.isUserInteractionEnabled = true
        viber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callViber)))
        parent.addSubview(viber)

        let telergram = UIImageView(image: UIImage(named: "telegram"))
        telergram.translatesAutoresizingMaskIntoConstraints = false
        telergram.isUserInteractionEnabled = true
        telergram.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callTelegram)))
        parent.addSubview(telergram)

        let width = view.frame.size.width - 20
        parent.addConstraintsWithFormat(
                format: "H:|-\(width / 2 - 90)-[v0(40)]-10-[v1(40)]-10-[v2(40)]-10-[v3(40)]",
                views: phoneImage, whatsappImage, telergram, viber)
        parent.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: phoneImage)
        parent.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: whatsappImage)
        parent.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: telergram)
        parent.addConstraintsWithFormat(format: "V:|-10-[v0(40)]", views: viber)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.width / 16 * 9)
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    @objc func callPhone() {
        if let phone = phoneLabel.text, let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func callWhatsApp() {
        if let phone = phoneLabel.text, let url = URL(string: "whatsapp://send?phone=\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func callViber() {
        if let phone = phoneLabel.text, let url = URL(string: "viber://chat?number=\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIPasteboard.general.string = phone
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func callTelegram() {
        if let phone = phoneLabel.text, let url = URL(string: "tg://msg?to=\(phone)"), UIApplication.shared.canOpenURL(url) {
            UIPasteboard.general.string = phone
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
