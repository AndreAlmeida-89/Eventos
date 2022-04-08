//
//  EventDetailViewModel.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation
import RxSwift

protocol EventDetailViewModelContract {
    func getEvent()
    func postCheckin(name: String, email: String)
    var event: PublishSubject<Event> { get set }
    var loadingIsHidden: PublishSubject<Bool> { get set }
    var error: PublishSubject<LocalizedError> { get set }
}

enum CheckinError: LocalizedError {
    case invalidEmail
    case invalidName

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "E-mail inválido"
        case .invalidName:
            return "Nome inválido"
        }
    }
}

class EventDetailViewModel: EventDetailViewModelContract {
    private let getEventService: GetEventServicing
    private let postCheckInServicing: PostCheckInServicing
    var event: PublishSubject<Event> = PublishSubject()
    var error: PublishSubject<LocalizedError> = PublishSubject()
    var loadingIsHidden: PublishSubject<Bool> = PublishSubject()
    var onCompleteCheckin: PublishSubject<Bool> = PublishSubject()
    private let eventId: Int

    init(eventService: GetEventServicing, postCheckInServicing: PostCheckInServicing, eventId: Int) {
        self.getEventService = eventService
        self.postCheckInServicing = postCheckInServicing
        self.eventId = eventId
    }

    func getEvent() {
        loadingIsHidden.onNext(false)
        getEventService.getEvent(by: eventId) { (result: Response<Event>) in
            self.loadingIsHidden.onNext(true)
            switch result {
            case .success(let events):
                self.event.onNext(events)
            case .failure(let error):
                self.error.onNext(error)
            }
        }
    }

    func postCheckin(name: String, email: String) {
        guard validateName(name) else {
            self.error.onNext(CheckinError.invalidName)
            return
        }

        guard validateEmail(email) else {
            self.error.onNext(CheckinError.invalidEmail)
            return
        }

        let checkin = ChekIn(eventId: eventId, name: name, email: email)
        postCheckInServicing.postCheckIn(checkin) { result in
            switch result {
            case .success:
                self.onCompleteCheckin.onNext(true)
            case .failure(let error):
                self.error.onNext(error)
            }
        }

    }

    private func validateName(_ name: String) -> Bool {
        TextInputValidator.isValidEmail(name)
    }

    private func validateEmail(_ email: String) -> Bool {
        TextInputValidator.isValidEmail(email)
    }
}
