//
//  ToursViewController.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 21/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ToursViewController: BaseTableViewController<TourCategoryTableViewCell> {

    private let tableViewCellIdentifier = "tourCategoryTableViewCellIdentifier"

    private let spinner = Spinner()
    private let disposeBag = DisposeBag()

    private let showToursKey = "showToursInfo"
    
    let dataSource = BehaviorRelay<[TourCategory]>(value: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Tours"

        setupViews()
        initSpinner(spinner: spinner)

        spinner.start()
        TourViewModal.shared.categories
                .subscribe(onNext: { response in
                    if response.successful, let data = response.data  {
                        self.dataSource.accept(data)
                    } else {
//                        _ = self.navigationController?.popViewController(animated: true)
                        // Вывести ошибку получения данных ?
                    }

                    self.spinner.end()

                }, onError: { error in
                    CustomLogger.instance.reportError(error: error)
//                    _ = self.navigationController?.popViewController(animated: true)

                    self.spinner.end()
                    // Вывести ошибку получения данных ?
                }).disposed(by: disposeBag)
        
        
        let preferences = UserDefaults.standard
        if !preferences.bool(forKey: showToursKey) {
            
            let message = "Tours provided by TROPIC TOURS\r\nYou can find all information about the company on the official website of the company: phuket-tropic-tours.com, in the Contacts section"
            let alert = UIAlertController(title: "Tours Information", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            preferences.set(true, forKey: showToursKey)
            preferences.synchronize()
        }
    }

    override func initBackButton() {
    }

    private func setupViews() {
        self.dataSource.asObservable()
                .bind(to: tableView.rx.items(cellIdentifier: tableViewCellIdentifier)) { row, item, cell in
                    guard let tourCell = cell as? TourCategoryTableViewCell else {
                        return
                    }
                    tourCell.selectionStyle = .none
                    tourCell.setData(category: item)
                }.disposed(by: self.disposeBag)

        tableView.rx.modelSelected(TourCategory.self)
                .subscribe { item in
                    if let category = item.element {
                        self.navigator?.openToursViewControllerByCategory(category)
                    }
                }.disposed(by: disposeBag)
    }

    override func getTableViewCellIdentifier() -> String {
        return tableViewCellIdentifier
    }

    override func needTopAdController() -> Int? {
        return nil
    }
}
