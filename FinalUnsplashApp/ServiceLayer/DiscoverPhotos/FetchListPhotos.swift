//
//  FetchListPhotos.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 02.05.2022.
//

import Foundation

class FetchListPhotos {
    
    let listPhotosService = ListPhotosService()
    
    func fetchListPhotos(completion: @escaping (Photo?) -> ()){
        listPhotosService.request { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: Photo.self, from: data)
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
