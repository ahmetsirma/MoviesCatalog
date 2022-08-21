//
//  MovieDetailsViewController.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movie: MoviePresentation?
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    var viewModel: MovieDetailsVMProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MovieDetailsViewModel()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnPlayTapped(_ sender: Any) {
        guard let movieToPlay = movie else {
            return
        }

        self.viewModel.playMovie(movie: movieToPlay)
    }
    
}


extension MovieDetailsViewController: MovieDetailsVMDelegate {
    func showMovie(movie: MoviePresentation) {
        self.movie = movie
        self.imgPoster.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original/\(movie.posterPath ?? "")"))
        self.lblTitle.text = movie.title
        self.lblOverview.text = movie.overview
        self.lblOverview.sizeToFit()
        self.lblRating.text = "\(movie.voteAverage ?? 0)(\(movie.voteCount ?? 0))"
        
        if movie.releaseDate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YYYY"
            self.lblReleaseDate.text = dateFormatter.string(from: movie.releaseDate!)
        }
    }
}


