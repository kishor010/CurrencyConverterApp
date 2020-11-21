//
//  Helper.swift
//  RevoultTest
//
//  Created by Kishor Pahalwani on 05/10/19.
//  Copyright © 2019 Kishor Pahalwani. All rights reserved.
//

import UIKit

typealias dict = [String: AnyObject]
typealias onSuccess = (dict?)->()
typealias onFailure = (String)->()

class Helper {
    
    static let PROGRESS_INDICATOR_VIEW_TAG:Int = 10
    
    static func showAlert(AlertTitle : String, AlertMessage : String, controller: UIViewController) {
        let alert = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.alertOK, style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
