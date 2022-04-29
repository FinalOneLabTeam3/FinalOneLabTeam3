//
//  User.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 29.04.2022.
//

import Foundation

struct User: Decodable{
    let total: Int
    let results: [UnsplashUser]
}

struct UnsplashUser: Decodable{
    let id: String
    let name: String
    let username: String
    let profile_image: [URLKIng.RawValue:String]
    
    enum URLKIng: String{
        case small
        case medium
        case large
    }
}
