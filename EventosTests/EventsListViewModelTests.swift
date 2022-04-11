//
//  EventsListViewModelTests.swift
//  EventosTests
//
//  Created by André Felipe de Sousa Almeida - AAD on 10/04/22.
//

import RxSwift
import XCTest
@testable import Eventos

class EventsListViewModelTests: XCTestCase {

    var sut: EventsListViewModelContract!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        let mockGetEventsServicing = MockedGetEventsService()
        sut = EventsListViewModel(eventsService: mockGetEventsServicing)
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
    }

    func test_events_whentGetEventsIsCalled_shouldHaveCorrectEventsCount() throws {
        let expectation = expectation(description: "get items")
        let recoder = Recorder<Eventos.Event>()
        sut.getEvents()
        recoder.on(arraySubject: sut.events)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(recoder.items.count, JsonLoader.mockedEventsList.count)
    }

    func test_events_whentGetEventsIsNotCalled_shoulBeEmpty() throws {
        let expectation = expectation(description: "get items")
        let recoder = Recorder<Eventos.Event>()
        recoder.on(arraySubject: sut.events)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(recoder.items.count, .zero)
    }

    func test_loadingIsHidden_RightAfterGetEventsIsCalled_shouldBeFalse() throws {
        let expectation = expectation(description: "get items")
        let recoder = Recorder<Bool>()
        recoder.on(valueSubject: sut.loadingIsHidden)
        sut.getEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
            print(recoder.items)
        }
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(recoder.items[0])
    }

    func test_loadingIsHidden_RightBeforeGetEventsIsCalled_shouldBeTrue() throws {
        let expectation = expectation(description: "get items")
        let recoder = Recorder<Bool>()
        recoder.on(valueSubject: sut.loadingIsHidden)
        sut.getEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
            print(recoder.items)
        }
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(recoder.items[1])
    }
}
