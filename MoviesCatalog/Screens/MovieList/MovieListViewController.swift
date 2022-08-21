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
    
    var viewModel: MovieListViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.current().rootView = self
        // Do any additional setup after loading the view.
        self.collectionViewScreen.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
        self.viewModel = MovieListViewModel()
        self.viewModel.loadData()
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
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
            
            //Title label creating
            let titleLabel = UILabel()
            titleLabel.text = self.categories?[indexPath.row].name
            titleLabel.textColor = .white
            titleLabel.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 20)
            cell.addSubview(titleLabel)
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath)
            let movie = self.categories?[collectionView.tag].movies?[indexPath.row] ?? nil
            
            //Loading for cell posters
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            loadingIndicator.startAnimating()
            loadingIndicator.color = .white
            loadingIndicator.center = cell.center
            cell.addSubview(loadingIndicator)
            
            //Posters for MovieCells
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
        collectionview.backgroundColor = .clear     //index == 0 ? .yellow : (index == 1 ? .orange : (index == 2 ? .red : .blue))
        collectionview.tag = index
        return collectionview
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewScreen {
            return CGSize(width: Int(self.view.frame.width), height: Configuration.MovieListSectionHeight)
        }
        else {
            return CGSize(width: Configuration.MovieListPosterSize.width, height: Configuration.MovieListPosterSize.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == collectionViewScreen {
            return
        }
        if indexPath.row == (self.categories?[collectionView.tag].movies!.count)! - 3 {
            print("ScrollToEnd")
            self.viewModel.loadMore(categoryIdx: collectionView.tag)
        }
    }
}
