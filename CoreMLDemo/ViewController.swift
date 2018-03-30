//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Carlos Herrera Somet on 29/3/18.
//  Copyright © 2018 Carlos H Somet. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageTaken: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageTaken.image = imageSelected
            
            guard let ciimage = CIImage(image: imageSelected) else { fatalError() }
            
            detect(image: ciimage)
        }
        
        dismiss(animated: true, completion: nil)
    }

   
    func detect(image: CIImage){
       
        do {
        
            let model = try VNCoreMLModel(for: Inceptionv3().model)
        
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                
                guard let results = request.results as? [VNClassificationObservation] else {fatalError("Model Failed to process image")}
            
             
                if let firstResult = results.first {
                    
                    self.navigationItem.title = firstResult.identifier
                }
                
            })
            
            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
                
                try handler.perform([request])
                
            } catch {
                print("Error handler: Could not perform action")
            }
            
            
        } catch {
            print ("Error creating model")
        }
        
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    

}

