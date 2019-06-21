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

    private var images: [String: UIImage?] = [:]
//    private var imageHeights: [String: CGFloat?] = [:]

    let dataSource = BehaviorRelay<[CommonDescription]>(value: [])

    var infoItem: InfoItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = infoItem?.desc?.name ?? ""

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        if let id = infoItem?.id {
            InfoViewModal.shared.getInfoByInfo(id: id)?
                    .subscribe(onNext: { response in
                        if response.successful, let data = response.data, let descs = data?.desc?.descriptions {
                            self.dataSource.accept(descs)
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
        let titleText = infoItem?.desc?.name ?? ""
        let titleHeight = heightForView(text: titleText, font: titleFont, width: view.frame.width - 40)

        print(titleHeight)

        let title = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: titleHeight + 20))
        title.text = titleText
        title.textColor = .black
        title.numberOfLines = 2
        title.font = titleFont

//        let line = UIView(frame: CGRect(x: 10, y: 60, width: view.frame.width - 20, height: 1))
//        line.backgroundColor = .lightGray

        let header = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: titleHeight + 20))

        header.addSubview(title)
//        header.addSubview(line)

        tableView.tableHeaderView = header
        tableView.estimatedRowHeight = 100

        self.dataSource
                .asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: descTableViewCellIdentifier, cellType: BaseDescTableViewCell.self)) { row, item, cell in
                    cell.selectionStyle = .none
                    cell.setData(item: item)
                    cell.navigator = self.navigator
                }.disposed(by: self.disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return descTableViewCellIdentifier
    }

    override func getRowHeight() -> CGFloat? {
        return nil
    }
}
