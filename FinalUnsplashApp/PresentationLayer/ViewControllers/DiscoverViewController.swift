//
//  DiscoverViewController.swift
//  FinalUnsplashApp
//
//  Created by Akniyet Turdybay on 01.05.2022.
//

import UIKit
import SnapKit

class DiscoverViewController: UIViewController {
    
    private let viewModel: DiscoverViewModel
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
        setUpSearchController()
        setUpCollectionView()
    }
    
    init(viewModel: DiscoverViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.text = ""
        searchController.searchBar.showsCancelButton = false
    }
    
    let searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    // MARK: - UI Elements
    
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension DiscoverViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
       
        let searchViewController = SearchViewController(searchText: searchText, viewModel: SearchViewModel(networkDataFetch: viewModel.dataFetch))
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
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
        return 1
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section{
            case 0:
            return CGSize(width: view.frame.width, height: 265)
            case 1:
            return CGSize(width: view.frame.width, height: view.frame.height)
            default:
                return CGSize()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
            case 0:
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            case 1:
                return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
            default:
                return UIEdgeInsets()
        }
    }
}


