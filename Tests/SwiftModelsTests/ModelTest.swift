//
//  ModelTest.swift
//  SwiftGeneratorTests
//
//  Created by david on 2018-08-08.
//

import XCTest
@testable import SwiftModels

class ModelTest: ModelGeneratingBase {

    static var allTests = [
        ("testSortOrder", testSortOrder),
        ("testSortOrderArray", testSortOrderArray),
        ("testIndexes", testIndexes),
        ("testIndexesArray", testIndexesArray),
        ("testJoins", testJoins),
        ("testQualifierEquals", testQualifierEquals),
        ("testQualifierRelated", testQualifierRelated),
        ("testQualifierLike", testQualifierLike),
        ("testQualifierAggregate", testQualifierAggregate),
        ("testQualifierSubQuery", testQualifierSubQuery),
        ("testFetch", testFetch),
        ("testRelationship", testRelationship),
        ("testAttribbute", testAttribbute),
        ("testModel", testModel),
        ("testPerformanceExample", testPerformanceExample),
        ]

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSortOrder() {
        let jsonDict = sortOrderDict(attributeName: "name", asc: false)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        let order = SortOrder(jsonString: jsonString)
        XCTAssertEqual(order?.direction, OrderType.DESC)
        XCTAssertEqual(order?.attribute, "name")
    }

