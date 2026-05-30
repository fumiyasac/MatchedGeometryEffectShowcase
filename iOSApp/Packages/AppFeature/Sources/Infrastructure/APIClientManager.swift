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

public protocol APIClientManagerProtocol {}

// MARK: - Endpoint

public enum APIEndpoint {

    private static let baseURL = "http://localhost:3000/api/v1"

    case galleryPhotos
    case galleryPhoto(id: Int)
    case pickupFoods
    case popularArticles
    case popularArticle(id: Int)
    case products
    case product(id: Int)
    case featured
    case news
    case search

    public var url: String {
        switch self {
        case .galleryPhotos:       return "\(Self.baseURL)/gallery_photos"
        case .galleryPhoto(let id): return "\(Self.baseURL)/gallery_photos/\(id)"
        case .pickupFoods:         return "\(Self.baseURL)/pickup_foods"
        case .popularArticles:     return "\(Self.baseURL)/popular_articles"
        case .popularArticle(let id): return "\(Self.baseURL)/popular_articles/\(id)"
        case .products:            return "\(Self.baseURL)/products"
        case .product(let id):     return "\(Self.baseURL)/products/\(id)"
        case .featured:            return "\(Self.baseURL)/featured"
        case .news:                return "\(Self.baseURL)/news"
        case .search:              return "\(Self.baseURL)/search"
        }
    }
}

// MARK: - ApiClientManager

public final class ApiClientManager {

    public static let shared = ApiClientManager()

    private init() {}

    public func executeAPIRequest<T: Decodable>(
        endpointUrl: String,
        withParameters: [String: Any] = [:],
        httpMethod: HTTPMethod = .GET,
        responseFormat: T.Type
    ) async throws -> T {
        let urlRequest: URLRequest
        switch httpMethod {
        case .GET:
            urlRequest = makeGetRequest(endpointUrl, withParameters: withParameters)
        case .POST:
            urlRequest = makePostRequest(endpointUrl, withParameters: withParameters)
        }
        return try await handleAPIRequest(responseType: T.self, urlRequest: urlRequest)
    }

    // MARK: - Private

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
        case 200...399: break
        case 400: throw APIError.error(message: "Bad Request (\(urlString)).")
        case 401: throw APIError.error(message: "Unauthorized (\(urlString)).")
        case 403: throw APIError.error(message: "Forbidden (\(urlString)).")
        case 404: throw APIError.error(message: "Not Found (\(urlString)).")
        default:  throw APIError.error(message: "Unknown (\(urlString)).")
        }
    }

    private func decodeDataToJson<T: Decodable>(data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.error(message: "Failed decode data.")
        }
    }

    private func makeGetRequest(_ urlString: String, withParameters: [String: Any] = [:]) -> URLRequest {
        var urlComponents = URLComponents(string: urlString)
        var queryItems: [URLQueryItem] = []
        for (key, value) in withParameters {
            queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
        }
        if !queryItems.isEmpty {
            urlComponents?.queryItems = queryItems
        }
        guard let url = urlComponents?.url else { fatalError("Invalid URL: \(urlString)") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func makePostRequest(_ urlString: String, withParameters: [String: Any] = [:]) -> URLRequest {
        guard let url = URL(string: urlString) else { fatalError("Invalid URL: \(urlString)") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: withParameters, options: [])
        } catch {
            fatalError("Invalid request body.")
        }
        return request
    }
}

extension ApiClientManager: APIClientManagerProtocol {}
