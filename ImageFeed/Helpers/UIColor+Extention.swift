//
//  UIColor+Extention.swift
//  ImageFeed
//
//  Created by Виктор on 18.07.2023.
//

import UIKit

extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black }
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray }
    static var ypBackground: UIColor { UIColor(named: "YP Background (iOS)") ?? UIColor.darkGray }
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red }
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white }
    static var ypWhiteAlpha50: UIColor { UIColor(named: "YP White (Alpha 50)") ?? UIColor.white.withAlphaComponent(0.5) }
}
