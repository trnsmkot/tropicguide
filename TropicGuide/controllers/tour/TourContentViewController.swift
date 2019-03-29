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

    private let imageDataSource = Variable<[TourItemImage]>([])

    var tourItem: TourItem?

    let pageControl = UIPageControl()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()

    private var scrollView: UIScrollView?
    private let shortDesc = UILabel()
    private let fullDesc = UILabel()

    private let whatIncluded = UILabel()
    private let whatNotIncluded = UILabel()
    private let whatTakeWithMe = UILabel()

    private let programs = UILabel()

    private let phoneLabel = UILabel()

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
                            self.imageDataSource.value = tour.images
                            self.pageControl.numberOfPages = self.imageDataSource.value.count

                            let style = "<style> *{ font-family: 'SF Pro Display', 'SF Pro Text', 'Arial'; font-size: 14px;}</style>"

                            self.shortDesc.text = tour.ruDesc?.shortDescription
                            self.fullDesc.attributedText = (style + (tour.ruDesc?.description ?? "")).htmlToAttributedString

                            self.programs.attributedText = (style + "<b style=\"color:#47c9e5;\">ПРОГРАММЫ И ЦЕНЫ</b><br><br>" + self.buildPrograms(tour: tour)).htmlToAttributedString

                            self.whatIncluded.attributedText = (style + "<b style=\"color: #01cb68;\">ВКЛЮЧЕНО</b><br><br>" + (tour.ruDesc?.whatIncluded ?? "")).htmlToAttributedString
                            self.whatNotIncluded.attributedText = (style + "<b style=\"color: #eb7591;\">НЕ ВКЛЮЧЕНО</b><br><br>" + (tour.ruDesc?.whatNotIncluded ?? "")).htmlToAttributedString
                            self.whatTakeWithMe.attributedText = (style + "<b>ВЗЯТЬ С СОБОЙ</b><br><br>" + (tour.ruDesc?.whatTakeWithMe ?? "")).htmlToAttributedString

                            self.phoneLabel.text = tour.phone

                            let width = self.view.frame.width - 20
                            let shortDescHeight: CGFloat = tour.ruDesc?.shortDescription?.height(withConstrainedWidth: width, font: UIFont.systemFont(ofSize: 16)) ?? 0
                            let fullDescHeight: CGFloat = self.fullDesc.attributedText?.height(withConstrainedWidth: width) ?? 0
                            let whatIncludedHeight: CGFloat = self.whatIncluded.attributedText?.height(withConstrainedWidth: width) ?? 0
                            let whatNotIncludedHeight: CGFloat = self.whatNotIncluded.attributedText?.height(withConstrainedWidth: width) ?? 0
                            let whatTakeWithMeHeight: CGFloat = self.whatTakeWithMe.attributedText?.height(withConstrainedWidth: width) ?? 0
                            let programsHeight: CGFloat = self.programs.attributedText?.height(withConstrainedWidth: width) ?? 0

                            var height: CGFloat = 380 + self.view.frame.width / 16 * 9
                            height += shortDescHeight + fullDescHeight + whatIncludedHeight + whatNotIncludedHeight + whatTakeWithMeHeight + programsHeight


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
                                let alert = UIAlertController(title: "Заявка успешно отправлена", message: "Контакнтый телефон: \(self.phoneLabel.text ?? ""), WhatsApp, Viber, Telegram", preferredStyle: .alert)
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
        let alert = UIAlertController(title: "Оставить заявку", message: "Заполните данные для обратной связи", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Имя"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Телефон"
            textField.keyboardType = .phonePad
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Комментарий"
        }

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Отправить", style: .default, handler: { [weak alert] (_) in
            if let name = alert?.textFields?[0], let phone = alert?.textFields?[1], let comment = alert?.textFields?[2] {
                self.sendTourOrder(name: name.text ?? "", phone: phone.text ?? "", comment: comment.text ?? "")
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }

    private func buildPrograms(tour: TourItem) -> String {
        var programAsHtml = ""
        if let programs = tour.ruDesc?.programs {
            for program in programs {
                if (!program.hidden) {
                    programAsHtml += "<div><b style=\"font-size:18px;\">\(program.name ?? "")</b></div>";

                    programAsHtml += "<b>Цены:</b> "
                    for (index, price) in program.prices.enumerated() {
                        programAsHtml += "\(price.type?.name ?? ""): \(price.price)฿"
                        if (index < program.prices.count - 1) {
                            programAsHtml += ", "
                        }
                    }
                    programAsHtml += "<br>"
                    programAsHtml += "<b>Дни:</b> \(program.schedule ?? "")<br>"
                    programAsHtml += "<b>Продолжительность:</b> \(program.longTime ?? "")<br>"
                    if (program.showStartTime) {
                        programAsHtml += "<b>Начало:</b> \(program.startTime ?? "")<br>"
                    }

                    programAsHtml += "<b>Гид:</b> \(program.guide == 0 ? "Русский гид" : program.guide == 1 ? "Английский гид" : "Без гида")<br><br>"
                    programAsHtml += program.description ?? ""
                    programAsHtml += "<br>"
                }
            }
        }

        return programAsHtml
    }

    private func setupViews() {
        view.backgroundColor = .white

        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView!.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView!)

        let cellHeight = view.frame.width / 16 * 9
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false

        scrollView!.addSubview(header)

        let title = UILabel(frame: CGRect(x: 10, y: cellHeight + 20, width: view.frame.width - 20, height: 60))
        title.text = tourItem?.ruDesc?.name ?? ""
        title.textColor = .black
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 24)

        let line = UIView(frame: CGRect(x: 10, y: cellHeight + 80, width: view.frame.width - 20, height: 1))
        line.backgroundColor = .lightGray

        setupImageViews(parent: header, width: view.frame.size.width)
        header.addSubview(title)
        header.addSubview(line)

        shortDesc.translatesAutoresizingMaskIntoConstraints = false
        shortDesc.numberOfLines = 0
        scrollView!.addSubview(shortDesc)

        let button0 = UIButton()
        button0.translatesAutoresizingMaskIntoConstraints = false
        button0.setTitle("Оставить заявку", for: .normal)
        button0.contentHorizontalAlignment = .center
        button0.setTitleColor(.white, for: .normal)
        button0.backgroundColor = .simpleBlue
        button0.addTarget(self, action: #selector(showOrderForm), for: .touchUpInside)
        scrollView!.addSubview(button0)

        fullDesc.translatesAutoresizingMaskIntoConstraints = false
        fullDesc.numberOfLines = 0
        scrollView!.addSubview(fullDesc)

        programs.translatesAutoresizingMaskIntoConstraints = false
        programs.numberOfLines = 0
        scrollView!.addSubview(programs)

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
        button.setTitle("Оставить заявку", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .simpleBlue
        button.addTarget(self, action: #selector(showOrderForm), for: .touchUpInside)
        scrollView!.addSubview(button)

        let orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.textAlignment = .center
        orLabel.text = "или"
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
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: fullDesc)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: programs)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: whatIncluded)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: whatNotIncluded)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: whatTakeWithMe)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: orLabel)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: phoneLabel)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: msgBlock)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: button)
        scrollView!.addConstraintsWithFormat(format: "H:|-10-[v0(\(width))]", views: button0)
        scrollView!.addConstraintsWithFormat(
                format: "V:|[v0(\(80 + cellHeight))]-20-[v1]-10-[v2]-10-[v3]-10-[v4]-10-[v5]-10-[v6]-10-[v7]-10-[v8(40)]-10-[v9]-10-[v10][v11(50)]",
                views: header, shortDesc, button0, fullDesc, programs, whatIncluded, whatNotIncluded, whatTakeWithMe, button, orLabel, phoneLabel, msgBlock)


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
