//
//  NetworkDataFetch.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import Foundation

class NetworkDateFetch{
    
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

