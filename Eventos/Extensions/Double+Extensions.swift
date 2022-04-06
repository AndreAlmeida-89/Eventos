//
//  Double+Extensions.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation

extension Double {
    var currencyFormat: String {
        let numberFormat = NumberFormatter()
        numberFormat.locale = Locale(identifier: "pt_BR")
        numberFormat.numberStyle = .currency
        return numberFormat.string(from: self as NSNumber) ?? ""
    }
}
