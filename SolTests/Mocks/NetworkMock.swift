//
//  NetworkMock.swift
//  SolTests
//
//  Created by Júlio César Flores on 26/05/22.
//

import Foundation
@testable import Sol

final class NetworkMock: NetworkSession {
    private(set) var queriedURL: URL?
    let injectedResponse: Data
    
    init(response: Data) {
        self.injectedResponse = response
    }
    
    func data(for urlRequest: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        self.queriedURL = urlRequest.url
        return (self.injectedResponse, URLResponse())
    }
}
