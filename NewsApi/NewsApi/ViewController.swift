//
//  ViewController.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 29.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!
    
    private let tableView: UITableView = {
       let tv = UITableView()
        tv.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
        
        return tv
    }()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var viewModels = [NewsViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        
        creatSearchBar()
        
        showActivityIndicator(show: true)
        
        NetworkManager.shared.getStories { [weak self] result in
            switch result {
            case .success(let response):
                self?.viewModels = response.compactMap({
                    NewsViewModel(title: $0.title,
                                  subtitle: $0.description ?? "NO Description",
                                  author: $0.author,
                                  imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.showActivityIndicator(show: false)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func creatSearchBar() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Поиск..."
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - Table view data source

extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId, for: indexPath) as? TableViewCell else { fatalError() }
        
        cell.configure(with: viewModels[indexPath.row])
        
        cell.usageActionHandler = {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.performBatchUpdates({
                cell.subtitleLabel.numberOfLines = cell.isCollapsed ? 0 : 2
            }, completion: nil)
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        NetworkManager.shared.getStoriesSeqrch(with: text) { [weak self] result in
            switch result {
            case .success(let response):
                self?.viewModels = response.compactMap({
                    NewsViewModel(title: $0.title,
                                  subtitle: $0.description ?? "NO Description",
                                  author: $0.author,
                                  imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.showActivityIndicator(show: false)
                    self?.tableView.reloadData()
                    self?.searchController.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

