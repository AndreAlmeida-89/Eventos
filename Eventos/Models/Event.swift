//
//  Event.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

struct Event: Decodable {
    let people: [User]
    let date: Int
    let description: String
    let image: String
    let longitude: Double
    let latitude: Double
    let price: Double
    let title: String
    let id: String
}
