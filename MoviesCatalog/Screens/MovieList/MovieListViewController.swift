//
//  ViewController.swift
//  MoviesCatalog
//
//  Created by Ahmet SIRMA on 18.08.2022.
//

import UIKit
import SwiftUI
import Kingfisher

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionViewScreen: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories: [CategoryPresentation]?
    
    var viewModel: MovieListVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collectionViewScreen.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        self.viewModel = MovieListViewModel()
        self.viewModel.loadData()
    }
}

extension MovieListViewController: MovieListVMDelegate {
    func showMovies(categories: [CategoryPresentation]) {
        self.categories = categories
        for view in self.collectionViewScreen.subviews {
            view.removeFromSuperview()
        }
        self.collectionViewScreen.reloadData()
    }
    
    func showLoading(show:Bool)
    {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.itemSelected(categoryIdx: collectionView.tag, itemIdx: indexPath.row)
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewScreen {
            return self.categories?.count ?? 0
        }
        else {
            return self.categories?[collectionView.tag].movies?.count ?? 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewScreen {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath)
            let categoryCollection = createCategoryCollection(index: indexPath.row, rect: CGRect(x: 0, y: 5, width: cell.frame.width, height: cell.frame.height))
            cell.addSubview(categoryCollection)
            
            let titleLabel = UILabel()
            titleLabel.text = self.categories?[indexPath.row].name
            titleLabel.textColor = .black
            titleLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 20)
            cell.addSubview(titleLabel)
            
            
            //cell.backgroundColor = indexPath.row == 0 ? .yellow : (indexPath.row == 1 ? .orange : (indexPath.row == 2 ? .red : .blue))  //TODO Temp
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath)
            let movie = self.categories?[collectionView.tag].movies?[indexPath.row] ?? nil
            let imgPoster = UIImageView()
            imgPoster.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(movie?.posterPath ?? "")"))
            imgPoster.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            cell.addSubview(imgPoster)
            return cell
        }
    }
    
    func createCategoryCollection(index: Int, rect: CGRect) -> UICollectionView {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal

        let collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.frame = rect
        collectionview.autoresizingMask = .flexibleWidth
        //collectionview.backgroundColor = index == 0 ? .yellow : (index == 1 ? .orange : (index == 2 ? .red : .blue))
        collectionview.tag = index
        return collectionview
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewScreen {
            return CGSize(width: self.view.frame.width, height: 300)
        }
        else {
            return CGSize(width: 150, height: 250)
        }
    }
}
