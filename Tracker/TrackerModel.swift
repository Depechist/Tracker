//
//  DataManager.swift
//  Tracker
//
//  Created by Artem Adiev on 10.07.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let date: Date
    let emoji: String
    let text: String
    let color: UIColor
    let dayCount: Int
    
    init(id: UUID, date: Date, emoji: String, text: String, color: UIColor, dayCount: Int) {
        self.id = id
        self.date = date
        self.emoji = emoji
        self.text = text
        self.color = color
        self.dayCount = dayCount
    }
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
    
    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}
