//
//  CategoryCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 02.05.2022.
//

import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    
    
    static let reuseID = "CategoryCell"
    
    private let vm = CategoryViewModel()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private let categorySectionTitle: UILabel = {
        let sectionTitle = UILabel()
        sectionTitle.text = "Browse by Category"
        sectionTitle.textColor = .black
        sectionTitle.font = UIFont.boldSystemFont(ofSize: 20)
        return sectionTitle
    }()
    
    private let discoverSectionTitle: UILabel = {
        let discoverSectionTitle = UILabel()
        discoverSectionTitle.text = "Discover"
        discoverSectionTitle.font = UIFont.boldSystemFont(ofSize: 20)
        return discoverSectionTitle
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCategoryTitle()
        layoutUI()
        setUpDiscoveryTitle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - UI Elements
    
    private func layoutUI(){
        
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categorySectionTitle.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
    }
    private func setUpCategoryTitle(){
        addSubview(categorySectionTitle)
        categorySectionTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setUpDiscoveryTitle(){

        addSubview(discoverSectionTitle)
        discoverSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension CategoryCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(CategoryItemCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryItemCell
        cell.configure(category: vm.categories[indexPath.item])
        return cell
        

    }


}
// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100 , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }

}
