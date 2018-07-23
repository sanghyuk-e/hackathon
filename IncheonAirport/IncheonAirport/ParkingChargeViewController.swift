//
//  ParkingDetailViewController.swift
//  IncheonAirport
//
//  Created by sanghyuk on 2018. 7. 20..
//  Copyright © 2018년 sanghyuk. All rights reserved.
//

import UIKit

class ParkingChargeViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
//    @IBOutlet private weak var imageView: UIImageView!
    let imageView = UIImageView(image: UIImage(named: "parkingCharge.jpeg"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = scrollView.bounds.size
        
        scrollView.contentSize.height = imageView.bounds.size.height
    }
}
