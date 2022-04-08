//
//  MockedGetEventsService.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation

class MockedGetEventsService: GetEventsServicing {
    func getEvents(handler: @escaping Completion<[Eventos.Event]>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            handler(.success(JsonLoader.mockedEventsList))
        }
    }
}

class MockedGetEventService: GetEventServicing {
    func getEvent(by id: Int, handler: @escaping Completion<Event>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             handler(.success(JsonLoader.mockedEvent))
//            handler(.failure(.noURLResponse))
        }
    }
}
