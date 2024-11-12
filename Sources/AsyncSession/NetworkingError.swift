//
//  NetworkingError.swift
//  AsyncSession
//
//  Created by Daniel Mandea on 14.07.2023.
//

import Foundation

public protocol APIErrorDecoder {
    func decodeError(data: Data, response: HTTPURLResponse) -> Error
}

public enum NetworkError: Error, LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestError(let requestError):
            return requestError.errorDescription
        case .serverError(let serverError):
            return serverError.errorDescription
        }
    }

    public enum RequestError {
        case invalidRequest(URLRequest)
        case encodingError(EncodingError)
        case other(NSError)

        var errorDescription: String {
            switch self {
            case .invalidRequest(let uRLRequest):
                return "Invalid request: \(uRLRequest.description)"
            case .encodingError(let encodingError):
                return "Encoding error: \(encodingError.localizedDescription)"
            case .other(let nSError):
                return "Other error: \(nSError.localizedDescription)"
            }
        }
    }

    public enum ServerError: LocalizedError {
        case decodingError(DecodingError)
        case noInternetConnection
        case timeout
        case internalServerError
        case apiError(message: String)
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
            case .apiError(let message):
                return message
            case .other(_, _, let details):
                return details
            }
        }
    }

    case requestError(RequestError)
    case serverError(ServerError)
}
