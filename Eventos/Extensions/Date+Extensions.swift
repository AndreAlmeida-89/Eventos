//
//  Date+Extensions.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 07/04/22.
//

import Foundation

extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
