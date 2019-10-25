//
//  SearchResults.swift
//  PhotosLibrary
//
//  Created by Артем Улько on 10/10/2019.
//  Copyright © 2019 Артем Улько. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable  {
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue: String ]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
