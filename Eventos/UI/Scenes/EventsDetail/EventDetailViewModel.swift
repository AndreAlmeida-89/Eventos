//
//  EventDetailViewModel.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation
import RxSwift

protocol EventDetailViewModelContract {
    func getEvent(by id: Int)
    var event: PublishSubject<Event> { get set }
    var loadingIsHidden: PublishSubject<Bool> { get set }
    var error: PublishSubject<NetworkError> { get set }
}

class EventDetailViewModel: EventDetailViewModelContract {
    private let getEventService: GetEventServicing
    var event: PublishSubject<Event> = PublishSubject()
    var error: PublishSubject<NetworkError> = PublishSubject()
    var loadingIsHidden: PublishSubject<Bool> = PublishSubject()

    init(eventService: GetEventServicing) {
        self.getEventService = eventService
    }

    func getEvent(by id: Int) {
        loadingIsHidden.onNext(false)
        getEventService.getEvent(by: id) { (result: Response<Event>) in
            self.loadingIsHidden.onNext(true)
            switch result {
            case .success(let events):
                    self.event.onNext(events)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }
}
