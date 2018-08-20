//
//  SwiftModels
//
//  Created by vito on 2018-08-07.
//

import Foundation

public enum ColumnType: String, Codable, CustomStringConvertible  {
    public var description: String {
        return self.rawValue
    }
    case INTEGER
    case TEXT
    case DATE
    case BOOLEAN
}

public struct Attribute : Mappable {
    let column: String
    let type: ColumnType
    let length: Int?
    let collate: String?
    let nullable: Bool
    let defaultValue: Any?
    let inputPattern: String?
    enum CodingKeys : String, CodingKey {
        case column
        case type
        case length
        case collate
        case nullable
        case defaultValue
        case inputPattern
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.column = try container.decode(String.self, forKey: .column)
        self.type = try container.decode(ColumnType.self, forKey: .type)
        if ( container.contains(.length) ) {
            self.length = try container.decode(Int.self, forKey: .length)
        }
        else { self.length = nil }

        if ( container.contains(.collate) ) {
            self.collate = try container.decode(String.self, forKey: .collate)
        }
        else { self.collate = nil }

        if ( container.contains(.nullable) ) {
            self.nullable = try container.decode(Bool.self, forKey: .nullable)
        }
        else { self.nullable = true }

        if ( container.contains(.defaultValue) ) {
            switch self.type {
            case ColumnType.BOOLEAN:
                self.defaultValue = try container.decode(Bool.self, forKey: .defaultValue)
            case ColumnType.DATE:
                self.defaultValue = try container.decode(Date.self, forKey: .defaultValue)
            case ColumnType.INTEGER:
                self.defaultValue = try container.decode(Int.self, forKey: .defaultValue)
            default:
                self.defaultValue = try container.decode(String.self, forKey: .defaultValue)
            }
        }
        else { self.defaultValue = nil }

        if ( container.contains(.inputPattern) ) {
            self.inputPattern = try container.decode(String.self, forKey: .inputPattern)
        }
        else { self.inputPattern = nil }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(column, forKey: .column)
        try container.encode(type, forKey: .type)
        try container.encode(length, forKey: .length)
        try container.encode(collate, forKey: .collate)
        try container.encode(nullable, forKey: .nullable)
        try container.encode(inputPattern, forKey: .inputPattern)
        if ( self.defaultValue != nil ) {
            switch self.defaultValue! {
            case 0 as Int:
                try container.encode( 0, forKey: .defaultValue)
            case 0 as Double:
                try container.encode( 0.0, forKey: .defaultValue)
            case let someInt as Int:
                try container.encode( someInt, forKey: .defaultValue)
            case let someDouble as Double where someDouble > 0:
                try container.encode( someDouble, forKey: .defaultValue)
            case let someDate as Date:
                try container.encode( someDate, forKey: .defaultValue)
            case let str as String:
                try container.encode( str, forKey: .defaultValue)
            default:
                try container.encode( self.defaultValue as! String, forKey: .defaultValue)
            }
        }
    }
}
