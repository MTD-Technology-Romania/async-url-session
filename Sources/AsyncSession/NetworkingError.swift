//
//  NetworkingError.swift
//  AsyncSession
//
//  Created by Daniel Mandea on 14.07.2023.
//

import Foundation

public enum NetworkError: Error {
    public enum RequestError {
        case invalidRequest(URLRequest)
        case encodingError(EncodingError)
        case other(NSError)
    }

    public enum ServerError {
        case decodingError(DecodingError)
        case noInternetConnection
        case timeout
        case internalServerError
        case other(statusCode: Int, response: HTTPURLResponse)
    }

    case requestError(RequestError)
    case serverError(ServerError)
}
