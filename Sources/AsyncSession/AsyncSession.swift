//
//  AsyncSession.swift
//  AsyncSession
//
//  Created by Daniel Mandea on 25.06.2023.
//

import Foundation
import os.log

open class AsyncSession {

    // MARK: - Private vars

    private var session: URLSession
    private var decoder: JSONDecoder
    private var encoder: JSONEncoder

    // MARK: - Init

    public init(
        session: URLSession = URLSession.shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }

    // MARK: - HTTP Method (GET, PUT, POST)

    public enum Method: String, CaseIterable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }

    // MARK: - Factory URLRequest

    open func request(url: URL, method: Method, headers: [String: String], body: Encodable? = nil) async throws -> URLRequest {
        var urlRequest = try await request(url: url, method: method, headers: headers)
        if let body = body {
            urlRequest.httpBody = try encoder.encode(body)
        }
        return urlRequest
    }

    open func request(url: URL, method: Method, headers: [String: String]) async throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        for key in headers.keys {
            urlRequest.addValue(headers[key] ?? "", forHTTPHeaderField:key)
        }
        return urlRequest
    }

    // MARK: - Requests

    open func data<Response: Decodable>(for request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = (response as? HTTPURLResponse) else {
            throw NetworkError.serverError(.internalServerError)
        }

        if !(200..<300).contains(httpResponse.statusCode) {
            let errorDetails = String(data: data, encoding: .utf8) ?? "Unknown error"
            Logger.error("Request failed with status code \(httpResponse.statusCode)", details: errorDetails)
            throw NetworkError.serverError(.other(statusCode: httpResponse.statusCode, response: httpResponse, details: errorDetails))
        }
        return try decoder.decode(Response.self, from: data)
    }

    public func get<Response: Decodable>(url: URL, headers: [String: String]) async throws -> Response {
        try await data(for: try request(url: url, method: .get, headers: headers))
    }

    public func post<Body: Encodable, Response: Decodable>(url: URL, headers: [String: String], body: Body? = nil) async throws -> Response {
        try await data(for: try request(url: url, method: .post, headers: headers, body: body))
    }

    public func put<Body: Encodable, Response: Decodable>(url: URL, headers: [String: String], body: Body? = nil) async throws -> Response {
        try await data(for: try request(url: url, method: .put, headers: headers, body: body))
    }

    public func patch<Body: Encodable, Response: Decodable>(url: URL, headers: [String: String], body: Body? = nil) async throws -> Response {
        try await data(for: try request(url: url, method: .patch, headers: headers, body: body))
    }

    public func delete<Response: Decodable>(url: URL, headers: [String: String], body: Encodable? = nil) async throws -> Response {
        try await data(for: try request(url: url, method: .delete, headers: headers, body: body))
    }

    // MARK: - Methods without body

    public func post<Response: Decodable>(url: URL, headers: [String: String]) async throws -> Response {
        try await data(for: try request(url: url, method: .post, headers: headers, body: nil))
    }

    public func put<Response: Decodable>(url: URL, headers: [String: String]) async throws -> Response {
        try await data(for: try request(url: url, method: .put, headers: headers, body: nil))
    }

    public func patch<Response: Decodable>(url: URL, headers: [String: String]) async throws -> Response {
        try await data(for: try request(url: url, method: .patch, headers: headers, body: nil))
    }

    public func delete<Response: Decodable>(url: URL, headers: [String: String]) async throws -> Response {
        try await data(for: try request(url: url, method: .delete, headers: headers, body: nil))
    }
}
