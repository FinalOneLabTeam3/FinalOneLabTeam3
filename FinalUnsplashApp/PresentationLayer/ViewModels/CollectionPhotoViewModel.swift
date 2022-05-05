//
//  CollectionsPhotoViewModel.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 05.05.2022.
//

import Foundation

class CollectionPhotoViewModel {
    private let networkDataFetch: NetworkDataFetch
    private let collection: UnsplashCollection
    private var photos = [UnsplashPhoto]()
    private var currentPage = 1
    private var isLoading = false
    
    var reloadCollectionView: (() -> Void)?
    
    init(networkDataFetch: NetworkDataFetch, collection: UnsplashCollection) {
        self.networkDataFetch = networkDataFetch
        self.collection = collection
    }
    
    func fetchCollectionPhotos() {
        if isLoading {
            return
        }
        isLoading = true
        self.networkDataFetch.fetchCollectionPhotos(collection: collection, page: currentPage) { [weak self] results in
            guard let fetchedPhotos = results else { return }
            self?.photos.append(contentsOf: fetchedPhotos)
            self?.currentPage += 1
            guard let reloadCollectionView = self?.reloadCollectionView else { return }
            reloadCollectionView()
            self?.isLoading = false
        }
    }
    
    func getPhotos() -> [UnsplashPhoto] {
        return photos
    }
    
    func getCollection() -> UnsplashCollection {
        return collection
    }
}
