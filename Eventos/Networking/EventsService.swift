//
//  EventsService.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

protocol EventsServicing {
    func getEvents(handler: @escaping Completion<[Event]>)
    func postCheckIn(_ checkin: ChekIn, handler: @escaping Completion<ChekInResponse>)
    func getEvent(by id: Int, handler: @escaping Completion<Event>)
}

final class EventsService: EventsServicing {
    let service: RemoteServicing

    init(service: RemoteServicing) {
        self.service = service
    }

    func getEvents(handler: @escaping Completion<[Event]>) {
        service.makeRequest(to: .getEvents, handler: handler)
    }

    func postCheckIn(_ checkin: ChekIn, handler: @escaping Completion<ChekInResponse>) {
        service.makeRequest(to: .postCheckIn(body: checkin), handler: handler)
    }

    func getEvent(by id: Int, handler: @escaping Completion<Event>) {
        service.makeRequest(to: .getEvent(id: id), handler: handler)
    }
}
