//
//  SearchViewModel.swift
//  Dispo Take Home
//
//  Created by Borna Libertines on 21/01/22.
//

import UIKit

// MARK: GifApiClientCall
/*
 responseble to calling api and return velues view model
 */

class GifApiClientCall {
    
    static let shared = GifApiClientCall()
    var apiProvider: GifAPIClient?
    
    init(apiProvider: GifAPIClient = GifAPIClient()){
        self.apiProvider = apiProvider
    }
    
   
    func noquery(completion: @escaping ([GifCollectionViewCellViewModel]) -> Void) {
        apiProvider?.getRequest(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifAcces: Constants.trending, decodable: APIListResponse.self, completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
                })
                completion(d)
            }
        })
    }
    
    func search(search:String, completion: @escaping ([GifCollectionViewCellViewModel]) -> Void) {
        apiProvider?.getRequest(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifAcces: Constants.search, decodable: APIListResponse.self, completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url) })
                completion(d)
            }
        })
    }
    func searchGifId(gifId:String, completion: @escaping (GifViewCellViewModel) -> Void) {
        apiProvider?.getRequest(urlParams: [:], gifAcces: gifId, decodable: APGifResponse.self, completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = GifViewCellViewModel(id: linkdata.data.id, title: linkdata.data.title, rating: linkdata.data.rating, Image: linkdata.data.images?.fixed_height?.url, video: linkdata.data.images?.fixed_height?.mp4, url: linkdata.data.url)
               completion(d)
            }
        })
    }
    
    deinit{
        debugPrint("deinit GifApiClientCall")
    }
}
