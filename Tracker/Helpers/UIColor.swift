//
//  Colors.swift
//  Tracker
//
//  Created by Artem Adiev on 02.07.2023.
//

import UIKit

extension UIColor {
    
    static var ypBackground: UIColor {
        if let color = UIColor(named: "YP Background") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.255, green: 0.255, blue: 0.255, alpha: 0.85)
                } else {
                    return UIColor(red: 0.902, green: 0.910, blue: 0.922, alpha: 0.30)
                }
            }
        }
    }
    
    static var ypBlack: UIColor {
        if let color = UIColor(named: "YP Black") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    return UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
                }
            }
        }
    }
    
    static var ypWhite: UIColor {
        if let color = UIColor(named: "YP White") {
            return color
        } else {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
                } else {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    static var ypBlue: UIColor { UIColor(named: "YP Blue") ?? UIColor.blue }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypLightGray: UIColor { UIColor(named: "YP Light Gray") ?? UIColor.lightGray }
    
    static var colorSelection1: UIColor { UIColor(named: "Color celection 1")! }
    static var colorSelection2: UIColor { UIColor(named: "Color celection 2")! }
    static var colorSelection3: UIColor { UIColor(named: "Color celection 3")! }
    static var colorSelection4: UIColor { UIColor(named: "Color celection 4")! }
    static var colorSelection5: UIColor { UIColor(named: "Color celection 5")! }
    static var colorSelection6: UIColor { UIColor(named: "Color celection 6")! }
    static var colorSelection7: UIColor { UIColor(named: "Color celection 7")! }
    static var colorSelection8: UIColor { UIColor(named: "Color celection 8")! }
    static var colorSelection9: UIColor { UIColor(named: "Color celection 9")! }
    static var colorSelection10: UIColor { UIColor(named: "Color celection 10")! }
    static var colorSelection11: UIColor { UIColor(named: "Color celection 11")! }
    static var colorSelection12: UIColor { UIColor(named: "Color celection 12")! }
    static var colorSelection13: UIColor { UIColor(named: "Color celection 13")! }
    static var colorSelection14: UIColor { UIColor(named: "Color celection 14")! }
    static var colorSelection15: UIColor { UIColor(named: "Color celection 15")! }
    static var colorSelection16: UIColor { UIColor(named: "Color celection 16")! }
    static var colorSelection17: UIColor { UIColor(named: "Color celection 17")! }
    static var colorSelection18: UIColor { UIColor(named: "Color celection 18")! }

}
