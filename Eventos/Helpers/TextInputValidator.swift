//
//  TextInputValidator.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 08/04/22.
//

import Foundation

enum Regex: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case fullName =  "^(?=.{2,100}$)[A-Za-zÀ-ú][A-Za-zÀ-ú.'-]+(?: [A-Za-zÀ-ú.'-]+)* *$"
}

struct TextInputValidator {
    static let format = "SELF MATCHES %@"

    static func isValidEmail(_ email: String) -> Bool {
        let emailPredicate = NSPredicate(format: format,
                                         Regex.email.rawValue)
        return emailPredicate.evaluate(with: email)
    }

    static func isValidFullName(_ username: String) -> Bool {
        let usernamePredicate = NSPredicate(format: format,
                                            Regex.fullName.rawValue)
        return usernamePredicate.evaluate(with: username)
    }
}
