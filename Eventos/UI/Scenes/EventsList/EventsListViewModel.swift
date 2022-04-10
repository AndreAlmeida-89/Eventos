//
//  EventsListViewModel.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation
import RxSwift

protocol EventsListViewModelContract: AnyObject {
    func getEvents()
    var events: PublishSubject<[Event]> { get set }
    var loadingIsHidden: PublishSubject<Bool> { get set }
    var error: PublishSubject<NetworkError> { get set }
}

class EventsListViewModel: EventsListViewModelContract {
    private let getEventsService: GetEventsServicing
    var events: PublishSubject<[Event]> = PublishSubject()
    var error: PublishSubject<NetworkError> = PublishSubject()
    var loadingIsHidden: PublishSubject<Bool> = PublishSubject()

    init(eventsService: GetEventsServicing) {
        self.getEventsService = eventsService
    }

    func getEvents() {
        loadingIsHidden.onNext(false)
        getEventsService.getEvents { (result: Response<[Event]>) in
            self.loadingIsHidden.onNext(true)
            switch result {
            case .success(let events):
                    self.events.onNext(events)

            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
}
