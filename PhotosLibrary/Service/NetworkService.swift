//
//  NetworkService.swift
//  PhotosLibrary
//
//  Created by Артем Улько on 10/10/2019.
//  Copyright © 2019 Артем Улько. All rights reserved.
//

import Foundation

class NetworkService {
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let paraments = self.prepareParaments(searchTerm: searchTerm)
        let url = self.url(params: paraments)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String:String]? {
        var headers = [String:String]()
        headers["Authorization"] = "Client-ID 64b22fd97bec2dc6e7071abbe841781486a5f9c024bf3a95a63c73d6be0a0ecd"
        return headers
        
    }
    
    private func prepareParaments(searchTerm: String?) -> [String:String] {
        var parametrs = [String:String]()
        parametrs["query"] = searchTerm
        parametrs["page"] = String(1)
        parametrs["per_page"] = String(30)
        return parametrs
    }
    
    private func url(params: [String:String ]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!
        
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
}
