//
//  FilterTableViewCell.swift
//  TropicGuide
//
//  Created by Vladislav Kasatkin on 28/12/2018.
//  Copyright © 2018 Vladislav Kasatkin. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    private var title = UILabel()
    private var filterSwitch = UISwitch()

    private var data: FilterDataItem?
    private var filter: PointFilter?
    private var section = -1

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: FilterDataItem, filter: PointFilter, section: Int) {
        self.data = data
        self.filter = filter
        self.section = section

        title.text = data.name ?? ""

        switch section {
        case 0: filterSwitch.isOn = filter.categories.contains(data.id ?? -1)
        case 1: filterSwitch.isOn = filter.districts.contains(data.id ?? -1)
        default: break
        }

    }

    private func setupViews() {
        contentView.backgroundColor = .white

        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = .black
        contentView.addSubview(title)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: title)

        filterSwitch.translatesAutoresizingMaskIntoConstraints = false
        filterSwitch.onTintColor = .simpleBlue
        contentView.addSubview(filterSwitch)
        contentView.addConstraintsWithFormat(format: "V:|-5-[v0]|", views: filterSwitch)

        contentView.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-10-|", views: title, filterSwitch)

        filterSwitch.addTarget(self, action: #selector(turnSwitch), for: .valueChanged)
    }

    @objc func turnSwitch(sender: UISwitch) {
        if (sender.isOn) {
            switch section {
            case 0:
                if let id = data?.id, let filter = filter {
                    filter.categories.append(id)
                }
            case 1:
                if let id = data?.id, let filter = filter {
                    filter.districts.append(id)
                }
            default: break
            }
        } else {
            switch section {
            case 0:
                if let id = data?.id, let filter = filter, let index = filter.categories.firstIndex(of: id) {
                    filter.categories.remove(at: index)
                }
            case 1:
                if let id = data?.id, let filter = filter, let index = filter.districts.firstIndex(of: id) {
                    filter.districts.remove(at: index)
                }
            default: break
            }
        }
    }
}
