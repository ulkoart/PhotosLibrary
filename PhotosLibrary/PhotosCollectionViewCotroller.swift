//
//  PhotosCollectionViewCotroller.swift
//  PhotosLibrary
//
//  Created by Артем Улько on 09/10/2019.
//  Copyright © 2019 Артем Улько. All rights reserved.
//

import UIKit

class PhotosCollectionViewCotroller: UICollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    
    private var photos = [UnsplashPhoto]()
    
    private var selectedImages = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action , target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    private func undateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        undateNavButtonsState()
    }
    
    @objc private func addBarButtonTapped() {
        print(#function)
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        
        
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .orange
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
    }
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuserId)

    }
    
    private func setupNavigationBar() {
        let titleLable = UILabel()
        titleLable.text = "PHOTOS"
        titleLable.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLable.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLable)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuserId, for: indexPath) as! PhotosCell
        let unspashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unspashPhoto
        return cell
    }

}

extension PhotosCollectionViewCotroller: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
        })
    }
}

extension PhotosCollectionViewCotroller: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
