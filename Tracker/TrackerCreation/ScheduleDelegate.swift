//
//  ScheduleDelegate.swift
//  Tracker
//
//  Created by Artem Adiev on 14.07.2023.
//

import Foundation

protocol ScheduleDelegate: AnyObject {
    func weekDaysChanged(weedDays: [WeekDay])
}
