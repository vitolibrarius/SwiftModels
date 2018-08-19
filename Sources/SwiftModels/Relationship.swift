//
//  SwiftModels
//
//  Created by vito on 2018-08-07.
//

import Foundation

public struct Join : Mappable {
    let destinationAttribute: String
    let sourceAttribute: String
}

public struct Relationship : Mappable {
    let destination: String
    let destinationTable: String
    let joins: [Join]
    let isMandatory: Bool
    let isToMany: Bool
    let ownsDestination: Bool
}
