//
//  SearchViewModel.swift
//  Dispo Take Home
//
//  Created by Borna Libertines on 20/01/22.
//

import Foundation
import Combine

class GifApiClientCall {
    
    static let shared = GifApiClientCall()
    
    var apiProvider: GifAPIClient?
    
    
    init(apiProvider: GifAPIClient = GifAPIClient()){
        self.apiProvider = apiProvider
    }
    
    
    func noquery(completion: @escaping ([GifCollectionViewCellViewModel]) -> Void) {
        apiProvider?.trending(decodable: APIListResponse.self, completion: { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({return GifCollectionViewCellViewModel(obj: $0)}) 
                //let d = linkdata.data.compactMap({GifCollectionViewCellViewModel(obj: $0)})
                //DispatchQueue.main.async { [weak self] in
                completion(d)
                //}
            }
        })
    }
    func search(search:String?, completion: @escaping ([GifCollectionViewCellViewModel]) -> Void) {
        apiProvider?.search(search: search, decodable: APIListResponse.self, completion: { [weak self] result in
            guard self != nil else {return}
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({return GifCollectionViewCellViewModel(obj: $0)}) 
                //let d = linkdata.data.compactMap({GifCollectionViewCellViewModel(obj: $0)})
                //DispatchQueue.main.async { [weak self] in
                completion(d)
                //}
            }
        })
    }
    func searchGifId(gifId:String?, completion: @escaping (APGifResponse) -> Void) {
        apiProvider?.searchGif(gifId: gifId, decodable: APGifResponse.self, completion: { [weak self] result in
            guard self != nil else {return}
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
               // DispatchQueue.main.async { [weak self] in
                completion(linkdata)
               // }
            }
        })
    }
    
    deinit{
        debugPrint("deinit GifApiClientCall")
    }
}
