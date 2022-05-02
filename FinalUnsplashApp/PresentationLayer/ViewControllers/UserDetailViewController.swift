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
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let pinImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "pin.fill")
            imageView.tintColor = .systemGray
            imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return imageView
        }()
        
        let stackView = UIStackView(arrangedSubviews: [pinImageView, locationLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var usernameStackView: UIStackView = {
        let planetImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "network")
            imageView.tintColor = .systemGray
            imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return imageView
        }()
        
        let stackView = UIStackView(arrangedSubviews: [planetImageView, usernameLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        var subViews: [UIView] = []
        if viewModel.getUser().location != nil {
            subViews = [nameLabel, locationStackView, usernameStackView]
        } else {
            subViews = [nameLabel, usernameStackView]
        }
        let stackView = UIStackView(arrangedSubviews: subViews)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var userInfoView: UIView = {
        let view = UIView()
        view.addSubview(userImageView)
        view.addSubview(mainStackView)
        return view
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
        
        viewModel.fetchUserPhotos()
        
        layoutUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func bindViewModel() {
        
        viewModel.didLoadUserInfo = { [weak self] user in
            self?.title = user.name
        }
        
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func layoutUI() {
        view.backgroundColor = .systemBackground
        setUpShareButton()
        setUpUserInfo()
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpShareButton() {
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        shareButtonItem.tintColor = .label
        navigationItem.rightBarButtonItem = shareButtonItem
    }
    
    private func setUpUserInfo() {
        let user = viewModel.getUser()
        title = user.name
        nameLabel.text = user.name
        usernameLabel.text = user.username
        locationLabel.text = user.location
        let userImageUrl = user.profile_image["large"]
        guard let imageUrl = userImageUrl, let url = URL(string: imageUrl) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func layoutSegmentedControl() {
        segmentedControl.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
        }
    }
    
    private func layoutUserInfoView() {
        userInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        layoutUserImageView()
        layoutUserSatckView()
    }
    
    private func layoutUserImageView() {
        userImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(100)
        }
        userImageView.layer.cornerRadius = userImageView.layer.frame.height / 2
    }
    
    private func layoutUserSatckView() {
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(15)
            $0.leading.equalTo(userImageView)
        }
    }
    
    @objc func didChangeSegmentedControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Photos")
            if viewModel.getUserPhotos().isEmpty {
                viewModel.fetchUserPhotos()
            }
        case 1:
            print("Likes")
            if viewModel.getLikedPhotos().isEmpty {
                viewModel.fetchLikedPhotos()
            }
        case 2:
            print("Collections")
            if viewModel.getCollections().isEmpty {
                viewModel.fetchCollections()
            }
        default:
            print("None")
        }
        collectionView.reloadData()
    }
    
    @objc func didTapShareButton() {
        print("Share button clicked")
    }
}

// MARK: - UICollectionViewDataSource
extension UserDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 0
        }
        
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
        
        if (indexPath.section == 0) {
            // Empty cell
            return UICollectionViewCell()
        }
        
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        switch selectedSegmentIndex {
        case 0, 1:
            collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
            let photos = selectedSegmentIndex == 0 ? viewModel.getUserPhotos() : viewModel.getLikedPhotos()
            cell.unsplashPhoto = photos[indexPath.row]
            cell.cornerRadius = 0
            if selectedSegmentIndex == 0 {
                cell.clearAuthorLabel()
            }
            return cell
        case 2:
            collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as! CollectionCell
            cell.unsplashCollection = viewModel.getCollections()[indexPath.row]
            return cell
        default:
            print("default")
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        
        if (indexPath.section == 0) {
            return CGSize(width: 0, height: 0)
        }
        
        switch selectedSegmentIndex {
        case 0, 1:
            let widthPerItem = collectionView.frame.width
            let photos = selectedSegmentIndex == 0 ? viewModel.getUserPhotos() : viewModel.getLikedPhotos()
            let photo = photos[indexPath.item]
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
    
    // MARK: - Section's header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case 0:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.reuseId, for: indexPath)
                headerView.addSubview(userInfoView)
                layoutUserInfoView()
                return headerView
            case 1:
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

        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            if viewModel.getUser().location != nil {
                return CGSize(width: collectionView.frame.width, height: 240)
            } else {
                return CGSize(width: collectionView.frame.width, height: 210)
            }
        }
        return CGSize(width: collectionView.frame.width, height: segmentedControl.frame.height + 10 * 2)
    }

    // MARK: - Scroll Detection
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        // Title Hide and Reveal
        guard let navBarHeight = navigationController?.navigationBar.frame.height else { return }
        let userInfoHeaderHeight: CGFloat = viewModel.getUser().location != nil ? 240 : 210
        if position > navBarHeight + userInfoHeaderHeight - (segmentedControl.frame.height + 10*2) {
            title = viewModel.getUser().name
        } else {
            title = ""
        }
        
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            // fetch more data
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                viewModel.fetchUserPhotos()
            case 1:
                viewModel.fetchLikedPhotos()
            case 2:
                viewModel.fetchCollections()
            default:
                return
            }
        }
    }
}

// MARK: - UICollectionReusableView
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
