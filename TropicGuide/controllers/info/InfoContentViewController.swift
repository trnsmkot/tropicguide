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

class InfoContentViewController: BaseTableViewController<BaseDescTableViewCell> {

    private let descTableViewCellIdentifier = "descTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    let dataSource = Variable<[CommonDescription]>([])

    var infoItem: InfoItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = infoItem?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        if let id = infoItem?.id {
            InfoViewModal.shared.getInfoByInfo(id: id)?
                    .subscribe(onNext: { response in
                        if response.successful {
                            self.dataSource.value = response.data??.descriptions ?? []
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

        let title = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: 60))
        title.text = infoItem?.name ?? ""
        title.textColor = .black
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 24)

        let line = UIView(frame: CGRect(x: 10, y: 50, width: view.frame.width - 20, height: 1))
        line.backgroundColor = .lightGray

        let header = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: 60))

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
                        cell.descImageView.kf.indicatorType = .activity
                        cell.descImageView.kf.setImage(with: URL(string: imageUrl)) { result in
                            switch result {
                            case .success(let value):


                                DispatchQueue.main.async {
                                    let image = value.image
                                    let aspectRatio = image.size.height / image.size.width

                                    cell.descImageView.image = image

                                    let imageHeight = (self.view.frame.width - 20) * aspectRatio
                                    self.tableView.beginUpdates()
                                    cell.heightImageConstraint?.constant = imageHeight
                                    self.tableView.endUpdates()
                                }

                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                            }
                        }
                    }

                }.disposed(by: self.disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return descTableViewCellIdentifier
    }

    override func getRowHeight() -> CGFloat? {
        return nil
    }
}
