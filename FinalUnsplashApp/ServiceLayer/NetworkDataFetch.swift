//
//  NetworkDataFetch.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import Foundation

class NetworkDataFetch{
    
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
    
//    func fetchUser(username: String, completion: @escaping (UnsplashUser?) -> ()){
//        networkService.request(username: username, path: "/users/\(username)") { (data, error) in
//            if let error = error {
//                print("Error received requesting data: \(error.localizedDescription)")
//                completion(nil)
//            }
//
//            let decode = self.decodeJSON(type: UnsplashUser.self, from: data)
//            print("fetched user")
//            completion(decode)
//        }
//    }
    
    func fetchUserPhotos(username: String, page: Int, completion: @escaping ([UnsplashPhoto]?) -> ()){
        networkService.request(username: username, path: "/users/\(username)/photos", page: page) { (data, error) in
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
        networkService.request(username: username, path: "/users/\(username)/likes", page: page) { (data, error) in
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
        networkService.request(username: username, path: "/users/\(username)/collections", page: page) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashCollection].self, from: data)
            print("fetched collections")
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
