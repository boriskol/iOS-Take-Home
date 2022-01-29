import UIKit

// MARK: Obsevbel
 /*
  Obsevbel is object which is capable of observing and biding
  When value have change to update UI
  The way how we hang on Obseverbel ViewModel
  */
class Obsevbel<T>{
    var value: T? {
        didSet{
            listener?(value)
        }
    }
    init(_ value: T?){
        self.value = value
    }
    private var listener: ((T?) -> Void)?
}
extension Obsevbel{
    func bind(_ listener: @escaping(T?) -> Void){
        self.listener = listener
    }
}


class MainViewController: UIViewController {
    
    // making instane of view model
    private var viewModel = GifListViewModel()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .red
        return spinner
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs..."
        searchBar.delegate = self
        searchBar.barTintColor = .systemBackground
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        //collectionView.keyboardDismissMode = .interactive
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        view = UIView()
        
        if self.traitCollection.userInterfaceStyle == .dark {
            view.window?.overrideUserInterfaceStyle = .dark
            collectionView.backgroundColor = .systemBackground
        } else {
            view.window?.overrideUserInterfaceStyle = .light
            collectionView.backgroundColor = .systemBackground
        }
        
        view.addSubview(collectionView)
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: collectionView.topAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // biding change on view model
        // we stop animation and reload collection view cells
        viewModel.gifs.bind { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self!.spinner.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func loadView() {
        spinner.startAnimating()
        viewModel.loadGift()
    }
    
    private func dismissKeyboard(){
       let keyWindow = UIApplication.shared.connectedScenes
           .filter({$0.activationState == .foregroundActive})
           .map({$0 as? UIWindowScene})
           .compactMap({$0})
           .first?.windows
           .filter({$0.isKeyWindow}).first
           keyWindow!.endEditing(true)
    }
    deinit{
        debugPrint("deinit MainViewC")
    }
    
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // MARK: search
        viewModel.search(search: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchT = searchBar.text{
            viewModel.searchGifId(gifID: searchT)
            self.collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath,at: .top,animated: true)
        }
    }
}


//MARK: CollectionView

extension MainViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.gifs.value?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.data = viewModel.gifs.value?[indexPath.row]
        return cell
    }
    
   
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let search = SearchResult(id: viewModel.gifs.value?[indexPath.row].obj.id, gifUrl: viewModel.gifs.value?[indexPath.row].obj.url, title: viewModel.gifs.value?[indexPath.row].obj.title)
        viewModel.presentVCC(search: search) { [weak self] uIViewController in
            self?.navigationController?.pushViewController(uIViewController, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width/3)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    /*func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }*/
    
}


//MARK: UIImageView
/*
 download image for UIImageView
 */

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    
}


class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    
    func delete(forKey: String) {
        cache.removeObject(forKey: forKey as NSString)
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}

