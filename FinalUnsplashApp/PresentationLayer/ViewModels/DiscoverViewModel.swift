//
//  DiscoverViewModel.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 04.05.2022.
//

import Foundation

class DiscoverViewModel {
    
    let dataFetch: NetworkDataFetch
    
    private var timer: Timer?
    
    var listPhotos = [UnsplashPhoto](){
        didSet {
            guard let reloadCollectionView = reloadCollectionView else { return }
            reloadCollectionView()
        }
    }
    
    init(dataFetch: NetworkDataFetch){
        self.dataFetch = dataFetch
    }
    var reloadCollectionView: (() -> Void)?
    func fetchPhotos() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
            self.dataFetch.fetchImages(searchTerm: "random", path: PhotosCell.path) { [weak self] (results) in
                guard let fetchedPhotos = results else { return }
                self?.listPhotos = fetchedPhotos.results
//                self?.collectionView.reloadData()
            }
        })
    }
}
