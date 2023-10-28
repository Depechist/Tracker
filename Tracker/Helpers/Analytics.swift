//
//  Analytics.swift
//  Tracker
//
//  Created by Artem Adiev on 28.10.2023.
//

import Foundation
import YandexMobileMetrica

final class Analytics {
    static let shared = Analytics()
    
    private func report(_ event: String, screen: String, item: String? = nil) {
        var params: [AnyHashable : Any] = ["event": event, "screen": screen]
        if let item = item {
            params["item"] = item
        }
        
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func openScreen(name: String) {
        report("open", screen: name)
    }
    
    func closeScreen(name: String) {
        report("close", screen: name)
    }
    
    func tapButton(on screen: String, itemType: ButtonType) {
        report("click", screen: screen, item: itemType.rawValue)
    }
    
    enum ButtonType: String {
        case addTrack = "add_track"
        case track = "track"
        case filter = "filter"
        case edit = "edit"
        case delete = "delete"
    }
}
