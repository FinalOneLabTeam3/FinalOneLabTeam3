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
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet{
//            let photoUrl = unsplashPhoto.urls["thumb"]
            let photoUrl = unsplashPhoto.urls["small"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl)
            else { return }
            imageView.sd_setImage(with: url, completed: nil)
            authorLabel.text = unsplashPhoto.user.name
        }
    }
    var cornerRadius: CGFloat = 10
    
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
        addSubview(authorLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.layer.cornerRadius = cornerRadius
        
        authorLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView).offset(10)
            $0.bottom.equalTo(imageView).inset(10)
            $0.trailing.equalTo(imageView).inset(10)
        }
    }
    
//    func configureCell(data: UnsplashPhoto) {
//        let photoUrl = unsplashPhoto.urls["thumb"]
//        guard let imageUrl = photoUrl, let url = URL(string: imageUrl)
//        else { return }
//        imageView.sd_setImage(with: url, completed: nil)
//    }
    
    func clearAuthorLabel() {
        authorLabel.text = ""
    }
    
    
}
