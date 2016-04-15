//
// Created by Brian Brazil on 4/14/16.
// Copyright (c) 2016 Teespring. All rights reserved.
//

import UIKit

class ZoomableMovableImageView : UIImageView {

    let panRec = UIPanGestureRecognizer()
    let pinchRec = UIPinchGestureRecognizer()
    let doubleTapRec = UITapGestureRecognizer()
    var x : CGFloat = 300
    var y : CGFloat = 300
    var width : CGFloat = 200
    var height : CGFloat = 200

    required init(coder decoder: NSCoder) {
        fatalError("not implemented")
    }

    override init(image: UIImage?) {
        super.init(image: image)
        self.clipsToBounds = true
        self.userInteractionEnabled = true
        self.contentMode = UIViewContentMode.ScaleAspectFit
        self.frame = CGRectMake(self.x,self.y,width,height)

        pinchRec.addTarget(self, action: #selector(ZoomableMovableImageView.pinchedView(_:)))
        self.addGestureRecognizer(pinchRec)

        panRec.addTarget(self, action: #selector(ZoomableMovableImageView.pannedView(_:)))
        self.addGestureRecognizer(panRec)

        doubleTapRec.numberOfTapsRequired = 2
        doubleTapRec.addTarget(self, action: #selector(ZoomableMovableImageView.doubleTapView(_:)))
        self.addGestureRecognizer(doubleTapRec)
    }

    func pinchedView(sender:UIPinchGestureRecognizer) {
        if (sender.state == .Began) {
            self.height = self.frame.height
            self.width = self.frame.width
        } else if (sender.state == .Ended) {
            self.x = scale_x(sender.scale)
            self.y = scale_y(sender.scale)
            self.width = self.frame.width
            self.height = self.frame.height
        } else {
            self.frame = CGRectMake(scale_x(sender.scale), scale_y(sender.scale), self.width * sender.scale, self.height * sender.scale)
            self.superview!.bringSubviewToFront(self)
        }
    }

    func pannedView(sender:UIPanGestureRecognizer) {
        if (sender.state == .Began) {
            self.x = self.frame.minX
            self.y = self.frame.minY
        } else if (sender.state == .Ended) {
            self.x = self.frame.minX
            self.y = self.frame.minY
        } else {
            let translation = sender.translationInView(self)
            self.frame = CGRectMake(self.x+translation.x, self.y+translation.y, self.width, self.height)
            self.superview!.bringSubviewToFront(self)
        }
    }

    func doubleTapView(sender:UITapGestureRecognizer) {
        let scale : CGFloat = 1.5
        self.x = scale_x(scale)
        self.y = scale_y(scale)
        self.width = self.width * scale
        self.height = self.height * scale
        self.frame = CGRectMake(x, y, width, height)
        self.superview!.bringSubviewToFront(self)
    }

    func scale_x(scale: CGFloat) -> CGFloat {
        return self.x-(((self.width * scale)-self.width)/2)
    }

    func scale_y(scale: CGFloat) -> CGFloat {
        return self.y-(((self.height * scale)-self.height)/2)
    }

}
