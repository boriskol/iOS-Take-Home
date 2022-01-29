import UIKit
//import Combine


public enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

protocol ApiProvider: AnyObject {
    
    func search<T: Codable>(search: String?, decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func trending<T: Codable>(decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    func searchGif<T: Codable>(gifId: String?, decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
    
}

private struct Domain {
    static let scheme = "https"
    static let host = "api.giphy.com"
    static let trending = "/v1/gifs/trending"
    static let search = "/v1/gifs/search"
    static let searchGifId = "/v1/gifs/"
}

class GifAPIClient: ApiProvider {
    
    private func createURL(search: String?, gifId: String?) -> URLRequest {
        
        var queryItems = [URLQueryItem]()
        if search != nil {
            queryItems.append(URLQueryItem(name: "q", value: search))
            queryItems.append(URLQueryItem(name: "limit", value: Constants.limit))
            queryItems.append(URLQueryItem(name: "rating", value: Constants.rating))
            queryItems.append(URLQueryItem(name: "lang", value: Constants.lang))
        }else if gifId != nil{
            //queryItems.append(URLQueryItem(name: "gif_id", value: gifId))
        }else{
            queryItems.append(URLQueryItem(name: "limit", value: Constants.limit))
            queryItems.append(URLQueryItem(name: "rating", value: Constants.rating))
            queryItems.append(URLQueryItem(name: "lang", value: Constants.lang))
        }
        queryItems.append(URLQueryItem(name: "api_key", value: Constants.giphyApiKey))
        
            
        var components = URLComponents()
        components.scheme = Domain.scheme
        components.host = Domain.host
        if search != nil {
            components.path = Domain.search
        }else if gifId != nil {
            components.path = Domain.searchGifId + gifId!
        }else{
            components.path = Domain.trending
        }
        
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = components.url else { preconditionFailure("Bad URL") }
        debugPrint(url.absoluteString)
        
        let request = URLRequest(url: url)
        return request
    }
    
    func search<T: Codable>(search: String?, decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        return callT(method: createURL(search: search, gifId: nil).url!, completion: completion)
    }
    func trending<T: Codable>(decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void){
        return callT(method: createURL(search: nil, gifId: nil).url!, completion: completion)
    }
    func searchGif<T: Codable>(gifId: String?, decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        return callT(method: createURL(search: nil, gifId: gifId).url!, completion: completion)
    }
    
    
    func callT<T: Codable>(method: URL, completion: @escaping (Result<T, APIError>) -> Void){
        let config = URLSessionConfiguration.default
        config.allowsConstrainedNetworkAccess = false
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: method) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, (200 ..< 300) ~= httpResponse.statusCode
                else {DispatchQueue.main.async {
                    debugPrint("httpResponse error \(response.debugDescription)")
                    completion(.failure(.serverError))}
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    debugPrint("error \(error.debugDescription)")
                    completion(.failure(.serverError))}
                return
            }
            guard let data = data else {
                debugPrint("Parsing Error")
                completion(.failure(.parsingError))
                return
            }
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    //debugPrint("Parsing object")
                    completion(.success(object))
                }
            } catch {
                debugPrint("parsingError catch")
                completion(.failure(.parsingError))
            }
        }
        task.resume()
    }
    
}
