//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Artem Adiev on 16.07.2023.
//

import UIKit

final class ScheduleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .ypBackground
        self.selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
