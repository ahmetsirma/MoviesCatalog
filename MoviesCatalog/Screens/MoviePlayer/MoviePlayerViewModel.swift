//
//  MoviePlayerViewModel.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation


protocol MoviePlayerViewModelProtocol {
    var delegate: MoviePlayerViewModelDelegate? {get set}
    var movie: MoviePresentation?  {get set}
    func playMovie(movie: MoviePresentation) -> Void
}

protocol MoviePlayerViewModelDelegate {
    func showMovie(movie: MoviePresentation) -> Void
}


public final class MoviePlayerViewModel: MoviePlayerViewModelProtocol {
    
    var delegate: MoviePlayerViewModelDelegate?
    var movie: MoviePresentation? {
        didSet {
            if movie == nil {
                return
            }
            delegate?.showMovie(movie: movie!)
        }
    }
    
    func playMovie(movie: MoviePresentation) {
        
    }
}
