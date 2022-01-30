//
//  UICollectionView.swift
//  Dispo Take Home
//
//  Created by Borna Libertines on 21/01/22.
//

import UIKit

class MyCell: UICollectionViewCell {
    
    // MARK: Cell
   
    var data: GifCollectionViewCellViewModel? {
            didSet {
                guard let t = data?.title, let r = data?.rating, let img = data?.Image  else { return }
                    textLabel.text = "Title: \(t)"
                    raitingLabel.text = "Rating: \(r)"
                    gifViewImage.downloaded(link: img)
            }
    }
    private lazy var stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .leading
            stackView.spacing = 16.0
            //stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
    }()
    lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
            label.backgroundColor = .clear
            label.textColor = .darkGray
            label.textAlignment = .left
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.callout)
        //label.font = UIFont.boldSystemFont(ofSize: 18)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            label.textAlignment = .justified
            return label
    }()
    lazy var raitingLabel: UILabel = {
        let label = UILabel(frame: .zero)
            label.backgroundColor = .clear
            label.textColor = .darkGray
            label.textAlignment = .left
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = ""
            label.numberOfLines = 0
            label.textAlignment = .justified
            return label
    }()
    lazy var gifViewImage: UIImageView = {
            let img = UIImageView()
            img.tintColor = .clear
            img.translatesAutoresizingMaskIntoConstraints = false
            return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(stackView)
        
        self.stackView.addSubview(gifViewImage)
        self.stackView.addSubview(textLabel)
        self.stackView.addSubview(raitingLabel)
        
        self.contentView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            
            
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            
            
            gifViewImage.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 8),
            gifViewImage.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 8),
            gifViewImage.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 8),
            gifViewImage.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/3),
        
            
            textLabel.leadingAnchor.constraint(equalTo: self.gifViewImage.trailingAnchor, constant: 8),
            textLabel.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor, constant: 0),
            textLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 0),
            //textLabel.bottomAnchor.constraint(equalTo: self.raitingLabel.topAnchor, constant: 0),
            
            
            raitingLabel.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor, constant: 8),
            raitingLabel.leadingAnchor.constraint(equalTo: self.textLabel.leadingAnchor, constant: 0),
            //raitingLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            //raitingLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
            
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        fatalError("Interface Builder is not supported!")
    }

    

    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
        self.raitingLabel.text = nil
        self.gifViewImage.image = nil
    }
    
    deinit{
        debugPrint("deinit GifApiClientCall")
    }
}
//MARK: UIImageView
/*
 download image for UIImageView
 */

let imageCache = NSCache<NSURL, UIImage>()
extension UIImageView {
    
    func downloaded(urlString: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: urlString) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                imageCache.setObject(image, forKey: urlString as NSURL)
                self?.image = image
            }
        }.resume()
    }
    func downloaded(link: URL, contentMode mode: ContentMode = .scaleToFill) {
        if let cachedImage = imageCache.object(forKey: link as NSURL)  {
            debugPrint("loading fromm catch")
            self.image = cachedImage
            return
        }
        downloaded(urlString: link, contentMode: mode)
    }
}


