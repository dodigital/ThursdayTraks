//
//  CastCollectionViewCell.swift
//  TrakTv
//
//  Created by Daniel Okoronkwo on 14/07/2017.
//  Copyright © 2017 Daniel Okoronkwo. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.castImageView.layer.cornerRadius = 45
        self.castImageView.layer.borderColor = UIColor(red:0.28, green:0.70, blue:1.00, alpha:1.00).cgColor
        self.castImageView.layer.borderWidth = 4
    }

}
