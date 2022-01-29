import UIKit


enum Constants {}
extension Constants {
    // MARK: Constants
    // Get an API key from https://developers.giphy.com/dashboard/
    static let giphyApiKey = "XbMKr0q0vnZMyi1ljDgUZML8U6oCbO1N"
    static let screenSize = UIScreen.main.bounds.size
    
    static let https = "https://api.giphy.com/v1/gifs/"
    static let trending = "trending"
    static let searchGif = "q"
    static let search = "search"
    static let limitNum = "25"
    static let limit = "limit"
    static let rating = "g"
    static let lang = "en"
}
