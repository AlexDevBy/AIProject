






import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.systemIndigo.cgColor
        view.layer.shadowOpacity = 0.9
        view.layer.shadowRadius = 21
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
    
    
    func configure(with imageInfo: ImageInfo) {
        let image = Manager.shared.loadImage(fileName: imageInfo.name)
        imageView.image = image
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

