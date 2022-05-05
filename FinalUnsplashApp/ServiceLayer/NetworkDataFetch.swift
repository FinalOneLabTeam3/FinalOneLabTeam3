//
//  NetworkDataFetch.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import Foundation

class NetworkDataFetch{
    
    static let shared = NetworkDataFetch()
    
    let networkService = NetworkService()
    
    func fetchImages(searchTerm: String, path: String, completion: @escaping (Photo?) -> ()){
        networkService.request(searchTerm: searchTerm, path: path) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: Photo.self, from: data)
            completion(decode)
        }
    }
    
    func fetchCollections(searchTerm: String, path: String, completion: @escaping (Collection?) -> ()){
        networkService.request(searchTerm: searchTerm, path: path) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: Collection.self, from: data)
            print("fetched collection")
            completion(decode)
        }
    }
    
    func fetchUsers(searchTerm: String, path: String, completion: @escaping (User?) -> ()){
        networkService.request(searchTerm: searchTerm, path: path) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: User.self, from: data)
            print("fetched users")
            completion(decode)
        }
    }
    
    
    func fetchUserPhotos(username: String, page: Int, completion: @escaping ([UnsplashPhoto]?) -> ()){
        networkService.request(path: "/users/\(username)/photos", page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            print("fetched photos")
            completion(decode)
        }
    }
    
    func fetchUserLikedPhotos(username: String, page: Int, completion: @escaping ([UnsplashPhoto]?) -> ()){
        networkService.request(path: "/users/\(username)/likes", page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            print("fetched liked photos")
            completion(decode)
        }
    }
    
    func fetchUserCollections(username: String, page: Int, completion: @escaping ([UnsplashCollection]?) -> ()){
        networkService.request(path: "/users/\(username)/collections", page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashCollection].self, from: data)
            print("fetched collections")
            completion(decode)
        }
    }
    
    func fetchTopics(completion: @escaping ([Topic]?) -> ()){
        networkService.request(path: "/topics") { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: [Topic].self, from: data)
            print("fetched topics")
            completion(decode)
        }
    }
    
    func fetchTopicPhotos(topic: Topic, page: Int, completion: @escaping ([UnsplashPhoto]?) -> ()){
        networkService.request(path: "/topics/\(topic.slug)/photos", page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            print("fetched photos")
            completion(decode)
        }
    }
    
    func fetchCollectionPhotos(collection: UnsplashCollection, page: Int, completion: @escaping ([UnsplashPhoto]?) -> ()){
        networkService.request(path: "/collections/\(collection.id)/photos", page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPhoto].self, from: data)
            print("fetched photos")
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else {return nil}
        do {
            let objects = try decoder.decode(type.self, from: data)
            print("decoded JSON ")
            return objects
        } catch let jsonError{
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
