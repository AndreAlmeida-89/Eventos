//
//  Route.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

enum Route {
    case getEvents
    case getEvent(id: Int)
    case postCheckIn(body: ChekIn)
}

extension Route {
    private static let baseURL = "http://5f5a8f24d44d640016169133.mockapi.io/api"
    var url: URL? {
        switch self {
        case .getEvents:
            return URL(string: Route.baseURL + "/events")
        case .getEvent(id: let id):
            return URL(string: Route.baseURL + "/events/" + String(id))
        case .postCheckIn:
            return URL(string: Route.baseURL + "/checkin")
        }
    }
    var method: String {
        switch self {
        case .getEvents, .getEvent:
            return "GET"
        case .postCheckIn:
            return "POST"
        }
    }
    var requestBody: Data? {
        switch self {
        case .postCheckIn(body: let body):
            return try? JSONEncoder().encode(body)
        default:
            return nil
        }
    }
}
