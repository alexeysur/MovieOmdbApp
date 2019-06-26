//
//  NetworkingService.swift
//  MovieOMDbApp
//
//  Created by Alexey on 6/23/19.
//  Copyright © 2019 Alexey. All rights reserved.
//

import Foundation


enum MIMETypes: String {
    case urlencoded = "application/x-www-form-urlencoded"
    case json = "application/json"
}

enum RequestType: String {
    case post = "post"
    case get = "get"
}

class NetworkService {
    private struct authParameters {
        struct Keys {
            static let accept = "Accept"
            static let apiKey = "apikey"
        }
        
        static let apiKey = "8cf5b0c5"
    }
    
    
    private let cache = NSCache<NSString, NSData>()
    private let urlSessionConfig = URLSessionConfiguration.default
    private func configSession(){
        self.urlSessionConfig.httpAdditionalHeaders = [
            AnyHashable(authParameters.Keys.accept): MIMETypes.json.rawValue
        ]
    }
    
    private static var sharedInstance: NetworkService = {
        return NetworkService()
    }()
    
 
    class func shared() -> NetworkService {
        sharedInstance.configSession()
        return sharedInstance
    }
    
  
    private func createAuthParameters(with parameters:[String:String]) -> Data? {
        guard parameters.count > 0 else {return nil}
        return  parameters.map {"\($0.key)=\($0.value)"}.joined(separator: "&").data(using: .utf8)
    }
    
    
    private func request(url:String,
                         cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData,
                         httpMethod: RequestType,
                         headers:[String:String]?,
                         body: [String:String]?,
                         parameters: [URLQueryItem]?,
                         useSharedSession: Bool = false,
                         handler: @escaping (Data?, URLResponse?, Int?, Error?) -> Void){
        
        if var urlComponent = URLComponents(string: url) {
            urlComponent.queryItems = parameters
            var session = URLSession(configuration: urlSessionConfig)
            if useSharedSession {
                session = URLSession.shared
            }
            
            if let _url = urlComponent.url {
                
                var request = URLRequest(url: _url)
                request.cachePolicy = cachePolicy
                request.allHTTPHeaderFields = headers
                
                if let _body = body {
                    request.httpBody = createAuthParameters(with: _body)
                }
                request.httpMethod = httpMethod.rawValue
                
                session.dataTask(with: request) { (data, response, error) in
                    let httpResponsStatusCode = (response as? HTTPURLResponse)?.statusCode
                    handler(data, response, httpResponsStatusCode, error)
                    }.resume()
            }else{
                handler(nil, nil, nil, Failure.invalidURL)
            }
        }else{
            handler(nil, nil, nil, Failure.invalidURL)
        }
    }
    
    
}

extension NetworkService {
    
    func search(for name: String, page: Int = 1, handler: @escaping(JSON.Search?, Error?) -> Void){
        var queries = [URLQueryItem]()
        queries.append(URLQueryItem(name: "s", value: name))
        queries.append(URLQueryItem(name: "page", value: String(page)))
        queries.append(URLQueryItem(name: "r", value: "json"))
        queries.append(URLQueryItem(name: authParameters.Keys.apiKey, value: authParameters.apiKey))
        
        request(url: EndPoints.Search.path, httpMethod: .get, headers: nil, body: nil, parameters: queries){
            (data, response, status, error)  in
            if let _data = data, status == 200 {
                print(_data)
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(JSON.Search.self, from: _data)
                    handler(result, nil)
                } catch let error {
                    handler(nil, error)
                }
            }else{
                handler(nil, Failure.invalidStatusCode(status))
            }
        }
    }
    
    func getMovie(with imdbID: String, handler: @escaping(JSON.Movie?, Error?) -> Void){
        var queries = [URLQueryItem]()
        queries.append(URLQueryItem(name: "i", value: imdbID))
        queries.append(URLQueryItem(name: "r", value: "json"))
        queries.append(URLQueryItem(name: authParameters.Keys.apiKey, value: authParameters.apiKey))
        
        request(url: EndPoints.Search.path, httpMethod: .get, headers: nil, body: nil, parameters: queries){
            (data, response, status, error)  in
            if let _data = data, status == 200 {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(JSON.Movie.self, from: _data)
                    handler(result, nil)
                } catch let error {
                    handler(nil, error)
                }
            }else{
                handler(nil, Failure.invalidStatusCode(status))
            }
        }
    }
    
    func getImage(url: String, handler: @escaping(Data?, Error?) -> Void){
        let cacheID = NSString(string: url)
        
        if let cachedData = cache.object(forKey: cacheID) {
            handler((cachedData as Data), nil)
        }else{
            if let url = URL(string: url) {
                let session = URLSession(configuration: urlSessionConfig)
                var request = URLRequest(url: url)
                request.cachePolicy = .returnCacheDataElseLoad
                request.httpMethod = RequestType.get.rawValue
                session.dataTask(with: request) { (data, response, error) in
                    if let _data = data {
                        self.cache.setObject(_data as NSData, forKey: cacheID)
                        handler(_data, nil)
                    }else{
                        handler(nil, error)
                    }
                    }.resume()
            } else {
                handler(nil, Failure.invalidURL)
            }
        }
        
    }
}

