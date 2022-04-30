//
//  UserDetailViewController.swift
//  FinalUnsplashApp
//
//  Created by Ramir Amrayev on 30.04.2022.
//

import UIKit

class UserDetailViewController: UIViewController {

    private let viewModel: UserDetailViewModel
    
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.reuseId)
        return collectionView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Photos", "Likes", "Collections"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(didChangeSegmentedControlValue), for: .valueChanged)
        return sc
    }()
    
    private var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.getUser().name
        view.backgroundColor = .systemBackground
        layoutNavBar()
        
        bindViewModel()
        viewModel.fetchUserInfo()
        viewModel.fetchUserPhotos()
        viewModel.fetchLikedPhotos()
        viewModel.fetchCollections()
        
        layoutUI()
    }
    
    private func bindViewModel() {
        
        viewModel.didLoadUserInfo = { [weak self] user in
            print(user.location)
        }
        
        viewModel.reloadCollectionView = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func layoutNavBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.prefersLargeTitles = true
    }
    
    private func layoutUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func layoutSegmentedControl() {
        segmentedControl.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    @objc func didChangeSegmentedControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Photos")
            collectionView.reloadData()
        case 1:
            print("Likes")
            collectionView.reloadData()
        case 2:
            print("Collections")
            print(viewModel.getCollections().count)
            collectionView.reloadData()
        default:
            print("None")
        }
    }
    
}

extension UserDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return viewModel.getUserPhotos().count
        case 1:
            return viewModel.getLikedPhotos().count
        case 2:
            return viewModel.getCollections().count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        switch selectedSegmentIndex {
        case 0, 1:
            collectionView.register(PhotosViewCell.self, forCellWithReuseIdentifier: PhotosViewCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosViewCell.reuseID, for: indexPath) as! PhotosViewCell
            let photos = selectedSegmentIndex == 0 ? viewModel.getUserPhotos() : viewModel.getLikedPhotos()
            cell.unsplashPhoto = photos[indexPath.row]
            cell.cornerRadius = 0
            if selectedSegmentIndex == 0 {
                cell.clearAuthorLabel()
            }
            return cell
        case 2:
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
            cell.unsplashCollection = viewModel.getCollections()[indexPath.row]
            return cell
        default:
            print("default")
            return UICollectionViewCell()
        }
    }
}

extension UserDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0, 1:
            let widthPerItem = collectionView.frame.width
            let photo = viewModel.getUserPhotos()[indexPath.item]
            let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
            return CGSize(width: widthPerItem, height: height)
        case 2:
            let widthPerItem = collectionView.frame.width * 0.9
            let height = CGFloat(200)
            return CGSize(width: widthPerItem, height: height)
        default:
            print("default")
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 2 {
            return 10
        }
        return 0
    }
    
    // Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.reuseId, for: indexPath)

            headerView.addSubview(segmentedControl)
            layoutSegmentedControl()
            
            // Keep static like navBar
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionHeadersPinToVisibleBounds = true
            }
            
            return headerView

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: segmentedControl.frame.height + 10 * 2)
    }
}



class CollectionHeader: UICollectionReusableView {
    
    static let reuseId = "CollectionHeader"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground

        // Customize here
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
}
