//
//  PlusCollectionViewCell.swift
//  PasswordImages
//
//  Created by Alex Misko on 13.02.22.
//

import UIKit
import SnapKit

class PlusCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
       let view = UIImageView()
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.systemIndigo.cgColor
        view.layer.shadowOpacity = 0.9
        view.layer.shadowRadius = 55
        view.layer.shadowOffset = CGSize.zero
        view.layer.cornerRadius = 22.0
        return view
   }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: Image) {
        imageView.image = image.image
    }
    
    func addViews(){
        
        addSubview(imageView)
        
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }

    }
    
}
