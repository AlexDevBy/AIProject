//
//  PlusCollectionViewCell.swift
//  PasswordImages
//
//  Created by Alex Misko on 13.02.22.
//

import UIKit

class PlusCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(with image: Image) {
        imageView.image = image.image
    }
    
}
