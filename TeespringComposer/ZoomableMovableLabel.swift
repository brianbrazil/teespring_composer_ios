//
// Created by Brian Brazil on 4/14/16.
// Copyright (c) 2016 Teespring. All rights reserved.
//

import UIKit

class ZoomableMovableLabel : UILabel, UIAlertViewDelegate {

    let panRec = UIPanGestureRecognizer()
    let pinchRec = UIPinchGestureRecognizer()
    let doubleTapRec = UITapGestureRecognizer()
    let longPressRec = UILongPressGestureRecognizer()
    var x : CGFloat = 300
    var y : CGFloat = 300
    var width : CGFloat = 200
    var height : CGFloat = 200

    required init(coder decoder: NSCoder) {
        fatalError("not implemented")
    }

    init(text: String) {
        super.init(frame: CGRectMake(self.x,self.y,0,0))
        print(UIFont.familyNames())
        self.text = text
        self.font = UIFont(name: "Helvetica", size: 24)
        self.userInteractionEnabled = true
        self.adjustsFontSizeToFitWidth = true
        self.width = attributedText!.size().width
        self.height = attributedText!.size().height
        self.frame = CGRectMake(self.x,self.y,width,height)

        pinchRec.addTarget(self, action: #selector(ZoomableMovableLabel.pinchedView(_:)))
        self.addGestureRecognizer(pinchRec)

        panRec.addTarget(self, action: #selector(ZoomableMovableLabel.pannedView(_:)))
        self.addGestureRecognizer(panRec)

        doubleTapRec.numberOfTapsRequired = 2
        doubleTapRec.addTarget(self, action: #selector(ZoomableMovableLabel.doubleTapView(_:)))
        self.addGestureRecognizer(doubleTapRec)

        longPressRec.addTarget(self, action: #selector(ZoomableMovableImageView.longPressView(_:)))
        self.addGestureRecognizer(longPressRec)
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
            adjustFontSizeToFitRect(self.frame)
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
        adjustFontSizeToFitRect(self.frame)
        self.superview!.bringSubviewToFront(self)
    }

    func longPressView(sender:UITapGestureRecognizer) {
        if (sender.state == .Began) {
            let alert = UIAlertView(title: "Remove this text?", message: "", delegate:self, cancelButtonTitle:"No", otherButtonTitles: "Yes")
            alert.show()

        }
    }

    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex > 0) {
            removeFromSuperview()
        }
    }

    func scale_x(scale: CGFloat) -> CGFloat {
        return self.x-(((self.width * scale)-self.width)/2)
    }

    func scale_y(scale: CGFloat) -> CGFloat {
        return self.y-(((self.height * scale)-self.height)/2)
    }

    func adjustFontSizeToFitRect(rect : CGRect) {
        if text == nil {
            return
        }
        frame = rect

        let maxFontSize: CGFloat = 100.0
        let minFontSize: CGFloat = 5.0
        let constraintSize = CGSize(width: rect.width, height: CGFloat.max)
        var q = Int(maxFontSize)
        var p = Int(minFontSize)

        while(p <= q) {
            let currentSize = (p + q) / 2
            font = font.fontWithSize( CGFloat(currentSize) )
            let text = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:font])
            let textRect = text.boundingRectWithSize(constraintSize, options: .UsesLineFragmentOrigin, context: nil)
            let labelSize = textRect.size

            if labelSize.height < frame.height && labelSize.height >= frame.height-10 && labelSize.width < frame.width && labelSize.width >= frame.width-10 {
                break
            }else if labelSize.height > frame.height || labelSize.width > frame.width{
                q = currentSize - 1
            }else{
                p = currentSize + 1
            }
        }
    }
}
