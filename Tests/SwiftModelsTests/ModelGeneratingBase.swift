//
//  ModelTest.swift
//  SwiftGeneratorTests
//
//  Created by david on 2018-08-08.
//

import XCTest
@testable import SwiftModels

class ModelGeneratingBase: XCTestCase {

    /***
     * Json generation methods
     */
    func jsonStringFrom( mapping: Any ) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: mapping, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)!
        }
        catch {
            print(error.localizedDescription)
            XCTFail("Failed to create data from \(mapping)")
        }
        return ""
    }

    func writeJson( jsonString: String, output: String) {
        let data = jsonString.data(using: .utf8)
        	FileManager.default.createFile(atPath: "/tmp/" + output + ".json", contents: data, attributes: nil)
    }

    /***
     * Model as dictionaries
     */

    func joinAttributeDict(sourceName: String, destName: String ) -> [String: String] {
        XCTAssertNotNil(sourceName)
        XCTAssertNotNil(destName)
        return [
            "sourceAttribute": sourceName,
            "destinationAttribute": destName
        ]
    }

    func indexDict( columns: [String], unique: Bool ) -> [String:Any] {
        var mapping : [String:Any] = [:]
        mapping["unique"] = unique
        mapping["columns"] = columns
        return mapping
    }

    func indexesArrayDict(columns: [[String]], unique: [Bool] ) -> [[String: Any]] {
        XCTAssertEqual( columns.count, unique.count )
        var retArray : [[String: Any]] = []
        let length = columns.count - 1
        for idx in 0...length {
            let cList = columns[idx]
            let uniq = unique[idx]
            retArray.append(indexDict(columns: cList, unique: uniq))
        }
        return retArray
    }

    func sortOrderDict(attributeName: String, asc: Bool ) -> [String: String] {
        XCTAssertNotNil(attributeName)
        return [
            "direction": (asc ? OrderType.ASC.rawValue : OrderType.DESC.rawValue),
            "attribute": attributeName
        ]
    }

    func sortOrderArrayDict(attributeNames: [String], asc: Bool ) -> [[String:String]] {
        var mapping : [[String:String]] = []
        for s in attributeNames {
            mapping.append(sortOrderDict(attributeName: s, asc: asc))
        }
        return mapping
    }

    func qualifierDict( type: QualifierType, wildcard: WildcardType?, subQualifier: [String:Any]?, function: String?,
                    attribute: String?, relationship: String?, arg: String?, optional: Bool?) -> [String:Any] {
        var mapping : [String:Any] = [:]
        mapping["type"] = type.rawValue
        if ( optional != nil )      { mapping["optional"] = optional! }
        if ( attribute != nil )     { mapping["attributeName"] = attribute! }
        if ( relationship != nil )  { mapping["relationshipName"] = relationship! }
        if ( arg != nil )           { mapping["argumentName"] = arg! }
        if ( function != nil )      { mapping["function"] = function! }
        if ( wildcard != nil )      { mapping["wildcard"] = wildcard!.rawValue }
        if ( subQualifier != nil )  { mapping["subQualifier"] = subQualifier! }
        return mapping;
    }

    func subQualifierDict( type: QualifierType, function: String?, attribute: String? ) -> [String:Any] {
        return qualifierDict(type: type, wildcard: nil, subQualifier: nil, function: function, attribute: attribute, relationship: nil, arg: nil, optional: nil)
    }

    func fetchArrayDict( fetches : [String:Any]... ) -> [String:Any] {
        var mapping: [String:Any] = [:]
        for fetch: [String:Any] in fetches {
            for (k,v) in fetch {
                mapping[k] = v
            }
        }
        return mapping
    }

    func fetchDict(name: String, arguments: [String], maxCount: Int?, qualifiers: [[String:Any]]) -> [String:Any] {
        var mapping : [String:Any] = [:]
        mapping["arguments"] = arguments
        mapping["qualifiers"] = qualifiers
        if ( maxCount != nil )      { mapping["maxCount"] = maxCount! }
        return [name: mapping]
    }

    func relationshipArrayDict( relations : [String:Any]... ) -> [String:Any] {
        var mapping: [String:Any] = [:]
        for relation: [String:Any] in relations {
            for (k,v) in relation {
                mapping[k] = v
            }
        }
        return mapping
    }

    func relationshipDict( name: String, dest: String, joins: [[String: String]], mandatory: Bool, toMany: Bool, owns: Bool ) -> [String: Any] {
        var mapping : [String:Any] = [:]
        mapping["destination"] = dest
        mapping["destinationTable"] = dest
        mapping["joins"] = joins
        mapping["isMandatory"] = mandatory
        mapping["isToMany"] = toMany
        mapping["ownsDestination"] = owns
        return [name: mapping]
    }

    func attributesArrayDict( attributes : [String:Any]... ) -> [String:Any] {
        var mapping: [String:Any] = [:]
        for attr: [String:Any] in attributes {
            for (k,v) in attr {
                mapping[k] = v
            }
        }
        return mapping
    }

    func attributeDict( name: String, type: ColumnType, column: String, length: Int?, collate: String?, nullable: Bool?, defaultVal: Any? ) -> [String: Any] {
        var mapping : [String:Any] = [:]
        mapping["type"] = type.rawValue
        mapping["column"] = column
        if ( length != nil )      { mapping["length"] = length! }
        if ( collate != nil )     { mapping["collate"] = collate! }
        if ( nullable != nil )    { mapping["nullable"] = nullable! }
        if ( defaultVal != nil )  {
            switch defaultVal! {
            case 0 as Int:
                mapping["defaultValue"] = 0
            case 0 as Double:
                mapping["defaultValue"] = 0.0
            case let someInt as Int:
                mapping["defaultValue"] = someInt
            case let someDouble as Double where someDouble > 0:
                mapping["defaultValue"] = someDouble
            case let someDate as Date:
                mapping["defaultValue"] = someDate
            case let str as String:
                mapping["defaultValue"] = str
            default:
                mapping["defaultValue"] = defaultVal as! String
            }
        }
        return [name: mapping]
    }

    func modelDict( name: String, package: String, table: String, primaryKeys: [String], sortOrder: [[String:String]], indexes: [[String:Any]],
                    attributes: [String:Any], relationships: [String:Any], fetches: [String:Any] ) -> [String:Any] {
        var mapping: [String:Any] = [:]
        mapping["name"] = name
        mapping["package"] = package
        mapping["table"] = table
        mapping["primaryKeys"] = primaryKeys
        mapping["sortOrder"] = sortOrder
        mapping["indexes"] = indexes
        mapping["attributes"] = attributes
        mapping["relationships"] = relationships
        mapping["fetches"] = fetches
        return mapping
    }
}
