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
    let title: String
    
    let cover_photo: CoverPhoto?
}

struct CoverPhoto: Decodable {
    let width: Int
    let height: Int
    let description: String?
    let urls: [URLKind.RawValue:String]
    
    enum URLKind: String{
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
