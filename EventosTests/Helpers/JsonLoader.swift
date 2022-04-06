//
//  JsonLoader.swift
//  EventosTests
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation
@testable import Eventos

class JsonLoader {
    static var MockedEventsList: [Event] {
        loadJson(filename: "MockedEventsList") ?? []
    }

    static func loadJson<T: Decodable>(filename: String) -> T? {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
            let data = try? Data.init(contentsOf: url)
            let decodedData = try? JSONDecoder().decode(T.self, from: data ?? Data())
            return decodedData
        }
        return nil
    }
}