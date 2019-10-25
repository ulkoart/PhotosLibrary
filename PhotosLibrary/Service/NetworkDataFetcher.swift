//
//  NetworkDataFetcher.swift
//  PhotosLibrary
//
//  Created by Артем Улько on 10/10/2019.
//  Copyright © 2019 Артем Улько. All rights reserved.
//

import Foundation

class NetworkDataFetcher {
    
    var networkService = NetworkService()
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print ("Error \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decored = JSONDecoder()
        guard let data = from else {
            return nil
        }
        
        do {
            let objects = try decored.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print ("Faild to decode JSON", jsonError)
            return nil
        }
    }
}
