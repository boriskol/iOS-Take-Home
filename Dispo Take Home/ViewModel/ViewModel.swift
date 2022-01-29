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
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(obj: $0) })
                //let d = linkdata.data.compactMap({GifCollectionViewCellViewModel(obj: $0)})
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
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(obj: $0) })
                //let d = linkdata.data.compactMap({GifCollectionViewCellViewModel(obj: $0)})
                completion(d)
            }
        })
    }
    func searchGifId(gifId:String, completion: @escaping (APGifResponse) -> Void) {
        apiProvider?.getRequest(urlParams: [:], gifAcces: gifId, decodable: APGifResponse.self, completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
               completion(linkdata)
            }
        })
    }
    
    deinit{
        debugPrint("deinit GifApiClientCall")
    }
}
