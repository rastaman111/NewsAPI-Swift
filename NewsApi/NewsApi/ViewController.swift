//
//  ViewController.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 29.06.2021.
//

import UIKit

class ViewController: UIViewController {
   
    private let tableView: UITableView = {
       let tv = UITableView()
        tv.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseId)
        
        return tv
    }()
    
    let refreshControl = UIRefreshControl()
    
    let searchController = UISearchController(searchResultsController: nil)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        creatSearchBar()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(self.refreshControl)
       
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
  
    private func fetchApi() {
        Request.shared.fetchApi {
            print("Refreshing success")
        }
    }
    
    @objc func refresh() {
        if refreshControl.isRefreshing {
            
            self.fetchApi()
            
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - Table view data source

extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Request.shared.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId, for: indexPath) as? TableViewCell else { fatalError() }
        
        cell.configure(with: Request.shared.viewModels[indexPath.row])
        
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
        
        Request.shared.searchFetchApi(text: text) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.searchController.dismiss(animated: true, completion: nil)
            }
        }
    }
}

