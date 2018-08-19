//
//  SwiftModels
//
//  Created by vito on 2018-08-07.
//

import Foundation

public enum WildcardType: String, Codable  {
    case BEGINS_WITH
    case ENDS_WITH
    case BOTH
}

public enum SemanticType: String, Codable  {
    case AND
    case OR
    case NOT
}

public enum QualifierType: String, Codable  {
    case Equals
    case Related
    case Like
    case InSubQuery
    case Aggregate
    case GreaterThan
    case LessThan
    case GreaterThanOrEqual
    case LessThanOrEqual
}

public struct SubQualifier : Mappable {
    let type: QualifierType
    let attributeName: String?
    let function: String?
}

public struct Qualifier : Mappable {
    let type: QualifierType
    let wildcard: WildcardType?
    let function: String?
    let attributeName: String?
    let relationshipName: String?
    let argumentName: String?
    let subQualifier: SubQualifier?
    let optional: Bool? = false
}
