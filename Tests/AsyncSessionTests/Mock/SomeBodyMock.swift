//
//  SomeBodyMock.swift
//  AsyncSession
//
//  Created by Daniel Mandea on 14.07.2023.
//

import Foundation

struct SomeBodyMock: Codable {
    var title: String
    var subtitle: String
    
    static func mock() -> SomeBodyMock {
        SomeBodyMock(title: "title", subtitle: "subtitle")
    }
}
