//
//  RemoteServiceTests.swift
//  EventosTests
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import XCTest
@testable import Eventos

class RemoteServiceTests: XCTestCase {
    
    var sut: RemoteServicing!

    override func setUpWithError() throws {
        sut = RemoteService()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_getEvents_shouldSucess(){
    
    }

}
