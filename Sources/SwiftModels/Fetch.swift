//
//  SwiftModels
//
//  Created by vito on 2018-08-07.
//

import Foundation

public struct Fetch : Mappable {
    let arguments: [String]
    let maxCount: Int? = 0
    let qualifiers: [Qualifier]
    enum CodingKeys : String, CodingKey {
        case arguments
        case maxCount
        case qualifiers
    }
}
