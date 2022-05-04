//
//  SearchViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 28.04.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var viewModel = SearchViewModel(networkDataFetch: NetworkDataFetch.shared)
    

    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

   
    private let collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        return collectionView
    }()
    
    private let filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.tintColor = .label
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
        setUpSearchController()
        setUpSegmentControl()
        setUpCollectionView()
        setUpTableView()
        setUpFilterButton()
        setUpBackBarButtonItem()
        bindViewModel()
        cellActionHandlers()
        tableDirector.tableView.reloadData()
    }
    
    init(searchText: String, viewModel: SearchViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        if searchText != "" {
            searchController.searchBar.text = searchText
            viewModel.fetchData(searchText: searchText)
            self.collectionView.reloadData()
        }
        bindViewModel()
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




    // MARK: - UI Elements
  
    private func bindViewModel() {
        viewModel.updateUsersTableView = { [weak self] users in
            let cellItems = self?.cellBuilder.reset()
                .buildCells(with: users)
                .getConfigurableCells()
            guard let cellItems = cellItems else { return }
            self?.tableDirector.reloadTable(with: cellItems)
            self?.tableView.isHidden = true
        }

        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
   

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
                let userDetailVC = UserDetailViewController(viewModel: UserDetailViewModel(networkDataFetch: self.viewModel.networkDataFetch, user: item))
                self.navigationController?.pushViewController(userDetailVC, animated: true)
            }
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
// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            return viewModel.photos.count
        case 1:
            return viewModel.collections.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            
            collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseID, for: indexPath) as! PhotosCell
            let unsplashPhoto = viewModel.photos[indexPath.item]
            cell.unsplashPhoto = unsplashPhoto
            return cell
        case 1:
            print("selected segment = 1 collections")
            collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseID)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseID, for: indexPath) as! CollectionCell
            let unsplashCollection = viewModel.collections[indexPath.item]
            cell.unsplashCollection = unsplashCollection
            return cell
        default:
            return UICollectionViewCell()
                
       }
        
    }
}
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.fetchData(searchText: searchText)
        self.collectionView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthPerItem = collectionView.frame.width - (sectionInserts.left * 2)
        let collection = viewModel.collections[indexPath.item]
        guard let coverPhoto = collection.cover_photo else { return CGSize(width: 0, height: 0) }
        let height = CGFloat(coverPhoto.height) * widthPerItem / CGFloat(coverPhoto.width)
        return CGSize(width: widthPerItem, height: height)
        
        
    }
}

// MARK: - CustomLayoutDelegate

extension SearchViewController: CustomLayoutDelegate{

    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        let photo = viewModel.photos[indexPath.item]
            return  CGSize(width: photo.width, height: photo.height)
    }
}
