//
//  ScheduleDelegate.swift
//  Tracker
//
//  Created by Dmitry Rogov on 14.07.2023.
//

import Foundation

protocol ScheduleDelegate: AnyObject {
    func weekDaysChanged(weedDays: [WeekDay])
}
