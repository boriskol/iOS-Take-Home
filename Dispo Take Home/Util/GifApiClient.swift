import UIKit

// MARK: APIProvider
/*
 calls to api for app data
 */
public enum APIError: Error {
    case internalError
    case serverError
    case parsingError
}

protocol ApiProvider: AnyObject {
    func getRequest<T: Codable>(urlParams: [String:String], gifAcces: String?, decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void)
}

private struct Domain {
    static let scheme = "https"
    static let host = "api.giphy.com"
    static let path = "/v1/gifs/"
}

class GifAPIClient: ApiProvider {
    
    private func createUrl(urlParams: [String:String], gifacces: String?) -> URLRequest {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "api_key", value: Constants.giphyApiKey))
        for (key,value) in urlParams {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents()
        components.scheme = Domain.scheme
        components.host = Domain.host
        components.path = Domain.path+gifacces!
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = components.url else { preconditionFailure("Bad URL") }
        debugPrint(url.absoluteString)
        
        let request = URLRequest(url: url)
        return request
    }
    
    func getRequest<T: Codable>(urlParams: [String : String], gifAcces: String?, decodable: T.Type, completion: @escaping (Result<T, APIError>) -> Void){
        return callT(method: createUrl(urlParams: urlParams, gifacces: gifAcces).url!, completion: completion)
    }
    
    
    private func callT<T: Codable>(method: URL, completion: @escaping (Result<T, APIError>) -> Void){
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

