//
//  NewsArticleCell.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import UIKit

class NewsArticleCell: UICollectionViewCell {
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var imageView: UIImageView!
    private var overlayView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(overlayView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -4),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with article: Articles) {
        titleLabel.text = article.title
        descriptionLabel.text = article.abstract
        if let url = URL(string: article.media.first?.mediaMetadata.first?.url ?? "") {
            imageView.loadImage(from: url)
        }
    }
}
