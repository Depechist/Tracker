//
//  Int.swift
//  Tracker
//
//  Created by Artem Adiev on 29.10.2023.
//

import Foundation

extension Int {
    
    // Метод для определения написания количества дней (день / дня / дней)
    func pluralizeDays() -> String {
        let remainder10 = self % 10
        let remainder100 = self % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(self) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 100 || remainder100 >= 20) {
            return "\(self) дня"
        } else {
            return "\(self) дней"
        }
    }
    
}
