import Foundation
import Entity

// MARK: - Enum

public enum APIError: Error {
    case error(message: String)
}

public enum APIRequestState {
    case none
    case requesting
    case success
    case error
}

public enum HTTPMethod {
    case GET
    case POST
}

// MARK: - Protocol

public protocol APIClientManagerProtocol {
}

public final class ApiClientManager {

    // MARK: - Singleton Instance

    public static let shared = ApiClientManager()

    private init() {}

    // MARK: - Enum

    private enum EndPoint: String {

        case pickupFoods = "pickup_foods"
        case popularFoods = "popular_foods"

        func getBaseUrl() -> String {
            return [host, self.rawValue].joined(separator: "/")
        }
    }

    // MARK: - Properties

    private static let host = "http://localhost:3000"

    // MARK: - Function

    public func executeAPIRequest<T: Decodable>(endpointUrl: String, withParameters: [String : Any] = [:], httpMethod: HTTPMethod = .GET, responseFormat: T.Type) async throws -> T {

        var urlRequest: URLRequest
        switch httpMethod {
        case .GET:
            urlRequest = makeGetRequest(endpointUrl, withParameters: withParameters)
        case .POST:
            urlRequest = makePostRequest(endpointUrl, withParameters: withParameters)
        }
        return try await handleAPIRequest(responseType: T.self, urlRequest: urlRequest)
    }

    // MARK: - Private Function

    private func handleAPIRequest<T: Decodable>(responseType: T.Type, urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await executeUrlSession(urlRequest: urlRequest)
        let _ = try handleErrorByStatusCode(urlRequest: urlRequest, response: response)
        return try decodeDataToJson(data: data)
    }

    private func executeUrlSession(urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(for: urlRequest)
        } catch {
            throw APIError.error(message: "No network connection.")
        }
    }

    private func handleErrorByStatusCode(urlRequest: URLRequest, response: URLResponse) throws {
        let urlString = String(describing: urlRequest.url?.absoluteString)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.error(message: "No http response (\(urlString)).")
        }
        switch httpResponse.statusCode {
        case 200...399:
            break
        case 400:
            throw APIError.error(message: "Bad Request (\(urlString)).")
        case 401:
            throw APIError.error(message: "Unauthorized (\(urlString)).")
        case 403:
            throw APIError.error(message: "Forbidden (\(urlString)).")
        case 404:
            throw APIError.error(message: "Not Found (\(urlString)).")
        default:
            throw APIError.error(message: "Unknown (\(urlString)).")
        }
    }

    private func decodeDataToJson<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.error(message: "Failed decode data.")
        }
    }

    private func makeGetRequest(_ urlString: String, withParameters: [String : Any] = [:]) -> URLRequest {
        var urlComponents = URLComponents(string: urlString)
        var targetQueryItems: [URLQueryItem] = []
        for (key, value) in withParameters {
            targetQueryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        if !targetQueryItems.isEmpty {
            urlComponents?.queryItems = targetQueryItems
        }

        guard let url = urlComponents?.url else {
            fatalError("Invalid URL strings.")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let authraizationHeader = ""
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }

    private func makePostRequest(_ urlString: String, withParameters: [String : Any] = [:]) -> URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL strings.")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        do {
            let requestBody = try JSONSerialization.data(withJSONObject: withParameters, options: [])
            urlRequest.httpBody = requestBody
        } catch {
            fatalError("Invalid request body parameters.")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let authraizationHeader = ""
        urlRequest.addValue(authraizationHeader , forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

// MARK: - ApiClientManagerProtocol

extension ApiClientManager: APIClientManagerProtocol {}
