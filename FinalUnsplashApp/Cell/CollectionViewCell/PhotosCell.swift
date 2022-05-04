//
//  PhotosCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import UIKit
import SDWebImage
import SnapKit

class PhotosCell: UICollectionViewCell {
    
    static let reuseID = "PhotoCell"
    
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
    
    func clearAuthorLabel() {
        authorLabel.text = ""
    }
}

