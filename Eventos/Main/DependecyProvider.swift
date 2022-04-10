//
//  DependecyProvider.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 10/04/22.
//

import Foundation
import UIKit

struct DependecyProvider {
    static private var service: RemoteServicing {
        RemoteService()
    }

    static private var eventService: EventsServicing {
        EventsService(service: service)
    }

    static private var eventsListViewModel: EventsListViewModelContract {
        EventsListViewModel(eventsService: eventService)
    }

    static private func eventsDetailViewModel(id: Int) -> EventDetailViewModelContract {
        EventDetailViewModel(eventService: eventService, eventId: id)
    }

    static var eventsListViewController: EventsListViewController {
        let eventsListViewController = EventsListViewController()
        eventsListViewController.viewModel = eventsListViewModel
        return eventsListViewController
    }

    static func eventDetailViewController(id: Int) -> EventDetailViewController {
        let eventDetailViewController = EventDetailViewController()
        eventDetailViewController.viewModel = eventsDetailViewModel(id: id)
        return eventDetailViewController
    }
}
