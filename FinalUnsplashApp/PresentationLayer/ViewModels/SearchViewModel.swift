//
//  SearchViewModel.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 04.05.2022.
//

import Foundation

class SearchViewModel {
    
    private var timer: Timer?
    var networkDataFetch: NetworkDataFetch
    var photos = [UnsplashPhoto]() {
        didSet {
            guard let reloadCollectionView = reloadCollectionView else { print("no"); return }
            reloadCollectionView()
        }
    }
    var collections = [UnsplashCollection]() {
        didSet {
            guard let reloadCollectionView = reloadCollectionView else { return }
            reloadCollectionView()
        }
    }
    
    var users = [UnsplashUser]() {
        didSet {
            guard let updateUsersTableView = updateUsersTableView else { return }
            updateUsersTableView(users)
        }
    }
    
    var reloadCollectionView: (() -> Void)?
    var updateUsersTableView: (([UnsplashUser]) -> Void)?
    
    init(networkDataFetch: NetworkDataFetch){
        self.networkDataFetch = networkDataFetch
    }
    
   func fetchData(searchText: String){ 
       
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
            self.networkDataFetch.fetchImages(searchTerm: searchText, path: PhotosCell.path) { [weak self] (results) in
                guard let fetchedPhotos = results else { return }
                self?.photos = fetchedPhotos.results

            }
            self.networkDataFetch.fetchCollections(searchTerm: searchText, path: CollectionCell.path) { [weak self] (results) in
                guard let fetchedCollections = results else { return }
                self?.collections = fetchedCollections.results

            }
            self.networkDataFetch.fetchUsers(searchTerm: searchText, path: UserCell.path) { [weak self] (results) in
                guard let fetchedUsers = results else { return }
                self?.users = fetchedUsers.results
            }
        })
    }
    
                                     


    
    func getPhotos() -> [UnsplashPhoto] {
        return photos
    }
    
    func getCollections() -> [UnsplashCollection] {
        return collections
    }
    
    func getUsers() -> [UnsplashUser] {
        return users
    }
    
    
}
