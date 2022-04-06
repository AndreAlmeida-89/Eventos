//
//  RemoteService.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 05/04/22.
//

import Foundation

typealias Completion<T: Decodable> = (Result<T, NetworkError>) -> Void

protocol RemoteServicing {
    func makeRequest<T: Decodable>(to route: Route, handler: @escaping Completion<T>)
}

class RemoteService: RemoteServicing {
    let session: URLSession
    init(session: URLSession = .shared) {
        self.session = session
    }
    func makeRequest<T: Decodable>(to route: Route, handler: @escaping Completion<T>) {
        guard let url = route.url else {
            handler(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = route.method
        if let requestBody = route.requestBody {
            request.httpBody = requestBody
        }
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(.unknown(error: error)))
                return
            }
            guard let data = data else {
                handler(.failure(.noData))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(.noURLResponse))
                return
            }
            guard (200..<300).contains(response.statusCode) else {
                handler(.failure(.badStatus(code: response.statusCode)))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                handler(.success(decodedData))
            } catch {
                handler(.failure(.decodingError))
            }
        }
        .resume()
    }
}
