//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Виктор on 10.07.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func hide() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
