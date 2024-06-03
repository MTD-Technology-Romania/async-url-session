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

    public enum ServerError: LocalizedError {
        case decodingError(DecodingError)
        case noInternetConnection
        case timeout
        case internalServerError
        case other(statusCode: Int, response: HTTPURLResponse, details: String)

        public var errorDescription: String? {
            switch self {
            case .decodingError(let decodingError):
                return "Decoding error: \(decodingError.localizedDescription)"
            case .noInternetConnection:
                return "No internet connection."
            case .timeout:
                return "The request timed out."
            case .internalServerError:
                return "Internal server error."
            case .other(_, _, let details):
                return details
            }
        }
    }

    case requestError(RequestError)
    case serverError(ServerError)
}
