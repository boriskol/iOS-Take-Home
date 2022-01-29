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
extension MainViewController{
    struct MainViewModel{
        var gifs: Obsevbel<[GifCollectionViewCellViewModel]> = Obsevbel([])
        weak var appiCall = GifApiClientCall.shared

        func loadGift(){
            appiCall?.noquery { gifs in
                self.gifs.value = gifs
            }
        }
        func search(search: String?){
            appiCall?.search(search: search, completion: { gifs in
                self.gifs.value = gifs
            })
        }
        func searchGifId(gifID: String?){
            appiCall?.search(search: gifID, completion: { gifs in
                self.gifs.value = gifs
            })
        }
        func presentVCC(search: SearchResult, completion: @escaping (UIViewController) -> Void){
            let secondViewController:DetailViewController = DetailViewController(searchResult: search)
            completion(secondViewController)
        }
    }
}
// MARK: DetailViewModel
/*
  view model for DetailViewController
 */
extension DetailViewController{
    struct DetailViewModel{
        var gif: Obsevbel<APGifResponse> = Obsevbel(nil)
        weak var appiCall = GifApiClientCall.shared
        
        func searchGifId(gifID: String?){
            appiCall?.searchGifId(gifId: gifID, completion: { gif in
                self.gif.value = gif
            })
        }
    }
}
