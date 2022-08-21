//
//  MoviePlayerViewController.swift
//  MoviesCatalog
//
//  Created by AHMET SIRMA on 20.08.2022.
//

import UIKit
import AVFoundation

class MoviePlayerViewController: UIViewController {

    var movie: MoviePresentation?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    var viewModel: MoviePlayerViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MoviePlayerViewModel()
        self.player = AVPlayer()
        
        
        // Test video playing for demo
        let videoURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = viewPlayer.bounds
        playerLayer?.backgroundColor = UIColor.black.cgColor
        viewPlayer.layer.addSublayer(playerLayer!)
        player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer?.frame = self.view.bounds
            self.view.layer.addSublayer(self.playerLayer!)
        }
        else {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.viewPlayer.frame.width, height: 250)
            self.viewPlayer.layer.addSublayer(self.playerLayer!)
            
        }
    }
}

extension MoviePlayerViewController: MoviePlayerViewModelDelegate {
    func showMovie(movie: MoviePresentation) {
        self.movie = movie
        self.lblTitle.text = movie.title
        self.lblOverview.text = movie.overview
        self.lblOverview.sizeToFit()
    }
    
    
}
