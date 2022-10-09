//
//  ViewController.swift
//  ImageClassifier
//
//  Created by Nikhil Jaggi on 09/10/21.
//

import UIKit

class MainController: UIViewController {

    var firstRun = true

   
    let imagePredictor = ImagePredictor()

   
    let predictionsToShow = 2
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonChoose: UIButton!
    @IBOutlet weak var viewPrediction: UIView!
    @IBOutlet weak var labelPrediction: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupViews()
    }

    
    @IBAction func chooseImageFunc(_ sender: Any) {
        
        showActionSheet()
        
        
    }
    
    func setupViews() {
        buttonChoose.layer.borderWidth = 0.5
        viewPrediction.layer.borderWidth = 0.5
        buttonChoose.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        viewPrediction.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        buttonChoose.layer.cornerRadius = buttonChoose.bounds.height/4
        viewPrediction.layer.cornerRadius = viewPrediction.bounds.height/4
    }
    
    func showActionSheet() {
        
        var actions: [(String, UIAlertAction.Style, UIColor)] = []
        actions.append(("Camera", UIAlertAction.Style.default, .black))
        actions.append(("Gallery", UIAlertAction.Style.default, .black))
        
        Alerts.showActionsheet(viewController: self, title: "Choose Image", message: nil, actions: actions) { [self] index in
            if index == 0 {
                //Show Camera
                // Show options for the source picker only if the camera is available.
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                    present(photoPicker, animated: false)
                    return
                }

                present(cameraPicker, animated: false)
            }
            else {
                //Show Gallery
                present(photoPicker, animated: false)
            }
        }
    }
}


extension MainController {
   
    func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

 
    func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
            self.labelPrediction.text = message.toUppercaseAtSentenceBoundary()
        }

        if firstRun {
            DispatchQueue.main.async {
                self.firstRun = false
                self.labelPrediction.superview?.isHidden = false

            }
        }
    }
   
    func userSelectedPhoto(_ photo: UIImage) {
        updateImage(photo)
        updatePredictionLabel("Making predictions for the photo...")

        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(photo)
        }
    }

}

extension MainController {
 
    private func classifyImage(_ image: UIImage) {
        do {
            try self.imagePredictor.makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

   
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }

        let formattedPredictions = formatPredictions(predictions)

        let predictionString = formattedPredictions.joined(separator: "\n")
        updatePredictionLabel(predictionString)
    }

   
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
      
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

          
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
