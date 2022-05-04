//
//  DiscoverCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 02.05.2022.
//

import UIKit

class DiscoverCell: UICollectionViewCell {
    
    let vm = DiscoverViewModel(dataFetch: NetworkDataFetch.shared)
    
    static let reuseID = "DiscoverCell"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vm.fetchPhotos()
        self.collectionView.reloadData()
        layoutUI()
        bindViewModel()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    private func layoutUI(){
        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
    
    private func bindViewModel(){
        vm.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}
// MARK: - UICollectionViewDataSource
extension DiscoverCell: UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return vm.listPhotos.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
       
        let unsplashPhotos = vm.listPhotos[indexPath.item]
        cell.unsplashPhoto = unsplashPhotos
        return cell
    }
    
}

// MARK: - CustomLayoutDelegate
extension DiscoverCell: CustomLayoutDelegate{

    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
    
        let photo = vm.listPhotos[indexPath.item]
            return  CGSize(width: photo.width, height: photo.height)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}


