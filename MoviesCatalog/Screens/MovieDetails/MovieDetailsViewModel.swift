//
//  MovieDetailsViewModel.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import Foundation
import UIKit


protocol MovieDetailsViewModelProtocol {
    var delegate: MovieDetailsViewModelDelegate? {get set}
    var movie: MoviePresentation?  {get set}
    func playMovie(movie: MoviePresentation) -> Void
}

protocol MovieDetailsViewModelDelegate {
    func showMovie(movie: MoviePresentation) -> Void
}


public final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    var delegate: MovieDetailsViewModelDelegate?
    var movie: MoviePresentation? {
        didSet {
            if movie == nil {
                return
            }
            delegate?.showMovie(movie: movie!)
        }
    }
    
    func playMovie(movie: MoviePresentation) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let moviePlayerScreen = storyboard.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
        moviePlayerScreen.modalPresentationStyle = .fullScreen
        (self.delegate as! MovieDetailsViewController).present(moviePlayerScreen, animated: true, completion: nil)
        moviePlayerScreen.viewModel.movie = movie
    }
}
