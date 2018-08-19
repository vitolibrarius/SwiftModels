//
//  SwiftModels
//
//  Created by vito on 2018-08-08.
//

import Foundation

public protocol Mappable: Codable {
	init?(jsonString: String)
}

extension Mappable {
    public init?(jsonString: String) {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        self = try! JSONDecoder().decode(Self.self, from: data)
    }
    public init?(jsonData: Data) {
        self = try! JSONDecoder().decode(Self.self, from: jsonData)
    }
}

extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}

//let data = try user.encoded()
//
//// By using a generic type in the decoded() method, the
//// compiler can often infer the type we want to decode
//// from the current context.
//try userDidLogin(data.decoded())
//
//// And if not, we can always supply the type, still making
//// the call site read very nicely.
//let otherUser = try data.decoded() as User
