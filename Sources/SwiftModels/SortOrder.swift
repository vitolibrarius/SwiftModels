//
//  SwiftModels
//
//  Created by vito on 2018-08-07.
//

import Foundation

public enum OrderType: String, Codable {
    case ASC
    case DESC
}

public struct SortOrder : Mappable {
    let direction: OrderType
    let attribute: String
}
