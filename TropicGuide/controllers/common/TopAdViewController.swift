//
// Created by Vladislav Kasatkin on 2018-12-25.
// Copyright (c) 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TopAdViewController: UIViewController {

    private let tableViewCellIdentifier = "infoCategoryTableViewCellIdentifier"
    private let dataSource = Variable<[TopAdItem]>([])

    let pageControl = UIPageControl()
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    }()

    private let disposeBag = DisposeBag()
    var navigator: Navigator?
    var topAdsId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        TopAdViewModal.shared.getAdsById(topAdsId)?
                .subscribe(onNext: { response in
                    if response.successful {
                        self.dataSource.value = response.data ?? []
                        self.pageControl.numberOfPages =  self.dataSource.value.count
                    } else {
                        // Вывести ошибку получения данных ?
                    }
                }, onError: { error in
                    CustomLogger.instance.reportError(error: error)
                    // Вывести ошибку получения данных ?
                }).disposed(by: disposeBag)
    }

    private func setupViews() {

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bounces = false
        collectionView.register(TopAdCollectioniewCell.self, forCellWithReuseIdentifier: tableViewCellIdentifier)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        view.addSubview(collectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)


        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .simpleBlue
        view.addSubview(pageControl)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: pageControl)


        view.addConstraintsWithFormat(format: "V:|[v0]-10-[v1(20)]|", views: collectionView, pageControl)

        self.dataSource.asObservable()
                .bind(to: collectionView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let addCell = cell as? TopAdCollectioniewCell else {
                        return
                    }
                    addCell.setData(item: item)
                }.disposed(by: self.disposeBag)

        collectionView.rx.modelSelected(TopAdItem.self)
                .subscribe { item in
                    if let topAd = item.element {
                        self.navigator?.openTopAdContentController(topAd)
                    }
                }.disposed(by: disposeBag)
    }
}

extension TopAdViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 30)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}