////
////  PhotosCollectionViewController.swift
////  FinalUnsplashApp
////
////  Created by Akniyet Turdybay on 26.04.2022.
////
//
//import UIKit
//
////private let reuseIdentifier = "Cell"
//
//class PhotosCollectionViewController: UICollectionViewController {
//
//    var networkDataFetch = NetworkDateFetch()
//
//    private var photos = [UnsplashCollection]()
//    private let itemsPerRow: CGFloat = 2
//    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//
//    private var timer: Timer?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        setUpCollectionView()
//        setUpSearchController()
//    }
//
//    init() {
//        super.init(collectionViewLayout: UICollectionViewFlowLayout())
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//
//    // MARK: - UI Elements
//
//    private func setUpCollectionView(){
////        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView.register(PhotosViewCell.self, forCellWithReuseIdentifier: PhotosViewCell.reuseID)
////        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        collectionView.contentInsetAdjustmentBehavior = .automatic
//        collectionView.allowsMultipleSelection = true
//        collectionView.backgroundColor = .white
//    }
//
//    private func setUpSearchController(){
//        let searchController = UISearchController(searchResultsController: nil)
//        navigationItem.searchController = searchController
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//    }
//
//
//
//
//    // MARK: UICollectionViewDataSource
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
//        let unsplashCollection = photos[indexPath.item]
//        cell.unsplashCollection = unsplashCollection
//        return cell
//    }
//
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
//    */
//
//}
//
//extension PhotosCollectionViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        timer?.invalidate()
//        guard let searchText = searchBar.text else { return }
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
//            self.networkDataFetch.fetchImages(searchTerm: searchText, path: CollectionViewCell.path) { [weak self] (results) in
//                guard let fetchedPhotos = results else { return }
//                self?.photos = fetchedPhotos.results
//                self?.collectionView.reloadData()
//            }
//        })
//
//    }
//}
//
//extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let photo = photos[indexPath.item]
//        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
//        print(paddingSpace)
//        let availableWidth = collectionView.frame.width - paddingSpace
//        print(availableWidth)
//        let widthPerItem = availableWidth / itemsPerRow
////        print(widthPerItem)
//        print(photo.height)
//        print(photo.width)
//        let height = CGFloat(Int(photo.height["height"])) * CGFloat(Int(widthPerItem)) / CGFloat(Int(photo.width["width"]))
////        print(height)
//        return CGSize(width: widthPerItem, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInserts
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInserts.left
//    }
//}
//
