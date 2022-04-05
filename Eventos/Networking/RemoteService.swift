//
//  RemoteService.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

protocol RemoteServicing {
    func getEvents(handler: @escaping (Result<[Event], Error>) -> Void)
}

class RemoteService: RemoteServicing {
    func getEvents(handler: @escaping (Result<[Event], Error>) -> Void) {
        
    }
}
