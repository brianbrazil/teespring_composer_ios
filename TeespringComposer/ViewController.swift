//
//  ViewController.swift
//  TeespringComposer
//
//  Created by Brian Brazil on 4/14/16.
//  Copyright (c) 2016 Teespring. All rights reserved.
//


import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var whiteTeeImageView : UIImageView!
    @IBOutlet var textField : UITextField!

    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

    @IBAction func findPhoto() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary

        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .Camera

        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.view.addSubview(ZoomableMovableImageView(image: image))
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func createText() {
        if let text = textField.text {
            self.view.endEditing(true)
            textField.text = nil
            self.view.addSubview(ZoomableMovableLabel(text: text))
        }
    }
    
    @IBAction func screenshot() {
        whiteTeeImageView.hidden = true
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(385,580), false, 0);
        self.view.drawViewHierarchyInRect(CGRectMake(-193,-195,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
//        view.addSubview(ZoomableMovableImageView(image: image))
        whiteTeeImageView.hidden = false
        self.performSegueWithIdentifier("GoToCheckout", sender: image)
    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "GoToCheckout") {
            let checkoutViewController = segue.destinationViewController as! CheckoutViewController
            let image = sender as! UIImage
            checkoutViewController.image = image
        }
    }
}
