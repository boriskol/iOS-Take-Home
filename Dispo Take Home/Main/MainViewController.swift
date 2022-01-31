import UIKit

// MARK: Obsevbel
 /*
  Obsevbel is object which is capable of observing and biding
  When value have change to update UI
  The way how we hang on Obseverbel ViewModel
  */

/// obsevbel taking generic value T init(_ value: T?){self.value = value}
/// and hangs on single listener, bind obseverbel to single listnere
/// when value change in  didSet, we invoke that listener, let know bind listener that value have change
/// this is similar to SwiftUI Obseverbelobject
/// 
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
    private var viewModel = MainViewModel()
    private var viewModelDetail = DetailViewModel()
    
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
                //self?.collectionView.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath,at: .top,animated: true)
            }
        }
    }
    //viewmodel to ask for gifs
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
        debugPrint("deinit MainViewModel")
    }
    
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // MARK: search
        if searchText.isEmpty{
            viewModel.loadGift()
        }
        viewModel.search(search: searchText)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.loadGift()
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
        let search = SearchResult(id: viewModel.gifs.value?[indexPath.row].id, gifUrl: viewModel.gifs.value?[indexPath.row].url, title: viewModel.gifs.value?[indexPath.row].title)
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


