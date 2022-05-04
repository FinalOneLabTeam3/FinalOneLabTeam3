//
//  DiscoverCell.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 02.05.2022.
//

import UIKit

class DiscoverCell: UICollectionViewCell {
    
    let dataFetch = NetworkDataFetch()
    
    private var timer: Timer?
    
    static let reuseID = "DiscoverCell"
    
    var listPhotos = [UnsplashPhoto]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
            self.dataFetch.fetchImages(searchTerm: "random", path: PhotosCell.path) { [weak self] (results) in
                guard let fetchedPhotos = results else { return }
                self?.listPhotos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
        
        print("list photos count = \(listPhotos.count)")
        layoutUI()
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

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
}

extension DiscoverCell: UICollectionViewDelegate {

}
extension DiscoverCell: UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPhotos.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
        let unsplashPhotos = listPhotos[indexPath.item]
        cell.unsplashPhoto = unsplashPhotos
        return cell
    }
    
}


extension DiscoverCell: CustomLayoutDelegate{

    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
            let photo = listPhotos[indexPath.item]
            return  CGSize(width: photo.width, height: photo.height)
    }
}

extension DiscoverCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}


