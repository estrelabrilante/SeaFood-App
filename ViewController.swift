//
//  ViewController.swift
//  SeaFoodAppML
//
//  Created by user215496 on 11/16/22.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let imagepicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //set properties of imagepicker
        imagepicker.delegate = self
       // imagepicker.sourceType = .camera
        imagepicker.sourceType = .photoLibrary
        imagepicker.allowsEditing = false
    }
    //MARK: - delgate method(U
    //user has picked image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUserPicked = info[.originalImage] as? UIImage{
            //set imageView background
            imageView.image = imageUserPicked
            //convert into CIImage
            guard let ciimage = CIImage(image: imageUserPicked) else{
                fatalError("Can't convert UIImage into CIImage")
            }
            detect(image: ciimage)
            
        }
        imagepicker.dismiss(animated: true)
    }
    //CIImage passed into this func
    func detect(image: CIImage){
       guard let model = try? VNCoreMLModel(for: Inceptionv3().model)
                else
        {fatalError("loading CoreMl is failed")}
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError(
                "Model failed to process data")
            }
            print(results)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }
        catch{print(error)}
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //user can pick image from Album or Camera
        present(imagepicker, animated: true)
        
    }
    
}

