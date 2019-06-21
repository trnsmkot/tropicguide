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
import GoogleMaps

class PointContentViewController: BaseTableViewController<BaseDescTableViewCell>, UICollectionViewDelegateFlowLayout {

    private let descTableViewCellIdentifier = "descTableViewCellIdentifier"
    private let collectionViewCellIdentifier = "imageTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = BehaviorRelay<[CommonDescription]>(value: [])
    private let imageDataSource = BehaviorRelay<[PointImage]>(value: [])

    var pointItem: PointItemShort?

    private var images: [String: UIImage?] = [:]
    private var imageHeights: [String: CGFloat?] = [:]

    private let footer = UIView()

    let pageControl = UIPageControl()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = pointItem?.desc?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        if let id = pointItem?.id {
            PointViewModal.shared.getPointByPoint(id: id)?
                    .subscribe(onNext: { response in
                        if response.successful, let data = response.data, let point = data {
                            self.dataSource.accept(point.desc?.descriptions ?? [])
                            self.imageDataSource.accept(point.images ?? [])
                            self.pageControl.numberOfPages = self.imageDataSource.value.count

                            self.setupMapView(parent: self.footer, point: point)

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

    private func setupViews() {
        tableView.backgroundColor = .white

        let titleFont = UIFont.systemFont(ofSize: 24)
        let titleText = pointItem?.desc?.name ?? ""
        let titleHeight = heightForView(text: titleText, font: titleFont, width: view.frame.width - 40)

        let cellHeight = view.frame.width / 16 * 9
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + titleHeight + cellHeight))

        let title = UILabel(frame: CGRect(x: 10, y: cellHeight + 20, width: view.frame.width - 20, height: titleHeight + 30))
        title.text = titleText
        title.textColor = .black
        title.numberOfLines = 2
        title.font = titleFont

//        let line = UIView(frame: CGRect(x: 10, y: cellHeight + 80, width: view.frame.width - 20, height: 1))
//        line.backgroundColor = .lightGray

        setupImageViews(parent: header)
        header.addSubview(title)

//        header.addSubview(line)

        footer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        tableView.estimatedRowHeight = 100

        self.dataSource
                .asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: descTableViewCellIdentifier, cellType: BaseDescTableViewCell.self)) { row, item, cell in
                    cell.selectionStyle = .none
                    cell.setData(item: item)
                    cell.navigator = self.navigator
                }.disposed(by: self.disposeBag)
    }

    private func setupImageViews(parent: UIView) {
        let cellHeight = view.frame.width / 16 * 9

        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: cellHeight)
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

        pageControl.frame = CGRect(x: 0, y: cellHeight, width: view.frame.width, height: 20)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .simpleBlue
        parent.addSubview(pageControl)

        self.imageDataSource.asObservable()
                .bind(to: collectionView.rx.items(cellIdentifier: collectionViewCellIdentifier)) { row, item, cell in
                    guard let addCell = cell as? ImageCollectionViewCell else {
                        return
                    }
                    addCell.setData(item: item)
                }.disposed(by: self.disposeBag)
    }

    @objc func openImageZoomViewController() {
        let imageUrl = self.imageDataSource.value[self.pageControl.currentPage].originalPath
        navigator?.openZoomImageViewControllerByCategory(imageUrl)
    }

    private func setupMapView(parent: UIView, point: PointItem) {
//        let camera = GMSCameraPosition.camera(withLatitude: point.lat, longitude: point.lng, zoom: point.zoom)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 4 * 3 - 60)
//
//        mapView.settings.scrollGestures = false
//        mapView.settings.zoomGestures = true
//        mapView.isMyLocationEnabled = true
//
//        parent.addSubview(mapView)
//
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: point.lat, longitude: point.lng)
//        marker.title = point.desc?.name
//        marker.map = mapView
//
//        if let icon = point.markerIcon {
//            let markerImageView = UIImageView()
//
//            markerImageView.kf.setImage(with: URL(string: icon)) { result in
//                switch result {
//                case .success(let value):
//                    marker.icon = self.resizeImage(image: value.image, targetSize: CGSize(width: 32, height: 32))
//                case .failure(let error):
//                    print("Job failed: \(error.localizedDescription)")
//                }
//            }
//        }

        let button = UIButton(frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 40))
        button.setTitle("Показать на карте", for: .normal)
        button.setImage(UIImage(named: "menu_map")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .simpleBlue
        button.addTarget(self, action: #selector(openSelectMapApp), for: .touchUpInside)
        parent.addSubview(button)

    }

    @objc func openSelectMapApp() {
        let alert = UIAlertController(title: "Веберите приложение", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Открыть Карты Apple", style: .default, handler: { alert in
            let url = "http://maps.apple.com/?q=\(self.pointItem?.lat ?? 0),\(self.pointItem?.lng ?? 0)&z=10&t=s"
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }))

        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            alert.addAction(UIAlertAction(title: "Открыть Карты Google", style: .default, handler: { alert in
                let url = "comgooglemaps://?q=\(self.pointItem?.lat ?? 0),\(self.pointItem?.lng ?? 0)&zoom=10"
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }))
        }
        if (UIApplication.shared.canOpenURL(URL(string: "mapsme://")!)) {
            alert.addAction(UIAlertAction(title: "Открыть Карты Maps.me", style: .default, handler: { alert in
                let url = "mapsme://search?query=\(self.pointItem?.lat ?? 0),\(self.pointItem?.lng ?? 0)"
                UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            }))
        }
        present(alert, animated: true, completion: nil)
    }

    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    override func getTableViewCellIdentifier() -> String {
        return descTableViewCellIdentifier
    }

    override func getRowHeight() -> CGFloat? {
        return nil
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
}
