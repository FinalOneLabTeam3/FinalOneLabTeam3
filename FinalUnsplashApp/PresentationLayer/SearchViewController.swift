//
//  SearchViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 28.04.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var networkDataFetch = NetworkDateFetch()

    private var users = [UnsplashUser]() {
        didSet {
            let cellItems = cellBuilder.reset()
                .buildCells(with: users)
                .getConfigurableCells()
            
            tableDirector.reloadTable(with: cellItems)
        }
    }
    private var photos = [UnsplashPhoto]()
    private var collections = [UnsplashCollection]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    private var timer: Timer?
   
    private let collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.tintColor = .black
        filterButton.backgroundColor = .systemGray4
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3") , for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.layer.cornerRadius = 5
        return filterButton
    }()
    
    lazy var segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Photos", "Collections", "Users"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(didChangeSegmentedControlValue), for: .valueChanged)
        return sc
    }()
    
    let searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.clipsToBounds = true
        tableView.backgroundColor = .systemFill
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var tableDirector: TableDirector = {
        let tableDirector = TableDirector(tableView: tableView, items: [])
        return tableDirector
    }()
    
    private var cellBuilder = UserCellBuilder()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpSearchController()
        cellActionHandlers()
        print(segmentedControl.frame.height)
        
        tableDirector.tableView.reloadData()
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
        print(segmentedControl.frame.height)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setUpSearchController() {
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(50)
        }
        tableView.layer.cornerRadius = 20
    }
    
    private func cellActionHandlers() {
        self.tableDirector.actionProxy
            .on(action: .didSelect) { (config: UserCellConfigurator, cell) in
                let item = config.item
                print(item.id)
//                let newsDetailWebPage = NewsDetailWebPage(url: URL(string: item.url))
//                self.navigationController?.pushViewController(newsDetailWebPage, animated: true)
            }
    }
    
    @objc func didChangeSegmentedControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Photos")
            collectionView.isHidden = false
            tableView.isHidden = true
            collectionView.reloadData()
        case 1:
            print("Collections")
            collectionView.isHidden = false
            tableView.isHidden = true
            collectionView.reloadData()
        case 2:
            print("Users")
            collectionView.isHidden = true
            tableView.isHidden = false
        default:
            print("None")
        }
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
        setUpSegmentControl()
        setUpCollectionView()
        setUpTableView()
        setUpFilterButton()
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
            self.networkDataFetch.fetchUsers(searchTerm: searchText, path: UserCell.path) { [weak self] (results) in
                guard let fetchedUsers = results else { return }
                self?.users = fetchedUsers.results
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
