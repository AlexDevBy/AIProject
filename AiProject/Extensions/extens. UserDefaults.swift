

import Foundation


extension UserDefaults {
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(encodable) else { return } // превращаем входящий объект Codable в 010101101101
        set(data, forKey: key)
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = object(forKey: key) as? Data,
              let value = try? JSONDecoder().decode(type, from: data) else { return nil }
        return value
    }
    
}
