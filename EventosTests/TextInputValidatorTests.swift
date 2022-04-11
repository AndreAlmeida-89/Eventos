//
//  TextInputValidatorTests.swift
//  EventosTests
//
//  Created by André Felipe de Sousa Almeida - AAD on 10/04/22.
//

import XCTest
@testable import Eventos

class TextInputValidatorTests: XCTestCase {

    func tests_isValidEmail_givenAValidEmail_ShouldReturnTrue() throws {
        XCTAssertTrue(TextInputValidator.isValidEmail("test@test.com"))
    }

    func tests_isValidEmail_givenAnInalidEmail_ShouldReturnFalse() throws {
        XCTAssertFalse(TextInputValidator.isValidEmail("test@test"))
    }

    func tests_isValidName_givenAValidName_ShouldReturnTrue() throws {
        XCTAssertTrue(TextInputValidator.isValidName("test@test.com"))
    }

    func tests_isValidName_givenAnInvalidName_ShouldReturnFalse() throws {
        XCTAssertFalse(TextInputValidator.isValidName(""))
    }
}
