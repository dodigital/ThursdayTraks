//
//  RoundedCornersView.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 16/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedCornersView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
