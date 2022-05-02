//
//  DiscoverViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 01.05.2022.
//

import UIKit
import SnapKit

class DiscoverViewController: UIViewController {
    
//    private let searchViewController = SearchViewController()
    private var timer: Timer?
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
//    var listPhotos = [UnsplashPhoto]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .red
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpSearchController()
        setUpCollectionView()
    }
    
    let searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    
    func setUpSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension DiscoverViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchViewController = SearchViewController()
        self.navigationController?.pushViewController(searchViewController, animated: true)
//        timer?.invalidate()
//        guard let searchText = searchBar.text else { return }
//
//
//
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
//            self.networkDataFetch.fetchImages(searchTerm: searchText, path: PhotosCell.path) { [weak self] (results) in
//                guard let fetchedPhotos = results else { return }
//                self?.photos = fetchedPhotos.results
//                self?.collectionView.reloadData()
//            }
//            self.networkDataFetch.fetchCollections(searchTerm: searchText, path: CollectionCell.path) { [weak self] (results) in
//                guard let fetchedCollections = results else { return }
//                self?.collections = fetchedCollections.results
//                self?.collectionView.reloadData()
//            }
//            self.networkDataFetch.fetchUsers(searchTerm: searchText, path: UserCell.path) { [weak self] (results) in
//                guard let fetchedUsers = results else { return }
//                self?.users = fetchedUsers.results
//            }
//        })
    }
    
}
extension DiscoverViewController: UICollectionViewDelegate {
    
    
}
extension DiscoverViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section{
        case 0:
            collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as! CategoryCell
            return cell
        case 1:
            collectionView.register(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCell.reuseID, for: indexPath) as! DiscoverCell
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
}
    
extension DiscoverViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
            case 0:
            return CGSize(width: view.frame.width, height: view.frame.height / 2.5)
            case 1:
            return CGSize(width: view.frame.width, height: view.frame.height)
            default:
                return CGSize()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
            case 0:
                return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            default:
                return UIEdgeInsets()
            }
    }
    
    

    
}


