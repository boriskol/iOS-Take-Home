import UIKit
import AVKit
import AVFoundation

// MARK: DetailViewController
 /*
  initiate with SearchResult gif
  
  */

class DetailViewController: UIViewController {
    
    private var viewModel = DetailViewModel()
    private var searchResult: SearchResult?
    private var player: AVPlayer!
    private var playerViewController: AVPlayerViewController!
    
    /*private lazy var stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            stackView.alignment = .leading
            stackView.spacing = 16.0
            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
    }()*/
    lazy var gifViewImage: UIImageView = {
            let img = UIImageView()
            img.tintColor = .clear
            img.contentMode = .scaleToFill
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
    }()
    private lazy var gifTitle: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .darkGray
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            return label
    }()
    private lazy var navTitle: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .darkGray
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            return label
    }()
    private lazy var gifSource: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .darkGray
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            return label
    }()
    private lazy var gifRating: UILabel = {
            let label = UILabel()
            label.backgroundColor = .clear
            label.textColor = .darkGray
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            return label
    }()
    
    init(searchResult: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        self.searchResult = searchResult
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = navTitle
        // view model search gif by id
        viewModel.searchGifId(gifID: self.searchResult?.id)
        
        view = UIView()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.window?.overrideUserInterfaceStyle = .dark
            view.backgroundColor = .systemBackground
        } else {
            view.window?.overrideUserInterfaceStyle = .light
            view.backgroundColor = .systemBackground
        }
        
        view.addSubview(gifViewImage)
        view.addSubview(gifTitle)
        view.addSubview(gifSource)
        view.addSubview(gifRating)
       
        NSLayoutConstraint.activate([
            
            gifViewImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 98),
            gifViewImage.bottomAnchor.constraint(equalTo: gifTitle.topAnchor, constant: 0),
            gifViewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            gifViewImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            gifViewImage.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75, constant: 0),
            
            gifTitle.topAnchor.constraint(equalTo: gifViewImage.bottomAnchor, constant: 0),
            //gifTitle.bottomAnchor.constraint(equalTo: gifSource.topAnchor, constant: 0),
            gifTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            gifTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            gifSource.topAnchor.constraint(equalTo: gifTitle.bottomAnchor, constant: 0),
            //gifSource.bottomAnchor.constraint(equalTo: gifRating.topAnchor, constant: -16),
            gifSource.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            gifSource.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            gifRating.topAnchor.constraint(equalTo: gifSource.bottomAnchor, constant: 0),
            //gifRating.bottomAnchor.constraint(equalTo: gifSource.bottomAnchor, constant: -16),
            gifRating.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            gifRating.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

        ])
         
    }
    
    override func loadView() {
        // view model bind change on velue
        
        viewModel.gif.bind { [weak self] gif in
            
            guard let gif = gif else {return}
            if let title = gif.data.title{
                self?.gifTitle.text = "Title: \(String(describing: title))"
            }
            
            self?.navTitle.text = gif.data.title
            if let url = gif.data.url{
                self?.gifSource.text = "Source: \(String(describing: url))"
            }
            if let rating = gif.data.rating{
                self?.gifRating.text = "Rating: \(String(describing: rating))"
            }
            if let image = gif.data.images?.fixed_height?.url{
                self?.gifViewImage.downloaded(from: image)
            }
            if let mp3 = gif.data.images?.fixed_height?.mp4 {
                self?.player = AVPlayer(url: mp3)
                self?.playerViewController = AVPlayerViewController()
                self?.playerViewController.player = self?.player
                self?.playerViewController.view.frame = CGRect(x:Constants.screenSize.width/3.5, y: Constants.screenSize.height*0.70, width: Constants.screenSize.width/2.5, height: Constants.screenSize.width/2.5)
    
                self?.view.addSubview((self?.playerViewController.view)!)
                self?.playerViewController.player?.play()
                }
        }
        
    }
    
    deinit{
        debugPrint("deinit DetailViewController")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
