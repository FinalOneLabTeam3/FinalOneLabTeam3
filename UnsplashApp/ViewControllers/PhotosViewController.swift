//
//  PhotosViewController.swift
//  UnsplashApp
//
//  Created by Akniyet Turdybay on 26.04.2022.
//

import UIKit

class PhotosViewController: UICollectionViewController {
    
    //    private lazy var addBarButton: UIBarButtonItem = {
    //        var addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTaped))
    //        return addBarButton
    //    }()
    //
    //    private lazy var actionBarButton: UIBarButtonItem = {
    //        var actionBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTaped))
    //        return actionBarButton
    //    }()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        setUpCollectionView()
        setUpSearchController()
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /*
    // MARK: - UI Elements
    */
    
    private func setUpSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
    }
    
    private func setUpCollectionView(){
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: view.frame.height)
    }

}
