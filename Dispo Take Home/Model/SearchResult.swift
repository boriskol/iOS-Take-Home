import UIKit

// MARK: SearchResult Model
///model from api
struct SearchResult: Codable {
  var id: String?
  var gifUrl: URL?
  var title: String?
    enum CodingKeys: String, CodingKey {
        case id
        case gifUrl = "url"
        case title
    }
}
