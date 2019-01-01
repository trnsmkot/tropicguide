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

class PointContentViewController: BaseTableViewController<BaseDescTableViewCell>, UICollectionViewDelegateFlowLayout {

    private let descTableViewCellIdentifier = "descTableViewCellIdentifier"
    private let collectionViewCellIdentifier = "imageTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[CommonDescription]>([])
    private let imageDataSource = Variable<[PointImage]>([])

    var pointItem: PointItemShort?

    private var images: [String: UIImage?] = [:]
    private var imageHeights: [String: CGFloat?] = [:]

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
                        if response.successful {
                            self.dataSource.value = response.data??.desc?.descriptions ?? []
                            self.imageDataSource.value = response.data??.images ?? []
                            self.pageControl.numberOfPages = self.imageDataSource.value.count

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

        let cellHeight = view.frame.width / 16 * 9
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80 + cellHeight))

        let title = UILabel(frame: CGRect(x: 10, y: cellHeight + 20, width: view.frame.width - 20, height: 60))
        title.text = pointItem?.desc?.name ?? ""
        title.textColor = .black
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 24)

        let line = UIView(frame: CGRect(x: 10, y: cellHeight + 80, width: view.frame.width - 20, height: 1))
        line.backgroundColor = .lightGray

        setupImageViews(parent: header)
        header.addSubview(title)
        header.addSubview(line)


        tableView.tableHeaderView = header
        tableView.estimatedRowHeight = 100

        self.dataSource
                .asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: descTableViewCellIdentifier, cellType: BaseDescTableViewCell.self)) { row, item, cell in
                    cell.selectionStyle = .none
                    cell.setData(item: item)


                    if let imageUrl = item.imagePath {

                        if let image = self.images[imageUrl], let height = self.imageHeights[imageUrl] {
                            cell.heightImageConstraint?.constant = height ?? 0
                            cell.descImageView.image = image
                        } else {
                            cell.descImageView.kf.indicatorType = .activity
                            cell.descImageView.kf.setImage(with: URL(string: imageUrl)) { result in
                                switch result {
                                case .success(let value):

                                    self.images[imageUrl] = value.image

                                    DispatchQueue.main.async {
                                        let image = value.image
                                        let aspectRatio = image.size.height / image.size.width

                                        cell.descImageView.image = image

                                        let imageHeight = (self.view.frame.width - 20) * aspectRatio
                                        self.tableView.beginUpdates()
                                        cell.heightImageConstraint?.constant = imageHeight
                                        self.imageHeights[imageUrl] = imageHeight
                                        self.tableView.endUpdates()
                                        self.tableView.layer.removeAllAnimations()
                                    }

                                case .failure(let error):
                                    print("Job failed: \(error.localizedDescription)")
                                }
                            }
                        }
                    }

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