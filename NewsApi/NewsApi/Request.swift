//
//  Request.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 02.07.2021.
//

import UIKit

class Request: NSObject {
    
    static let shared = Request()
    
    public var viewModels = [NewsViewModel]()
    
    public func fetchApi(completion: @escaping () -> ()) {
        NetworkManager.shared.getStories { [weak self] result in
            switch result {
            case .success(let response):
                self?.viewModels = response.compactMap({
                    NewsViewModel(title: $0.title,
                                  subtitle: $0.description ?? "NO Description",
                                  author: $0.author,
                                  imageURL: URL(string: $0.urlToImage ?? ""), publishedAt: $0.publishedAt)
                })
                
                DispatchQueue.main.async {
                    completion()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func searchFetchApi(text: String, completion: @escaping () -> ()) {
            NetworkManager.shared.getStoriesSeqrch(with: text) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.viewModels = response.compactMap({
                        NewsViewModel(title: $0.title,
                                      subtitle: $0.description ?? "NO Description",
                                      author: $0.author,
                                      imageURL: URL(string: $0.urlToImage ?? ""), publishedAt: $0.publishedAt)
                    })
    
                    DispatchQueue.main.async {
                        completion()
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }

}
