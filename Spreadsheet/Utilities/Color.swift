//
//  Color.swift
//  Spreadsheet
//
//  Created by Oraz Atakishiyev on 2/10/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import UIKit

struct Color {
    static let green = UIColor(rgb: 0x008001)
    static let gray = UIColor(rgb: 0xBDBDBD)
    static let scheduleGrid = UIColor(rgb: 0xE5F2E6)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
