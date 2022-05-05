//
//  CollectionPhotoViewController.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 05.05.2022.
//

import UIKit

class CollectionPhotoViewController: UIViewController {
    
    private let viewModel: CollectionPhotoViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    init(viewModel: CollectionPhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchCollectionPhotos()
        layoutUI()
        bindViewModel()
    }
    
    private func layoutUI() {
        title = viewModel.getCollection().title
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        setUpShareButton()
    }
    
    private func bindViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func setUpShareButton() {
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        shareButtonItem.tintColor = .label
        navigationItem.rightBarButtonItem = shareButtonItem
    }
    
    @objc func didTapShareButton() {
        print("Share button clicked")
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionPhotoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getPhotos().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
        let photos = viewModel.getPhotos()
        cell.unsplashPhoto = photos[indexPath.row]
        cell.cornerRadius = 0
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionPhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = collectionView.frame.width
        let photos = viewModel.getPhotos()
        let photo = photos[indexPath.item]
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Scroll Detection
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            // fetch more data
            viewModel.fetchCollectionPhotos()
        }
    }
}
