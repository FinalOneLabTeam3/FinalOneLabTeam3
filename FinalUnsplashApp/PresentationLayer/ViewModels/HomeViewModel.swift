//
//  HomeViewModel.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 02.05.2022.
//

import Foundation

class HomeViewModel {
    private let networkDataFetch: NetworkDataFetch
    private var topics: [Topic] = []
    private var topicPhotos: [String: [UnsplashPhoto]] = [:]
    private var topicPage: [String: Int] = [:]
    private var isLoading: [String: Bool] = [:]
    
    var reloadTopicsCollectionView: (() -> Void)?
    var reloadPhotosCollectionView: (() -> Void)?
    
    init(networkDataFetch: NetworkDataFetch) {
        self.networkDataFetch = networkDataFetch
    }
    
    func fetchTopics() {
        networkDataFetch.fetchTopics { [weak self] topics in
            guard let topics = topics else { return }
            self?.topics = topics
            // Fetch photo from first topic
            if !topics.isEmpty {
                self?.fetchPhoto(from: topics[0])
            }
            guard let reloadTopicsCollectionView = self?.reloadTopicsCollectionView else { return }
            reloadTopicsCollectionView()
        }
    }
    
    func fetchPhoto(from topic: Topic) {
        let currentPage = topicPage[topic.slug] ?? 1
        topicPage[topic.slug] = currentPage
        print(currentPage)
        let isLoadingPhotos = isLoading[topic.slug] ?? false
        if isLoadingPhotos {
            return
        }
        isLoading[topic.slug] = true
        networkDataFetch.fetchTopicPhotos(
            topic: topic,
            page: currentPage) { [weak self] photos in
                if self?.topicPhotos[topic.slug] == nil {
                    self?.topicPhotos[topic.slug] = photos
                } else {
                    guard let photos = photos else { return }
                    self?.topicPhotos[topic.slug]!.append(contentsOf: photos)
                }
                self?.topicPage[topic.slug]! += 1
                self?.isLoading[topic.slug] = false
                guard let reloadPhotosCollectionView = self?.reloadPhotosCollectionView else { return }
                reloadPhotosCollectionView()
            }
    }
    
    func getTopics() -> [Topic] {
        return topics
    }
    
    func getPhotos(topic: Topic) -> [UnsplashPhoto] {
        guard let topicPhotos = topicPhotos[topic.slug] else {
            return []
        }
        return topicPhotos
    }
}
