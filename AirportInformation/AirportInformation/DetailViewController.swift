//
//  DetailViewController.swift
//  AirportInformation
//
//  Created by kimdaeman14 on 2018. 7. 20..
//  Copyright © 2018년 GoldenShoe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView:UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize.height = view.bounds.height 

        
        
    }

   

}
