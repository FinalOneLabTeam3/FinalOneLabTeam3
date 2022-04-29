//
//  ServiceCollection.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 27.04.2022.
//

import Foundation

struct Collection: Decodable{
    let total: Int
    let results: [UnsplashCollection]
}

struct UnsplashCollection: Decodable{
//    let width: [CoverPhoto.RawValue: String]
//    let height: [CoverPhoto.RawValue: String]
    let urls: [URLKIng.RawValue:String]
    let cover_photo: CoverPhoto
    enum URLKIng: String{
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct CoverPhoto: Decodable {
    let width: Int
    let height: Int
    let description: String
}
