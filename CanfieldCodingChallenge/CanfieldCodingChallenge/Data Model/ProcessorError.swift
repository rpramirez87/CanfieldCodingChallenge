//
//  ProcessorError.swift
//  CanfieldCodingChallenge
//
//  Created by Patrick Ramirez on 3/20/21.
//
import Foundation

public enum ProcessorError: Error {
  case invalidSubjectId
  case isNotAlphanumeric
  case noFaceDetected
  case applyFilterError
  case imageResizeError
  case imageTextError
}


extension ProcessorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidSubjectId:
            return NSLocalizedString("Please provide a valid subject id.", comment: "Text is null or empty.")
        case .isNotAlphanumeric:
            return NSLocalizedString("Please enter a valid alphanumeric subject id.", comment: "Text is not alphanumeric.")
        case .noFaceDetected:
            return NSLocalizedString("No face detected in image. Please try again.", comment: "No face detected.")
        case .applyFilterError:
            return NSLocalizedString("Error applying filter. Please try again.", comment: "Filter Error.")
        case .imageResizeError:
            return NSLocalizedString("Error resizing image. Please try again.", comment: "Image Resize Error.")
        case .imageTextError:
            return NSLocalizedString("Error applying text to image. Please try again", comment: "Image Text Error")
        }
    }
}

