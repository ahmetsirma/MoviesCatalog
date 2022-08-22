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
    @IBOutlet weak var indLoading: UIActivityIndicatorView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
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
        indLoading.stopAnimating()
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer?.frame = self.view.bounds
            self.view.layer.addSublayer(self.playerLayer!)
            
            self.btnPlayPause.removeFromSuperview()
            self.view.addSubview(self.btnPlayPause)
            self.btnPlayPause.center = self.view.center
        }
        else {
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: self.viewPlayer.frame.width, height: 250)
            self.viewPlayer.layer.addSublayer(self.playerLayer!)
            
            self.btnPlayPause.removeFromSuperview()
            self.viewPlayer.addSubview(self.btnPlayPause)
            self.btnPlayPause.center = self.viewPlayer.center
            
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        self.player?.pause()
    }
    
    @IBAction func btnPlayPauseTapped(_ sender: Any) {
        if self.player?.timeControlStatus == .playing {
            self.player?.pause()
            self.btnPlayPause.setBackgroundImage(UIImage(named: "play"), for: .normal)
        }
        else {
            self.player?.play()
            self.btnPlayPause.setBackgroundImage(UIImage(named: "pause"), for: .normal)
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
