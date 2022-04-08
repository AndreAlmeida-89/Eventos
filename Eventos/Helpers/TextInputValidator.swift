//
//  TextInputValidator.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 08/04/22.
//

import Foundation

struct TextInputValidator {
    private static let format = "SELF MATCHES %@"
    private static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    static func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: format, emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    static func isValidName(_ username: String) -> Bool {
        !username.isEmpty
    }
}
