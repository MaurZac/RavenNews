//
//  HomeNewsView.swift
//  RavenNews
//
//  Created by MaurZac on 29/11/24.
//
import UIKit
import Combine

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat
}

final class HomeNewsView: UIViewController {
    
    private var viewModel: HomeNewsViewModel!
    private var cancellables = Set<AnyCancellable>()
    private var coordinator: HomeNewsCoordinator
    private var viewControllerFactory: HomeNewsFactory
    
    private var collectionView: UICollectionView!
    
    private var articles: [Articles] = []
    
    init(viewModel: HomeNewsViewModel, coordinator: HomeNewsCoordinator, viewControllerFactory: HomeNewsFactory) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.viewControllerFactory = viewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchNews()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let layout = PinterestLayout()
        layout.delegate = self
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NewsArticleCell.self, forCellWithReuseIdentifier: "NewsArticleCell")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    private func bindViewModel() {
        viewModel.$articles
            .sink { [weak self] articles in
                self?.articles = articles
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    print("Loading...")
                } else {
                    print("Loaded")
                }
            }
            .store(in: &cancellables)
    }
}

extension HomeNewsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsArticleCell", for: indexPath) as! NewsArticleCell
        let article = articles[indexPath.item]
        cell.configure(with: article)
        return cell
    }
}

extension HomeNewsView: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let article = articles[indexPath.item]
        // Calcula la altura dinámica de la celda según el contenido del título y descripción
        let titleHeight = article.title.height(
            withConstrainedWidth: (collectionView.bounds.width / 2) - 16,
            font: UIFont.boldSystemFont(ofSize: 16)
        )
        let descriptionHeight = article.abstract.height(
            withConstrainedWidth: (collectionView.bounds.width / 2) - 16,
            font: UIFont.systemFont(ofSize: 14)
        )
        return titleHeight + descriptionHeight + 60
    }
}

extension HomeNewsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = articles[indexPath.item]
        
        let detailViewModel = DetailNewsViewModel(news: selectedArticle)
        
        let detailView = DetailNewsView(viewModel: detailViewModel)
        
        navigationController?.pushViewController(detailView, animated: true)
    }
}


class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 6
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        var yOffset = Array(repeating: CGFloat(0), count: numberOfColumns)
        
        var column = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = columnWidth - cellPadding * 2
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath) ?? 200
            let height = cellPadding * 2 + itemHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += height
            column = (column < (numberOfColumns - 1)) ? (column + 1) : 0
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

