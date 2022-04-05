//
//  ChekIn.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

struct ChekIn: Codable {
    let eventId: Int
    let name: String
    let email: String
}

extension ChekIn: Equatable {
    static func == (lhs: ChekIn, rhs: ChekIn) -> Bool {
        lhs.eventId == rhs.eventId &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email
    }
}
