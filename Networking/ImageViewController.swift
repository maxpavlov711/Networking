//
//  ImageViewController.swift
//  Networking
//
//  Created by Max Pavlov on 9.02.22.
//

import UIKit

class ImageViewController: UIViewController {
    
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
        
        guard let url = URL(string: "https://img3.akspic.ru/originals/1/9/5/6/6/166591-bmw-legkovyye_avtomobili-sportkar-kompaktnyj_avtomobil-a_segmenta-1125x2436.jpg") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in
           
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }
            }
        }.resume()
    }

}
