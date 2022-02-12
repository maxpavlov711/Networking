//
//  ImageViewController.swift
//  Networking
//
//  Created by Max Pavlov on 9.02.22.
//

import UIKit

class ImageViewController: UIViewController {
    
    private let url = "https://img3.akspic.ru/originals/1/9/5/6/6/166591-bmw-legkovyye_avtomobili-sportkar-kompaktnyj_avtomobil-a_segmenta-1125x2436.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }

    func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage(url: url) { image in
            self.activityIndicator.stopAnimating()
            self.imageView.image = image
        }
    }
}
