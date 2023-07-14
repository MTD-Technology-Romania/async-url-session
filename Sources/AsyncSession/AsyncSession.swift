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
    
    // MARK: - Init
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
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
    
    public func request<Body: Encodable>(url: URL, method: Method, headers: [String: String], body: Body? = nil) throws -> URLRequest {
        var urlRequest = try request(url: url, method: method, headers: headers)
        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        return urlRequest
    }
    
    public func request(url: URL, method: Method, headers: [String: String]) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        for key in headers.keys {
            urlRequest.addValue(headers[key] ?? "", forHTTPHeaderField:key)
        }
        return urlRequest
    }
    
    // MARK: - Requests
    
    public func data<Response: Decodable>(for request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = (response as? HTTPURLResponse) else {
            throw NetworkError.serverError(.internalServerError)
        }
        
        guard httpResponse.statusCode < 300 else {
            let error = String(data: data, encoding: .utf8) ?? "Unknown Error"
            Logger.sdk.error("There has been an error \(error)")
            throw NetworkError.serverError(.other(statusCode: httpResponse.statusCode, response: httpResponse))
        }
        Logger.sdk.info("Response \n \(String(data: data, encoding: .utf8) ?? "Unknown response")")
        return try JSONDecoder().decode(Response.self, from: data)
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
    
    public func delete<Body: Encodable, Response: Decodable>(url: URL, headers: [String: String], body: Body? = nil) async throws -> Response {
        try await data(for: try request(url: url, method: .delete, headers: headers, body: body))
    }
}
