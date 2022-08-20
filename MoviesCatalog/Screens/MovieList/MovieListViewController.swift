//
//  ViewController.swift
//  MoviesCatalog
//
//  Created by Ahmet SIRMA on 18.08.2022.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var collectionViewScreen: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //TODO test
        ApiClient.shared.getMoviesByCategory(sortBy: "popularity.desc") { result in
                    switch result {
                    case .success(let data):
                        let movies = data.results
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
    }
}

