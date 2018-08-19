//
//  SwiftModels
//
//  Created by vito on 2018-08-07.
//

import Foundation

public struct Model : Mappable {
    let name: String
    let package: String
    let table: String
    let primaryKeys: [String]
    let sortOrder: [SortOrder]
    let indexes: [Indexes]
    let attributes: [String: Attribute]
    let relationships: [String: Relationship]?
    let fetches: [String: Fetch]?

    public subscript(key: String) -> Any? {
        /// Retrieves a variable's value, starting at the current context and going upwards
        get {
            switch key {
            case "attributeNames":
                return Array(self.attributes.keys).sorted()
            case "relationshipNames":
                return self.relationshipNames()
            default:
                return nil
            }
        }

        /// Set a variable in the current context, deleting the variable if it's nil
        set(value) {
        }
    }

//    func attributeNames() -> [String] {
//        return Array(self.attributes.keys).sorted()
//    }

    func attributeNamed(name: String) -> Attribute? {
        return self.attributes[name]
    }

    func relationshipNames() -> [String] {
        if ( self.relationships == nil ) {
            return []
        }
        return Array(self.relationships!.keys).sorted()
    }

    func relationshipNamed(name: String) -> Relationship? {
        return (self.relationships == nil ? nil : self.relationships?[name])
    }

    func fetchesNames() -> [String] {
        if ( self.fetches == nil ) {
            return []
        }
        return Array(self.fetches!.keys).sorted()
    }

    func fetchNamed(name: String) -> Fetch? {
        return (self.fetches == nil ? nil : self.fetches?[name])
    }

    func dependencies() -> Set<String> {
        if ( self.relationships == nil ) {
            return Set<String>()
        }
        var dependencies : Set<String> = Set<String>()
        for (_, relation) in self.relationships! {
            let modelName = relation.destination
            if ( dependencies.contains(modelName) == false) {
                dependencies.insert(modelName)
            }
        }
        dependencies.remove(self.name)
        return dependencies
    }

    func validate() -> [String] {
        var problems : [String] = []

        for pk in primaryKeys {
            let attr = self.attributeNamed(name: pk)
            if ( attr == nil ) {
                problems.append("PrimaryKeys: Missing attribute for \(pk)")
            }
        }

        for ordr in sortOrder {
            let attr = self.attributeNamed(name: ordr.attribute)
            if ( attr == nil ) {
                problems.append("SortOrder: Missing attribute for \(ordr.attribute)")
            }
        }

        for idx in indexes {
            for col in idx.columns {
                let attr = self.attributeNamed(name: col)
                if ( attr == nil ) {
                    problems.append("Index: Missing attribute \(col) in \(idx)")
                }
            }
        }

        if ( relationships != nil ) {
            for (_, rel) in (relationships)! {
                for jn in rel.joins {
                    let attr = self.attributeNamed(name: jn.sourceAttribute)
                    if ( attr == nil ) {
                        problems.append("Relationship: Unknown join on attribute \(jn.sourceAttribute) in \(jn)")
                    }
                }
            }
        }

        if ( fetches != nil ) {
            for (_, fetch) in (fetches)! {
                for qual in fetch.qualifiers {
                    if ( qual.argumentName != nil && fetch.arguments.contains(qual.argumentName!) == false ) {
                        problems.append("Fetch: Unknown qualifier argument \(qual.argumentName!) in \(fetch)")
                    }
                    if ( qual.attributeName != nil && self.attributeNamed(name: qual.attributeName!) == nil ) {
                        problems.append("Fetch: Unknown qualifier attribute \(qual.attributeName!) in \(fetch)")
                    }
                    if ( qual.relationshipName != nil && self.relationshipNamed(name: qual.relationshipName!) == nil ) {
                        problems.append("Fetch: Unknown qualifier relationship \(qual.relationshipName!) in \(fetch)")
                    }
                }
            }
        }
        return problems
    }
}
