//
//  NetworkManager.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 29.06.2021.
//

import Foundation

let apiKey = ""

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=\(apiKey)")
    let searchUrl = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=\(apiKey)&q="
    
    private init() {}
    
    public func getStories(completion: @escaping (Result<[APIArticles], Error>) -> ()) {
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func getStoriesSeqrch(with query: String, completion: @escaping (Result<[APIArticles], Error>) -> ()) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty  else {
            return
        }
        let urlString = searchUrl + query
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct APIResponse: Codable {
    let articles: [APIArticles]
}

struct APIArticles: Codable {
    let author: String?
    let title: String
    let publishedAt: String
    let description: String?
    let urlToImage: String?
}
