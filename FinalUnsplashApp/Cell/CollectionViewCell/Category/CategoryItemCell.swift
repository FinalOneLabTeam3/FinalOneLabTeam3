//
//  CategoryItemCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 02.05.2022.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {
    
    static let reuseId = "CategoryItemCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.opacity = 0.8
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(category: Category){
        imageView.image = UIImage(named: category.imageName)
        categoryLabel.text = category.categoryLabel
    }
    
    private func layoutUI(){
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
