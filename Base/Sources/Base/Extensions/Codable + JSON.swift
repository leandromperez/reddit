import Foundation

public extension Encodable {
    func toJSON(keyEncodingStrategy:JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) throws ->  Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        return try encoder.encode(self)
    }

    func toStringsDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> [String : String]? {
        self.toDictionary()?.mapValues{"\($0)"}
    }

    func toDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase) -> [String : Any]? {
        guard let data = try? self.toJSON(keyEncodingStrategy: keyEncodingStrategy) else {return nil}
        guard let result = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {return nil}
        return result
    }

    func toString() -> String? {
        guard let jsonData = try? self.toJSON() else {return nil}
        return String(bytes: jsonData, encoding: .utf8)
    }
}

public extension Decodable {

    static func fromJsonWithSameTypeName(bundle: Bundle) throws -> Self {
        return try fromJson(named: "\(Self.self)", bundle: bundle)
    }

    static func fromJson(named name: String, bundle: Bundle) throws -> Self {
        let path = bundle.path(forResource: name, ofType: "json")
        let data = try Data(contentsOf: URL(fileURLWithPath: path!))
        return try fromJSON(jsonData: data)
    }

    static func fromJSON(jsonData:Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: jsonData)
    }
}

