//
// © 2024 Test weather-app
//

import Foundation

final class HTTPClient {
    typealias Completion<T> = (HTTPRequest, Int?, Result<T, Error>) -> Void

    private let endpoint: URL
    private let urlSession: URLSession

    init(
        endpoint: URL,
        urlSession: URLSession
    ) {
        self.endpoint = endpoint
        self.urlSession = urlSession
    }

    func perform<T: Decodable>(
        _ request: HTTPRequest,
        header: [String: String] = [:],
        callbackQueue: DispatchQueue = DispatchQueue.main,
        completion: @escaping Completion<T>
    ) {
        guard let urlRequest = buildRequest(from: request, header: header) else {
            completion(request, nil, .failure("unable to build url request"))
            return
        }
        let task = urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            let code = (response as? HTTPURLResponse)?.statusCode

            if let statusCode = code, (statusCode < 200 || statusCode > 299) {
                var userInfo: [String: Any]?

                if let data {
                    userInfo = ["data": data]
                }

                let error = NSError(
                    domain: URLError.errorDomain,
                    code: statusCode,
                    userInfo: userInfo
                )
                completion(request, statusCode, .failure(error))
                return
            }

            if let error = error {
                completion(request, code, .failure(error))
                return
            }

            guard let data = data else {
                completion(request, code, .failure("bad response"))
                return
            }
            if let result: T = self?.processResponse(data) {
                completion(request, code, .success(result))
            } else {
                completion(request, code, .failure("unable to decode response"))
            }
        }
        task.resume()
    }

    private func buildRequest(
        from httpRequest: HTTPRequest,
        header: [String: String]
    ) -> URLRequest? {
        guard var components = URLComponents(string: endpoint.absoluteString) else {
            return nil
        }
        components.path = httpRequest.path
        components.queryItems = httpRequest.parameters.map { parameter in
            URLQueryItem(name: parameter.name, value: parameter.value)
        }

        guard let url = components.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpRequest.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "accept")

        if let contentType = httpRequest.contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let data = httpRequest.body {
            request.httpBody = data
        }
        return request
    }

    private func processResponse<T: Decodable>(_ data: Data) -> T? {
        guard T.self != Data.self else {
            return data as? T
        }

        let decoder = JSONDecoder()
        guard let responseObject = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        return responseObject
    }
}

extension String: Error {}
