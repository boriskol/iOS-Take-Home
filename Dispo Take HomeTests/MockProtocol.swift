//
//  MockSession.swift
//  Dispo Take HomeTests
//
//  Created by Borna Libertines on 31/01/22.
//


import Foundation
struct GifCollectionViewCellViewModel {
    let id: String?
    let title: String?
    let rating: String
    let Image: URL?
    let url: URL?
}
enum APError: Error {
    case internalError
    case serverError
    case parsingError
}
protocol ApiProviderT {
    func getRequest<T: Codable>(urlParams: [String:String], gifAcces: String?, decodable: T.Type, completion: @escaping (Result<T?, APError>) -> Void)
}
class MockedService: ApiProviderT {
    
    let gifListViewModel: GifCollectionViewCellViewModel? = GifCollectionViewCellViewModel(id: "10", title: "test", rating: "g", Image: nil, url: nil)
    func getRequest<T>(urlParams: [String : String], gifAcces: String?, decodable: T.Type, completion: @escaping (Result<T?, APError>) -> Void){
        completion(.failure(APError.parsingError))
        //completion(.success(gifListViewModel as? T))
                   
    }
    
    
    
   
}
