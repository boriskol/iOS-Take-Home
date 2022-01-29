import UIKit

struct APIListResponse: Codable {
    var data: [GifObject]
}

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
