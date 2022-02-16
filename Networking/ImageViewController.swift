//
//  ImageViewController.swift
//  Networking
//
//  Created by Max Pavlov on 9.02.22.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let url = "https://img3.akspic.ru/originals/1/9/5/6/6/166591-bmw-legkovyye_avtomobili-sportkar-kompaktnyj_avtomobil-a_segmenta-1125x2436.jpg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var compleredLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        compleredLabel.isHidden = true
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        progressView.isHidden = true
    }

    func fetchImage() {
 
        
        NetworkManager.downloadImage(url: url) { image in
            
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func fetchDataWithAlamofire() {
        
        AlamofireNetworkRequest.downloadImage(url: url) { image in
            
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
    
    func downloadImageWithProgress() {
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { completed in
            self.compleredLabel.isHidden = false
            self.compleredLabel.text = completed
        }
        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageUrl) { image in
            self.activityIndicator.stopAnimating()
            self.compleredLabel.isHidden = true
            self.progressView.isHidden = true
            self.imageView.image = image
            
        }
    }
}
