//
//  UserDetailViewModel.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 30.04.2022.
//

import Foundation

class UserDetailViewModel {
    private let networkDataFetch: NetworkDataFetch
    private let user: UnsplashUser
    private var photos = [UnsplashPhoto]() {
        didSet {
            guard let reloadCollectionView = reloadCollectionView else { return }
            reloadCollectionView()
        }
    }
    private var likedPhotos = [UnsplashPhoto]() {
        didSet {
            guard let reloadCollectionView = reloadCollectionView else { return }
            reloadCollectionView()
        }
    }
    private var collections = [UnsplashCollection]() {
        didSet {
            guard let reloadCollectionView = reloadCollectionView else { return }
            reloadCollectionView()
        }
    }
    
    var didLoadUserInfo: ((UnsplashUser) -> Void)?
    var reloadCollectionView: (() -> Void)?
    
    init(networkDataFetch: NetworkDataFetch, user: UnsplashUser) {
        self.networkDataFetch = networkDataFetch
        self.user = user
    }
    
    func fetchUserInfo() {
        self.networkDataFetch.fetchUser(username: user.username) { [weak self] (result) in
            guard let fetchedUser = result else { return }
            self?.didLoadUserInfo?(fetchedUser)
        }
    }
    
    func fetchUserPhotos() {
        self.networkDataFetch.fetchUserPhotos(username: user.username) { [weak self] (results) in
            guard let fetchedPhotos = results else { return }
            self?.photos = fetchedPhotos
        }
    }
    
    func fetchLikedPhotos() {
        self.networkDataFetch.fetchUserLikedPhotos(username: user.username) { [weak self] (results) in
            guard let fetchedPhotos = results else { return }
            self?.likedPhotos = fetchedPhotos
        }
    }
    
    func fetchCollections() {
        self.networkDataFetch.fetchUserCollections(username: user.username) { [weak self] (results) in
            guard let fetchedCollections = results else { return }
            self?.collections = fetchedCollections
        }
    }
    
    func getUserPhotos() -> [UnsplashPhoto] {
        return photos
    }
    
    func getLikedPhotos() -> [UnsplashPhoto] {
        return likedPhotos
    }
    
    func getCollections() -> [UnsplashCollection] {
        return collections
    }
    
    func getUser() -> UnsplashUser {
        return user
    }
    
}
