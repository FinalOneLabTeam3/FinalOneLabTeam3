//
//  SearchViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 28.04.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    var networkDataFetch = NetworkDataFetch()

    private var users = [UnsplashUser]() {
        didSet {
            let cellItems = cellBuilder.reset()
                .buildCells(with: users)
                .getConfigurableCells()
            
            tableDirector.reloadTable(with: cellItems)
        }
    }
    
    let discoverViewController = DiscoverViewController()
    
    var photos = [UnsplashPhoto]()
    
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
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.tintColor = .label
        filterButton.backgroundColor = .systemGray4
        filterButton.setImage(UIImage(systemName: "slider.horizontal.3") , for: .normal)
        filterButton.imageView?.contentMode = .scaleAspectFit
        filterButton.layer.cornerRadius = 5
        filterButton.isHidden = true
        return filterButton
    }()
    
    lazy var segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Photos", "Collections", "Users"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(didChangeSegmentedControlValue), for: .valueChanged)
        sc.isHidden = true
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
        view.backgroundColor = .systemBackground
        self.navigationItem.hidesBackButton = true
        discoverViewController.setUpSearchController()
        setUpSearchController()
        setUpSegmentControl()
        setUpCollectionView()
        setUpTableView()
        setUpFilterButton()
        setUpBackBarButtonItem()
        cellActionHandlers()
        
        
        tableDirector.tableView.reloadData()
    }
    
    init(searchText: String) {
        super.init(nibName: nil, bundle: nil)
        if searchText != "" {
            searchController.searchBar.text = searchText
            
            fetchData(searchText: searchText)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    
    private func setUpCollectionView(){

        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
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
    
    private func setUpBackBarButtonItem() {
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = ""
        backBarBtnItem.tintColor = .label
        navigationItem.backBarButtonItem = backBarBtnItem
    }
    
    private func cellActionHandlers() {
        self.tableDirector.actionProxy
            .on(action: .didSelect) { (config: UserCellConfigurator, cell) in
                let item = config.item
                let userDetailVC = UserDetailViewController(viewModel: UserDetailViewModel(networkDataFetch: self.networkDataFetch, user: item))
                self.navigationController?.pushViewController(userDetailVC, animated: true)
            }
    }
    
    private func fetchData(searchText: String){
        segmentedControl.isHidden = false
        collectionView.isHidden = false
        filterButton.isHidden = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [self](_) in
            self.networkDataFetch.fetchImages(searchTerm: searchText, path: PhotosCell.path) { [weak self] (results) in
                guard let fetchedPhotos = results else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
            self.networkDataFetch.fetchCollections(searchTerm: searchText, path: CollectionCell.path) { [weak self] (results) in
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
    
    @objc func didChangeSegmentedControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Photos")
            collectionView.isHidden = false
            tableView.isHidden = true
            let customLayout = CustomLayout()
            customLayout.delegate = self
            collectionView.collectionViewLayout = customLayout
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        case 1:
            print("Collections")
            collectionView.isHidden = false
            tableView.isHidden = true
            let collectionLayout = UICollectionViewFlowLayout()
            collectionView.collectionViewLayout = collectionLayout
            collectionView.delegate = self
            collectionView.dataSource = self
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
            collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
            let unsplashPhoto = photos[indexPath.item]
            cell.unsplashPhoto = unsplashPhoto
            return cell
        case 1:
            print("selected segment = 1 collections")
            collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as! CollectionCell
            let unsplashCollection = collections[indexPath.item]
            cell.unsplashCollection = unsplashCollection
            return cell
        default:
            return UICollectionViewCell()
                
       }
        
    }
}

extension SearchViewController: UISearchBarDelegate{
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        fetchData(searchText: searchText)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem = collectionView.frame.width - (sectionInserts.left * 2)
        let collection = collections[indexPath.item]
        guard let coverPhoto = collection.cover_photo else { return CGSize(width: 0, height: 0) }
        let height = CGFloat(coverPhoto.height) * widthPerItem / CGFloat(coverPhoto.width)
        return CGSize(width: widthPerItem, height: height)
        
        
    }
}

extension SearchViewController: CustomLayoutDelegate{

    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
            let photo = photos[indexPath.item]
            return  CGSize(width: photo.width, height: photo.height)
    }
}
