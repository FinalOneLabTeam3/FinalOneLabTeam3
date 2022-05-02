//
//  SearchViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 28.04.2022.
//

import UIKit

class SearchViewController: UIViewController {

   
    private let collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.tintColor = .black
        filterButton.backgroundColor = .systemGray4
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3") , for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.layer.cornerRadius = 5
        filterButton.isHidden = true
        return filterButton
    }()
    
    
    var networkDataFetch = NetworkDateFetch()

    private var photos = [UnsplashPhoto]()
    private var collections = [UnsplashCollection]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    private var timer: Timer?
    
    lazy var segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Photos", "Collections", "Users"])
        sc.selectedSegmentIndex = 0
        sc.isHidden = true
        sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    let searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSearchController()
        setUpSegmentControl()
        setUpCollectionView()
        setUpFilterButton()
    }




    // MARK: - UI Elements
  
   
    private func setUpFilterButton(){
        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().inset((tabBarController?.tabBar.frame.height)! + 20)
        }
    }
    private func setUpSegmentControl(){
        
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(searchController.searchBar.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
//            make.top.equalTo(segmentedControl.snp.bottom).inset(searchController.searchBar.frame.height + 127)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setUpSearchController(){
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }


}
extension SearchViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            return photos.count
        case 1:
            print("collection count \(collections.count)")
            return collections.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            collectionView.register(PhotosViewCell.self, forCellWithReuseIdentifier: PhotosViewCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosViewCell.reuseID, for: indexPath) as! PhotosViewCell
            let unsplashPhoto = photos[indexPath.item]
            cell.unsplashPhoto = unsplashPhoto
            return cell
        case 1:
            print("selected segment = 1 collections")
            self.collectionView.reloadData()
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
            let unsplashCollection = collections[indexPath.item]
            cell.unsplashCollection = unsplashCollection
            return cell
        case 2: //users
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
                
       }
        
    }
}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        segmentedControl.isHidden = false
        collectionView.isHidden = false
        filterButton.isHidden = false
        
        timer?.invalidate()
        guard let searchText = searchBar.text else { return }
        
        
            
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
            self.networkDataFetch.fetchImages(searchTerm: searchText, path: PhotosViewCell.path) { [weak self] (results) in
                guard let fetchedPhotos = results else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
            self.networkDataFetch.fetchCollections(searchTerm: searchText, path: CollectionViewCell.path) { [weak self] (results) in
                guard let fetchedCollections = results else { return }
                self?.collections = fetchedCollections.results
                self?.collectionView.reloadData()
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.removeFromSuperview()
    }
}
extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            let paddingSpace = sectionInserts.left * (itemsPerRow + 0.5)
            let availableWidth = collectionView.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            let photo = photos[indexPath.item]
            let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
            return CGSize(width: widthPerItem, height: height)
        case 1:
            let widthPerItem = collectionView.frame.width - (sectionInserts.left * 2)
            let collection = collections[indexPath.item]
            let height = CGFloat(collection.cover_photo.height) * widthPerItem / CGFloat(collection.cover_photo.width)
            return CGSize(width: widthPerItem, height: height)
        default: break
        }
        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
