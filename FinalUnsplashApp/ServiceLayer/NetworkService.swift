//
//  NetworkService.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import Foundation

class NetworkService {
    
    func request(searchTerm: String, path: String, completion: @escaping (Data?, Error?) -> Void){
        let parameters = self.prepareParams(searchTerm: searchTerm)
        let url = url(params: parameters, path: path)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func request(username: String, path: String, page: Int, completion: @escaping (Data?, Error?) -> Void){
        let parameters = self.prepareParams(page: page)
        let url = url(params: parameters, path: path)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    
    private func prepareHeaders() -> [String : String]{
        var headers = [String : String]()
        headers["Authorization"] = "Client-ID foh_BZuGSZyMk3j5duL5Kt8zNQs2tmMFgCsw5y-b5Ms"
        return headers
    }
    private func prepareParams(searchTerm: String) -> [String : String] {
        var params = [String : String]()
        params["query"] = searchTerm
        params["page"] = String(1)
        params["per_page"] = String(30)
        return params
    }
    private func prepareParams(page: Int) -> [String : String] {
        var params = [String : String]()
        params["page"] = String(page)
        return params
    }
    
    private func url(params: [String : String], path: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = path
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask{
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
            
        }
        
    }
}