//
//  MovieListViewModel.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation
import UIKit

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? {get set}
    
    func loadData() -> Void
    func itemSelected(categoryIdx: Int, itemIdx: Int) -> Void
    func loadMore(categoryIdx: Int) -> Void
}

protocol MovieListViewModelDelegate {
    func showMovies(categories: [CategoryPresentation]) -> Void
    func showMoreMovies(categories: [CategoryPresentation]) -> Void
    func showLoading(show: Bool) -> Void
}

public final class MovieListViewModel: MovieListViewModelProtocol {
    
    var delegate: MovieListViewModelDelegate?
    var categories: [CategoryPresentation]?
    var loadingData: Bool = false
    
    func loadData() {
        categories = [CategoryPresentation]()
        //Get Popular Movies
        self.delegate?.showLoading(show: true)
        loadingData = true
        ApiClient.shared.getMoviesByCategory(sortBy: "popularity.desc") { result in
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                let categoryItem = CategoryPresentation(name: "Popular", movies:movies, page: 2)    //İlk sayfa alındığı için page 2 yapıldı.
                self.categories?.append(categoryItem)
                self.delegate?.showMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.delegate?.showLoading(show: false)
            self.loadingData = false
        }
        
        //Get Top Rated Movies
        self.delegate?.showLoading(show: true)
        loadingData = true
        ApiClient.shared.getMoviesByCategory(sortBy: "vote_count.desc") { result in
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                let categoryItem = CategoryPresentation(name: "Top Rated", movies:movies, page: 2)
                self.categories?.append(categoryItem)
                self.delegate?.showMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.delegate?.showLoading(show: false)
            self.loadingData = false
        }
        
        //Get Movies By Revenue
        self.delegate?.showLoading(show: true)
        loadingData = true
        ApiClient.shared.getMoviesByCategory(sortBy: "revenue.desc") { result in    //TODO
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                let categoryItem = CategoryPresentation(name: "Revenue", movies:movies, page: 2)
                self.categories?.append(categoryItem)
                self.delegate?.showMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.delegate?.showLoading(show: false)
            self.loadingData = false
        }
    }
    
    func itemSelected(categoryIdx: Int, itemIdx: Int) {
        let movie = self.categories?[categoryIdx].movies?[itemIdx]

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let movieDetailScreen = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            movieDetailScreen.modalPresentationStyle = .pageSheet
        }
        else {
            movieDetailScreen.modalPresentationStyle = .fullScreen
        }
        (self.delegate as! MovieListViewController).present(movieDetailScreen, animated: true, completion: nil)
        movieDetailScreen.viewModel.movie = movie
        
    }
    
    func loadMore(categoryIdx: Int) {
        if loadingData == true {
            return
        }
        
        loadingData = true
        ApiClient.shared.getMoviesByCategory(sortBy: categoryIdx == 0 ? "popularity.desc" : (categoryIdx == 1 ? "vote_count.desc" : (categoryIdx == 2 ? "revenue.desc" : "")), page: self.categories?[categoryIdx].page ?? 0) { result in    //TODO
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                self.categories?[categoryIdx].movies?.append(contentsOf: movies)
                self.categories?[categoryIdx].page += 1
                self.delegate?.showMoreMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.loadingData = false
        }
    }
}

