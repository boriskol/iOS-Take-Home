//
//  GifCollectionViewCellViewModel.swift
//  Dispo Take Home
//
//  Created by Borna Libertines on 21/01/22.
//

import Foundation
// MARK: GifCollectionViewCellViewModel Model
struct GifCollectionViewCellViewModel {
    let id: String?
    let title: String?
    let rating: String?
    let Image: URL?
    let url: URL?
}
// MARK: GifViewCellViewModel Model
struct GifViewCellViewModel {
    let id: String?
    let title: String?
    let rating: String?
    let Image: URL?
    let video: URL?
    let url: URL?
}

/*
 struct GifObject: Codable {
     var id: String?
     var title: String?
     var source_tld: String?
     var rating: String?
     /// Giphy URL (not gif url to be displayed)
     var url: URL?
     var images: Images?
     
     struct Images: Codable {
         var fixed_height: Image?
         struct Image: Codable {
             var url: URL?
             var width: String?
             var height: String?
             var mp4: URL?
         }
     }
 }
 */

