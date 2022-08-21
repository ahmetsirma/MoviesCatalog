//
//  MoviePlayerViewModel.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation


protocol MoviePlayerViewModelProtocol {
    var delegate: MoviePlayerViewModelDelegate? {get set}
    var movie: MoviePresentationModel?  {get set}
    func playMovie(movie: MoviePresentationModel) -> Void
}

protocol MoviePlayerViewModelDelegate {
    func showMovie(movie: MoviePresentationModel) -> Void
}


public final class MoviePlayerViewModel: MoviePlayerViewModelProtocol {
    
    var delegate: MoviePlayerViewModelDelegate?
    var movie: MoviePresentationModel? {
        didSet {
            if movie == nil {
                return
            }
            delegate?.showMovie(movie: movie!)
        }
    }
    
    func playMovie(movie: MoviePresentationModel) {
        
    }
}
