//
//  EventsListViewModel.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation
import RxSwift

protocol EventsListViewModelContract {
    func getEvents()
    var events: PublishSubject<[Event]> { get set }
}

class EventsListViewModel: EventsListViewModelContract {
    private let getEventsService: GetEventsServicing
    private var disposeBag = DisposeBag()

    var events: PublishSubject<[Event]> = PublishSubject()
    let error: PublishSubject<NetworkError> = PublishSubject()
    let loading: PublishSubject<Bool> = PublishSubject()

    init(eventsService: GetEventsServicing) {
        self.getEventsService = eventsService
    }

    func getEvents() {
        loading.onNext(true)
        getEventsService.getEvents { (result: Response<[Event]>) in
            self.loading.onNext(false)
            switch result {
            case .success(let events):
                self.events.onNext(events)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
}
