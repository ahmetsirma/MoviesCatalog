//
//  MovieListViewModel.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation

protocol MovieListVMProtocol {
    var delegate: MovieListVMDelegate? {get set}
    
    func loadData() -> Void
    func itemSelected(categoryIdx: Int, itemIdx: Int) -> Void
}

protocol MovieListVMDelegate {
    func showMovies(categories: [CategoryPresentation]) -> Void
    func showLoading(show: Bool) -> Void
}


public class MovieListViewModel: MovieListVMProtocol {
    
    var delegate: MovieListVMDelegate?
    var categories: [CategoryPresentation]?
    
    func loadData() {
        delegate?.showLoading(show: true)
        categories = [CategoryPresentation]()
        //Get Popular Movies
        ApiClient.shared.getMoviesByCategory(sortBy: "popularity.desc") { result in
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                let categoryItem = CategoryPresentation(name: "Popular", movies:movies)
                self.categories?.append(categoryItem)
                self.delegate?.showMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.delegate?.showLoading(show: false)
        }
        
        //Get Top Rated Movies
        ApiClient.shared.getMoviesByCategory(sortBy: "revenue.desc") { result in
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                let categoryItem = CategoryPresentation(name: "Top Rated", movies:movies)
                self.categories?.append(categoryItem)
                self.delegate?.showMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.delegate?.showLoading(show: false)
        }
        
        //Get Movies By Revenue
        ApiClient.shared.getMoviesByCategory(sortBy: "revenue.desc") { result in    //TODO
            switch result {
            case .success(let data):
                let movies = data.results.map{MoviePresentation(title: $0.title, overview: $0.overview, posterPath: $0.posterPath, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)}
                let categoryItem = CategoryPresentation(name: "Revenue", movies:movies)
                self.categories?.append(categoryItem)
                self.delegate?.showMovies(categories: self.categories ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.delegate?.showLoading(show: false)
        }
    }
    
    func itemSelected(categoryIdx: Int, itemIdx: Int) {
        let movie = self.categories?[categoryIdx].movies?[itemIdx]
        
    }
}

