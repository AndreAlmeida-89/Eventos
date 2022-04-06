//
//  NetworkError.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case unknown(error: Error)
    case noData
    case noURLResponse
    case badStatus(code: Int)
    case decodingError

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "O aplicativo tentou acessar uma URL inválida."
        case .unknown(let error):
            return "Um erro inesperado aconteceu: \(error.localizedDescription)"
        case .noData:
            return "Erro ao acessar a API"
        case .noURLResponse:
            return "Nenhuma resposta do servidor."
        case .badStatus(let code):
            switch code {
            case 100..<200:
                return "Erro lentidão ao tentar acessar o servidor."
            case 400..<500:
                return "Erro ao tentar conectar ao servidor. Verifique sua conexão."
            case 500..<600:
                return "Erro no servidor. Volte mais tarde"
            default:
                return "Código inválido: \(code)"
            }
        case .decodingError:
            return "Dado inválido"
        }
    }
}
