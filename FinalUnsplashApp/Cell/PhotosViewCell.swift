//
//  PhotosViewCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import UIKit
import SDWebImage
import SnapKit

//typealias PhotosCellConfigurator = CollectionCellConfigurator<PhotosViewCell, UnsplashPhoto>

class PhotosViewCell: UICollectionViewCell {
    
    
    
//    typealias DataType = UnsplashPhoto
    
    static let reuseID = "PhotosCell"
    
    static let path = "/search/photos"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet{
            let photoUrl = unsplashPhoto.urls["thumb"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl)
            else { return }
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
   
    
//    override init(style: UICollectionViewCell, reuseIdentifier: String?) {
//            super.init(style: style, reuseIdentifier: reuseIdentifier)
////            layoutUI()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        addSubview(imageView)
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        imageView.layer.cornerRadius = 10
    }
    
//    func configureCell(data: UnsplashPhoto) {
//        let photoUrl = unsplashPhoto.urls["thumb"]
//        guard let imageUrl = photoUrl, let url = URL(string: imageUrl)
//        else { return }
//        imageView.sd_setImage(with: url, completed: nil)
//    }
    
    
    
    
}
