






import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var ImageView: UIImageView!
    
    
    func configure(with imageInfo: ImageInfo) {
        let image = Manager.shared.loadImage(fileName: imageInfo.name)
        ImageView.image = image
    }
    
}

