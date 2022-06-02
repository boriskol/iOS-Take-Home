//
//  GifListViewModel.swift
//  Dispo Take Home
//
//  Created by Borna Libertines on 22/01/22.
//

import Foundation
import UIKit

// MARK: MainViewModel
/*
 view model for MainViewController
 observe changes in values
 */

struct MainViewModel{
    // MARK:  Initializer Dependency injestion
    var gifs: Obsevbel<[GifCollectionViewCellViewModel]>// = Obsevbel([])
    
    var appiCall: ApiProvider?
    
    init(appiCall: ApiProvider = GifAPIClient(), gifs: Obsevbel<[GifCollectionViewCellViewModel]> = Obsevbel([])){
        self.appiCall = appiCall
        self.gifs = gifs
    }
    
    func loadGift(){
        
        appiCall?.getRequest(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifAcces: Constants.trending, decodable: APIListResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
                })
                self.gifs.value = d
            }
        })
    }
    // MARK: Parameter Dependency injestion
    /*
    func search(search: String, with dependency: GifAPIClient){
        dependency.getRequest(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifAcces: Constants.search, decodable: APIListResponse.self , completion:{ result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url) })
                self.gifs.value = d
            }
        })
    }*/
    func search(search: String){
        appiCall?.getRequest(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifAcces: Constants.search, decodable: APIListResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url) })
                self.gifs.value = d
            }
        })
    }
    
    func presentVCC(search: SearchResult, completion: @escaping (UIViewController) -> Void){
        let secondViewController:DetailViewController = DetailViewController(searchResult: search)
        completion(secondViewController)
    }
}

// MARK: DetailViewModel
/*
 view model for DetailViewController
 */

struct DetailViewModel{
    var gif: Obsevbel<GifViewCellViewModel> = Obsevbel(nil)
    
    // MARK: Property Dependency injestion
    var appiCall: ApiProvider? = GifAPIClient()
    
    /*init(appiCall: ApiProvider = GifAPIClient()){
        self.appiCall = appiCall
    }*/
    
    func searchGifId(gifID: String){
        appiCall?.getRequest(urlParams: [:], gifAcces: gifID, decodable: APGifResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = GifViewCellViewModel(id: linkdata.data.id, title: linkdata.data.title, rating: linkdata.data.rating, Image: linkdata.data.images?.fixed_height?.url, video: linkdata.data.images?.fixed_height?.mp4, url: linkdata.data.url)
                self.gif.value = d
            }
        })
    }
}

