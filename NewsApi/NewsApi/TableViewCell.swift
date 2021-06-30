//
//  TableViewCell.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 29.06.2021.
//

import UIKit

class NewsViewModel {
    let title: String
    let subtitle: String
    let author: String?
    let imageURL: URL?
    
    init(title: String, subtitle: String, author: String?, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.imageURL = imageURL
    }
}

class TableViewCell: UITableViewCell {

    static let reuseId = "WhereCostCell"
    
    var isCollapsed = true

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 22, weight:  .semibold)

        return lbl
    }()
    
    public let subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.font = UIFont.systemFont(ofSize: 17, weight: .light)

        return lbl
    }()
    
    private let authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 15, weight: .light)

        return lbl
    }()
    
    private let newImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 6
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill

        return iv
    }()
    
    let arrowButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        btn.tintColor = .black
        
        return btn
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView()
        ac.hidesWhenStopped = true
        ac.style = .medium
        
        return ac
    }()
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func setCollapsed(collapsed: Bool) {
        arrowButton.rotate(collapsed ? 0.0 : .pi)
    }
    
    @objc func couponButtonAction(_ sender: UIButton) {
        usageActionHandler?()
        isCollapsed = !isCollapsed
        setCollapsed(collapsed: isCollapsed)
    }
    
    var usageActionHandler: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(newImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(arrowButton)
        
        newImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 150)
        
        authorLabel.anchor(top: newImageView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        titleLabel.anchor(top: authorLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 70)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        arrowButton.anchor(top: subtitleLabel.bottomAnchor, left: nil, bottom: contentView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 25, height: 20)
        arrowButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        arrowButton.addTarget(self, action: #selector(couponButtonAction), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        activityIndicator.center = newImageView.center
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        authorLabel.text = nil
        newImageView.image = nil
        
        isCollapsed = true
        subtitleLabel.numberOfLines = 2
    }
    
    func configure(with viewModel: NewsViewModel) {
        authorLabel.text = viewModel.author
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle.replacingOccurrences(of: "\\n", with: "\n")
        subtitleLabel.sizeToFit()
        
        showActivityIndicator(show: true)
        
        if let url = viewModel.imageURL {
            newImageView.loadImageUsingCacheWithUrlString(url.absoluteString) { [weak self] bool in
                self?.showActivityIndicator(show: !bool)
            }
        } else {
            newImageView.image = #imageLiteral(resourceName: "news")
            showActivityIndicator(show: false)
        }
    }
}
