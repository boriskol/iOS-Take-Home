import UIKit

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
