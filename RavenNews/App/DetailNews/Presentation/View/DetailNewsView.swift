//
//  DetailNewsView.swift
//  RavenNews
//
//  Created by MaurZac on 30/11/24.
//
import UIKit
import Combine

final class DetailNewsView: UIViewController {
    
    var viewModel: DetailNewsViewModel
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    init(viewModel: DetailNewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureUI() {
        // Usar el ViewModel para configurar la UI
        titleLabel.text = viewModel.news.title
        descriptionLabel.text = viewModel.news.abstract
        if let url = URL(string: viewModel.news.media.first?.mediaMetadata.first?.url ?? "") {
            imageView.loadImage(from: url)
        }
    }
}
