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
//        imageView.backgroundColor = .systemGray5
        imageView.layer.opacity = 0.8
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.sizeToFit()
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
//            make.trailing.leading.equalToSuperview()
//            make.width.height.equalToSuperview()
//            make.width.height.equalTo(contentView.frame.height / 2)
        }
        
        imageView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        
    }
    
    func configure(category: Category){
        imageView.image = UIImage(named: category.imageName)
        categoryLabel.text = category.categoryLabel
    }
    
    private func layoutUI(){
    
//        backgroundColor = .blue
        
    }
    
}
