//
//  CollectionViewCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 27.04.2022.
//

//
//  CollectionViewCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 27.04.2022.
//
import UIKit
import SDWebImage
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "CollectionsCell"
    static let path = "/search/collections"
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    
    private func didAddTint(){
        let blackoutImage = UIView()
        blackoutImage.backgroundColor = UIColor(white: 0.5, alpha: 0.01)
        blackoutImage.frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        imageView.addSubview(blackoutImage)
    }
    
    private let collectionLabel: UILabel = {
        let collectionLabel = UILabel()
        collectionLabel.textColor = .white
        collectionLabel.sizeToFit()
//        collectionLabel.numberOfLines = 0
        return collectionLabel
    }()
    
    var unsplashCollection: UnsplashCollection! {
        didSet{
            let collectionUrl = unsplashCollection.cover_photo.urls["thumb"]
            guard let collectionUrl = collectionUrl, let url = URL(string: collectionUrl)
            else { return }
//            collectionLabel.text = unsplashPhoto.description
            imageView.sd_setImage(with: url, completed: nil)
            collectionLabel.text = unsplashCollection.cover_photo.description ?? ""
//            print(unsplashCollection.cover_photo.width)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        collectionLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        didAddTint()
        addSubview(imageView)
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.layer.cornerRadius = 10
        
        imageView.addSubview(collectionLabel)
        collectionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    

}
