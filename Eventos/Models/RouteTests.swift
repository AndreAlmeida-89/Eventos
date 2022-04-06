//
//  RouteTests.swift
//  EventosTests
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import XCTest
@testable import Eventos

class RouteGetEventsTests: XCTestCase {
    var sut: Route!
    override func setUpWithError() throws {
        sut = .getEvents
    }
    override func tearDownWithError() throws {
        sut = nil
    }
    func test_getEvents_url() throws {
        XCTAssertEqual(sut.url, URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events")!)
    }
    func test_getEvents_method() throws {
        XCTAssertEqual(sut.method, "GET")
    }
    func test_getEvents_requestBodyShouldBeNil() throws {
        XCTAssertNil(sut.requestBody)
    }
}

class RoutePostCheckinTests: XCTestCase {
    var sut: Route!
    let mockedCheckIn = ChekIn(eventId: 1, name: "", email: "")
    override func setUpWithError() throws {
        sut = .postCheckIn(body: mockedCheckIn)
    }
    override func tearDownWithError() throws {
        sut = nil
    }
    func test_postCheckIn_url() throws {
        XCTAssertEqual(sut.url, URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/checkin")!)
    }
    func test_postCheckIn_urlWithDifferentId() throws {
        let mockedCheckIn2 = ChekIn(eventId: 2, name: "", email: "")
        let route = Route.postCheckIn(body: mockedCheckIn2)
        XCTAssertEqual(route.url, URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/checkin")!)
    }
    func test_postCheckIn_method() throws {
        XCTAssertEqual(sut.method, "POST")
    }
    func test_postCheckIn_requestBodyShoudNotBeNil() throws {
        XCTAssertNotNil(sut.requestBody)
    }
    func test_postCheckIn_requestBody() throws {
        if let encodedBoby = try? JSONEncoder().encode(mockedCheckIn) {
            XCTAssertEqual(sut.requestBody, encodedBoby)
        }
    }
}

class RouteGetEventTests: XCTestCase {
    var sut: Route!
    override func setUpWithError() throws {
        sut = .getEvent(id: 1)
    }
    override func tearDownWithError() throws {
        sut = nil
    }
    func test_getEvent_url() throws {
        XCTAssertEqual(sut.url, URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events/1")!)
    }
    func test_getEvent_urlWithDifferentId() throws {
        let route = Route.getEvent(id: 2)
        XCTAssertEqual(route.url, URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/events/2")!)
    }
    func test_getEvent_method() throws {
        XCTAssertEqual(sut.method, "GET")
    }
    func test_getEvent_requestBodyShouldBeNil() throws {
        XCTAssertNil(sut.requestBody)
    }
}
