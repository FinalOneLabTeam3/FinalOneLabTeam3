//
//  HomeViewController.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 02.05.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private let menuHeight: CGFloat = 35
    private var topicSelectedIndex = 0
    
    private lazy var topicsCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Unsplash"
        view.backgroundColor = .systemBlue
        makeNavBarTransparent()
        
        layoutUI()
        viewModel.fetchTopics()
        bindViewModel()
    }
    
    private func makeNavBarTransparent() {
        if #available(iOS 13, *) {
            let navBar = navigationController?.navigationBar
            navBar?.standardAppearance.backgroundColor = UIColor.clear
            navBar?.standardAppearance.backgroundEffect = nil
            navBar?.standardAppearance.shadowImage = UIImage()
            navBar?.standardAppearance.shadowColor = .clear
            navBar?.standardAppearance.backgroundImage = UIImage()
            navBar?.standardAppearance.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    
    private func layoutUI() {
        view.addSubview(photosCollectionView)
        view.addSubview(topicsCollectionView)
        
        topicsCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(menuHeight)
        }
        
        photosCollectionView.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(menuHeight)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide)
//            $0.width.equalToSuperview()
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.reloadTopicsCollectionView = { [weak self] in
            self?.topicsCollectionView.reloadData()
        }
        
        viewModel.reloadPhotosCollectionView = { [weak self] in
            self?.photosCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let topics = viewModel.getTopics()
        if collectionView == topicsCollectionView {
            return topics.count
        }
        
        if topics.isEmpty {
            return 0
        }
        return viewModel.getPhotos(topic: topics[topicSelectedIndex]).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topicsCollectionView {
            topicsCollectionView.register(TopicViewCell.self, forCellWithReuseIdentifier: TopicViewCell.reuseID)
            let cell = topicsCollectionView.dequeueReusableCell(withReuseIdentifier: TopicViewCell.reuseID, for: indexPath) as! TopicViewCell
            let isSelected = topicSelectedIndex == indexPath.row ? true : false
            cell.configureCell(topic: viewModel.getTopics()[indexPath.row], isSelected: isSelected)
            return cell
        }
        let topic = viewModel.getTopics()[topicSelectedIndex]
        let photos = viewModel.getPhotos(topic: topic)
        photosCollectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
        cell.configureCell(unsplashPhoto: photos[indexPath.row], cornerRadius: 0)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topicsCollectionView {
            return CGSize(width: view.frame.width/4 - 6, height: menuHeight)
        }
        let widthPerItem = photosCollectionView.frame.width
        let topic = viewModel.getTopics()[topicSelectedIndex]
        let photos = viewModel.getPhotos(topic: topic)
        let photo = photos[indexPath.item]
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topicsCollectionView {
            topicSelectedIndex = indexPath.row
            let selectedTopic = viewModel.getTopics()[topicSelectedIndex]
            print(selectedTopic)
            print(topicSelectedIndex)
            if viewModel.getPhotos(topic: selectedTopic).isEmpty {
                viewModel.fetchPhoto(from: selectedTopic)
            } else {
                photosCollectionView.reloadData()
            }
            topicsCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Scroll Detection
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (photosCollectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            // fetch more data
            let topics = viewModel.getTopics()
            if topics.isEmpty {
                return
            }
            let selectedTopic = topics[topicSelectedIndex]
            viewModel.fetchPhoto(from: selectedTopic)
        }
    }
}