    func testSortOrderArray() {
        let jsonDict = sortOrderArrayDict(attributeNames: ["name", "created"], asc: false)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "sortorderarray")
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from \(jsonString)")
            return
        }
        let order = try! JSONDecoder().decode([SortOrder].self, from: data)
        XCTAssertEqual(order.count, 2)
        XCTAssertEqual(order[0].attribute, "name")
    }

    func testIndexes() {
        let jsonDict = indexDict(columns: ["name"], unique: false)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "index")
        let idx = Indexes(jsonString: jsonString)
        XCTAssertEqual(idx?.columns.count, 1)
        XCTAssertEqual(idx?.unique, false)
    }

    func testIndexesArray() {
        let jsonDict = indexesArrayDict(columns: [["name"], ["created", "type"]], unique: [true, false])
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "indexesarray")
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from \(jsonString)")
            return
        }
        let order = try! JSONDecoder().decode([Indexes].self, from: data)
        XCTAssertEqual(order.count, 2)
        XCTAssertEqual(order[0].columns[0], "name")
    }

    func testJoins() {
        let jsonDict = joinAttributeDict(sourceName: "id", destName: "songId")
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString , output: "join")
        let join = Join(jsonString: jsonString)
        XCTAssertEqual(join?.sourceAttribute, "id")
        XCTAssertEqual(join?.destinationAttribute, "songId")
    }

    func testQualifierEquals() {
        let jsonDict = self.qualifierDict(type: QualifierType.Equals, wildcard: nil, subQualifier: nil, function: nil, attribute: "remember_me_token", relationship: nil, arg: "token", optional: false)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "qualifier_equals")
        let qualifier = Qualifier(jsonString: jsonString)
        XCTAssertEqual(qualifier?.type, QualifierType.Equals)
        XCTAssertEqual(qualifier?.attributeName, "remember_me_token")
        XCTAssertEqual(qualifier?.argumentName, "token")
    }

    func testQualifierRelated() {
        let jsonDict = self.qualifierDict(type: QualifierType.Related, wildcard: nil, subQualifier: nil, function: nil, attribute: nil, relationship: "user", arg: "user", optional: false)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "qualifier_related")
        let qualifier = Qualifier(jsonString: jsonString)
        XCTAssertEqual(qualifier?.type, QualifierType.Related)
        XCTAssertEqual(qualifier?.relationshipName, "user")
        XCTAssertEqual(qualifier?.argumentName, "user")
    }

    func testQualifierLike() {
        let jsonDict = self.qualifierDict(type: QualifierType.Like, wildcard: WildcardType.BOTH, subQualifier: nil, function: nil, attribute: "indexable_name", relationship: nil, arg: "search", optional: true)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "qualifier_like")
        let qualifier = Qualifier(jsonString: jsonString)
        XCTAssertEqual(qualifier?.type, QualifierType.Like)
        XCTAssertEqual(qualifier?.wildcard, WildcardType.BOTH)
        XCTAssertEqual(qualifier?.attributeName, "indexable_name")
        XCTAssertEqual(qualifier?.argumentName, "search")
    }

    func testQualifierAggregate() {
        let jsonDict = self.qualifierDict(type: QualifierType.Aggregate, wildcard: nil, subQualifier: nil, function: "max", attribute: "code", relationship: nil, arg: nil, optional: true)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "qualifier_max")
        let qualifier = Qualifier(jsonString: jsonString)
        XCTAssertEqual(qualifier?.type, QualifierType.Aggregate)
        XCTAssertEqual(qualifier?.attributeName, "code")
        XCTAssertEqual(qualifier?.function, "max")
    }

    func testQualifierSubQuery() {
        let mapping = qualifierDict(type: QualifierType.Aggregate, wildcard: nil, subQualifier: nil, function: "max", attribute: "code", relationship: nil, arg: nil, optional: nil)
        let jsonDict = self.qualifierDict(type: QualifierType.InSubQuery, wildcard: nil, subQualifier: mapping, function: nil, attribute: "code", relationship: nil, arg: nil, optional: true)
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "qualifier_subq")
        let qualifier = Qualifier(jsonString: jsonString)
        XCTAssertEqual(qualifier?.type, QualifierType.InSubQuery)
        XCTAssertEqual(qualifier?.attributeName, "code")
    }

    func testFetch() {
        let nameq = qualifierDict(type: QualifierType.Like, wildcard: WildcardType.BOTH, subQualifier: nil, function: nil, attribute: "indexable_name", relationship: nil, arg: "name", optional: true)
        let idq = qualifierDict(type: QualifierType.Equals, wildcard: nil, subQualifier: nil, function: nil, attribute: "name_id", relationship: "names", arg: "id", optional: true)

        let names = [ "testFetch", "name" ]
        let jsonDict: [String:Any] = fetchArrayDict(fetches:
            fetchDict(name: names[0], arguments: ["name"], maxCount: nil, qualifiers: [nameq]),
            fetchDict(name: names[1], arguments: ["id"], maxCount: nil, qualifiers: [idq])
        )
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "fetch")
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from \(jsonString)")
            return
        }
        let order = try! JSONDecoder().decode([String: Fetch].self, from: data)
        XCTAssertEqual(order.count, 2)
        for n in names {
            let f = order[n]
            XCTAssertNotNil(f)
            XCTAssertEqual(f?.arguments.count, 1)
        }
    }

    func testRelationship() {
        let join = joinAttributeDict(sourceName: "id", destName: "networkId")
        let jsonDict = relationshipArrayDict(relations:
            relationshipDict(name: "userNetwork", dest: "UserNetwork", joins: [join], mandatory: false, toMany: true, owns: false)
        )
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "relationship")
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from \(jsonString)")
            return
        }
        let rel = try! JSONDecoder().decode([String: Relationship].self, from: data)
        XCTAssertEqual(rel.count, 1)
    }

    func testAttribbute() {
        let names = [ "id", "name" ]
        let jsonDict = attributesArrayDict(attributes:
            attributeDict( name: names[0], type: ColumnType.INTEGER, column: "ID", length: nil, collate: nil, nullable: false, defaultVal: nil),
            attributeDict( name: names[1], type: ColumnType.TEXT, column: "NAME", length: 254, collate: nil, nullable: false, defaultVal: nil)
        )
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "attributes")
        guard let data = jsonString.data(using: .utf8) else {
            XCTFail("Failed to create data from \(jsonString)")
            return
        }
        let att = try! JSONDecoder().decode([String: Attribute].self, from: data)
        XCTAssertEqual(att.count, 2)
        for n in names {
            let a = att[n]
            XCTAssertNotNil(a)
            XCTAssertEqual(a?.column, n.uppercased() )
        }
    }

    func testModel() {
        let attr = attributesArrayDict(attributes:
            attributeDict(name: "userId", type: ColumnType.TEXT, column: "user_id", length: 256, collate: nil, nullable: false, defaultVal: nil),
            attributeDict(name: "name", type: ColumnType.TEXT, column: "name", length: 256, collate: nil, nullable: false, defaultVal: nil)
            )
        let rels = relationshipArrayDict(relations:
            relationshipDict(name: "test", dest: "Test", joins: [joinAttributeDict(sourceName: "userId", destName: "userId")], mandatory: false, toMany: true, owns: true)
        )
        let ftcs = fetchArrayDict(fetches:
            fetchDict(name: "allUsers", arguments: ["search"], maxCount: nil, qualifiers: [
                qualifierDict(type: QualifierType.Like, wildcard: WildcardType.BEGINS_WITH, subQualifier: nil, function: nil, attribute: "name", relationship: nil, arg: "search", optional: false)
                ]
            )
        )
        let so = sortOrderArrayDict(attributeNames: ["name", "userId"], asc: true)
        let modelName : String = "User"
        let jsonDict = modelDict( name: modelName, package: "models", table: "user", primaryKeys: ["userId"],
                                         sortOrder: so,
                                         indexes: [indexDict(columns: ["name"], unique: false)],
                                         attributes: attr,
                                         relationships: rels,
                                         fetches: ftcs
        )
        let jsonString = jsonStringFrom(mapping: jsonDict)
        writeJson(jsonString: jsonString, output: "model")
        let mdl = Model(jsonString: jsonString)!
//        let mdl = try! JSONDecoder().decode(Model.self, from: data)
        XCTAssertNotNil(mdl)
        let problems = mdl.validate()
        if ( problems.count > 0 ) {
            print("Model Validation Errors:\n\t" + problems.joined(separator: "\n\t"))
        }
        XCTAssertEqual(problems.count, 0)
        XCTAssertEqual(mdl.name, modelName)
        XCTAssertNotNil(mdl.attributeNamed(name: "name"))

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
