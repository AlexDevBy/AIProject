




import Foundation
import UIKit


class Image {
    
    var image: UIImage
    var name: String
    
    init(name: String) {
        image = UIImage(named: "Plus") ?? UIImage()
        self.name = name
    }
    
}
