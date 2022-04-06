//
//  ChekIn.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

struct ChekIn: Encodable {
    let eventId: Int
    let name: String
    let email: String
}

struct ChekInResponse: Decodable {
    let code: Int
}

extension ChekIn: Equatable {
    static func == (lhs: ChekIn, rhs: ChekIn) -> Bool {
        lhs.eventId == rhs.eventId &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email
    }
}
