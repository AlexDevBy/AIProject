
import Foundation
import UIKit

class ImageInfo: Codable {
    
    var name: String
    var isLiked: Bool
    var text: String
    
    init(name: String, isLiked: Bool, text: String) {
        self.name = name
        self.isLiked = isLiked
        self.text = text
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case isLiked
        case text
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(isLiked, forKey: .isLiked)
        try container.encode(text, forKey: .text)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
}
