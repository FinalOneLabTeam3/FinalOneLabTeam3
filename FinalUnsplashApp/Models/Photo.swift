//
//  Photo.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import Foundation

struct Photo: Decodable{
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable{
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue:String]

    
    enum URLKind: String{
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
