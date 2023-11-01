//
//  DataManager.swift
//  Tracker
//
//  Created by Artem Adiev on 10.07.2023.
//

import UIKit

struct Tracker: Equatable {
    let id: UUID
    let date: Date
    let emoji: String
    let title: String
    let color: UIColor
    let isPinned: Bool
    let dayCount: Int
    let schedule: [WeekDay]?
}
