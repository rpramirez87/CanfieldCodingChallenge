//
//  CanfieldImageProcessor.swift
//  CanfieldCodingChallenge
//
//  Created by Patrick Ramirez on 2/28/21.
//

import Foundation
import UIKit
import Vision
import CoreImage

class CanfieldImageProcessor {
    let subjectId : String
    let initialImage : CGImage
    var processedImage : UIImage?
    
    init?(subjectId: String, initialImage: CGImage) throws {

         // validation checks in here, throw an exception if initialization fails

        self.subjectId = subjectId
        self.initialImage = initialImage

        if subjectId == "" {
            throw ProcessorError.invalidSubjectId
        }
        
        // validate alphanumberic
        if !isAlphanumeric {
            throw ProcessorError.isNotAlphanumeric
        }

        // validate faces detected
        if !isFacesDetected {
            throw ProcessorError.noFaceDetected
        }

        // apply filter
        guard let filteredImage = applyFilter(radius: FilterSettings.radius, intensity: FilterSettings.intensity) else {
            throw ProcessorError.applyFilterError
        }

        // resize image
        guard let resizedImage = resizeImage(image: filteredImage, size: ImageSettings.size) else {
            throw ProcessorError.imageResizeError
        }

        // apply text
        guard let imageWithText = applyTextToImage(image: resizedImage) else {
            throw ProcessorError.imageTextError
        }
        
        processedImage = imageWithText
    }

    /// Validate subject id is alphanumeric
    var isAlphanumeric : Bool {

        let allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        let characterSet = CharacterSet(charactersIn: allowed)

        guard subjectId.rangeOfCharacter(from: characterSet.inverted) == nil else {
            return false
        }
        return true
    }

    /// Validate faces are detected within initial image
    var isFacesDetected : Bool {
        let ciImage = CIImage(cgImage: initialImage)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: ciImage)
        guard let faceDetectedCount = faces?.count, faceDetectedCount > 0 else {
            return false
        }
        
        return faceDetectedCount > 0
    }

    private func applyFilter(radius : NSNumber, intensity : NSNumber) -> UIImage? {

        let context = CIContext()
        let ciImage = CIImage(cgImage: initialImage)
        let currentFilter = CIFilter(name: "CIUnsharpMask")
        currentFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        currentFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        currentFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        
        guard let filteredOutputImage = currentFilter?.outputImage,
              let filteredCgImage = context.createCGImage(filteredOutputImage, from: filteredOutputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: filteredCgImage)
    }
    
    private func applyTextToImage(image : UIImage) -> UIImage? {
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        let textColor = UIColor.white
        let fontAttributes = [NSAttributedString.Key.font: textFont]
        let fontSize = (subjectId as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont, 
            NSAttributedString.Key.backgroundColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: textColor,
        ] as [NSAttributedString.Key : Any]
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        //Calculate text location based on font size
        let rect = CGRect(origin: CGPoint(x: image.size.width - fontSize.width - ImageSettings.margin, y: image.size.height - fontSize.height - ImageSettings.margin), size: image.size)
        subjectId.draw(in: rect, withAttributes: textFontAttributes)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func resizeImage(image: UIImage, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
