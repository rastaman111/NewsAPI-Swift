//
//  SplashScreenViewController.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 02.07.2021.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        
        showActivityIndicator(show: true)
      
        Request.shared.fetchApi { [weak self] in
            self?.showActivityIndicator(show: false)
            self?.mainScreen()
        }

    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc func mainScreen() {
        performSegue(withIdentifier: "newsList", sender: self)
    }

}
