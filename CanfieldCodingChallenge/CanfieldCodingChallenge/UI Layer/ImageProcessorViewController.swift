//
//  ViewController.swift
//  CanfieldCodingChallenge
//
//  Created by Patrick Ramirez on 2/28/21.
//

import UIKit

final class ImageProcessorViewController: UIViewController {

    let imagePickerController = UIImagePickerController()
    let defaultImage = UIImage(systemName: "camera")
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var subjectIDTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImagePicker()
    }
    
    // MARK: Setup
    ///Setup User Interface
    func setupUI() {
        activityIndicator.isHidden = true
        saveButton.isEnabled = false
    }
    
    func setupImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.allowsEditing = true
    }
    
    // MARK: Actions
    @IBAction func captureImage(_ sender: UIButton) {

        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "Error", message: "You don't have a camera")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.cameraDevice = .front
        present(imagePickerController, animated: true, completion: nil)
    }
 
    @IBAction func saveImage(_ sender: UIButton) {
        guard let image = imageView.image else {
            showAlert(title: "Error", message: "No Image found.")
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: Save Image

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlert(title: "Save Error", message: error.localizedDescription)
        } else {
            reset()
            showAlert(title: "Saved", message: "Processed image has been saved to library.")
        }
    }
    
    func reset() {
        subjectIDTextField.text = nil
        imageView.image = defaultImage
        saveButton.isEnabled = false
    }
    
    // MARK: Activity Indicator
    
    func showIndicator() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    func hideIndicator() {
        activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    // MARK: Alerts
    func showAlert(title : String, message : String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension ImageProcessorViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = UIImage(systemName: "camera")
        picker.dismiss(animated: true)
        
        //Add required delay
        showIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let pickImage = info[.editedImage] as? UIImage,
               let cgImage = pickImage.cgImage {

                do {
                    let imageProcessor = try CanfieldImageProcessor(subjectId: self.subjectIDTextField.text ?? "", initialImage: cgImage)
                    self.imageView.image = imageProcessor?.processedImage
                    self.saveButton.isEnabled = true
                    self.hideIndicator()
                } catch {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    self.hideIndicator()
                }
            } else {
                self.showAlert(title: "Error", message: "Error selecting image.")
                self.hideIndicator()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

