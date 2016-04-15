//
//  ViewController.swift
//  TeespringComposer
//
//  Created by Brian Brazil on 4/14/16.
//  Copyright (c) 2016 Teespring. All rights reserved.
//


import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
}
