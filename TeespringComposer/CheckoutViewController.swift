//
// Created by Brian Brazil on 4/15/16.
// Copyright (c) 2016 Teespring. All rights reserved.
//

import UIKit

class CheckoutViewController : UIViewController {

    @IBOutlet var imageView : UIImageView!
    var image : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

}
