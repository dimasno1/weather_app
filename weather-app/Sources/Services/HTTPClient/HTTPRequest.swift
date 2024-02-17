//
// © 2024 Test weather-app
//

import Foundation

struct HTTPRequest: Hashable {
    var method: Method
    var path: String

    var parameters: [QueryParameter]

    var body: Data?
    var contentType: String?

    init(
        method: Method,
        path: String,
        parameters: [QueryParameter] = [],
        body: Data? = nil,
        contentType: String? = "application/json"
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.body = body
        self.contentType = contentType
    }
}

extension HTTPRequest {
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
    }

    struct QueryParameter: Hashable {
        var name: String
        var value: String?
    }
}
