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
    private var userPhotosPage = 1
    private var likedPhotosPage = 1
    private var collectionsPage = 1
    private var isUserPhotosLoading = false
    private var isLikedPhotosLoading = false
    private var isCollectionsLoading = false
    
    var didLoadUserInfo: ((UnsplashUser) -> Void)?
    var reloadCollectionView: (() -> Void)?
    
    init(networkDataFetch: NetworkDataFetch, user: UnsplashUser) {
        self.networkDataFetch = networkDataFetch
        self.user = user
    }
    
//    func fetchUserInfo() {
//        self.networkDataFetch.fetchUser(username: user.username) { [weak self] (result) in
//            guard let fetchedUser = result else { return }
//            self?.didLoadUserInfo?(fetchedUser)
//        }
//    }
    
    func fetchUserPhotos() {
        if isUserPhotosLoading {
            return
        }
        isUserPhotosLoading = true
        self.networkDataFetch.fetchUserPhotos(username: user.username, page: userPhotosPage) { [weak self] (results) in
            guard let fetchedPhotos = results else { return }
            self?.photos.append(contentsOf: fetchedPhotos)
            self?.userPhotosPage += 1
            self?.isUserPhotosLoading = false
        }
    }
    
    func fetchLikedPhotos() {
        if isLikedPhotosLoading {
            return
        }
        isLikedPhotosLoading = true
        self.networkDataFetch.fetchUserLikedPhotos(username: user.username, page: likedPhotosPage) { [weak self] (results) in
            guard let fetchedPhotos = results else { return }
            self?.likedPhotos.append(contentsOf: fetchedPhotos)
            self?.likedPhotosPage += 1
            self?.isLikedPhotosLoading = false
        }
    }
    
    func fetchCollections() {
        if isCollectionsLoading {
            return
        }
        isCollectionsLoading = true
        self.networkDataFetch.fetchUserCollections(username: user.username, page: collectionsPage) { [weak self] (results) in
            guard let fetchedCollections = results else { return }
            self?.collections.append(contentsOf: fetchedCollections)
            self?.collectionsPage += 1
            self?.isCollectionsLoading = false
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
