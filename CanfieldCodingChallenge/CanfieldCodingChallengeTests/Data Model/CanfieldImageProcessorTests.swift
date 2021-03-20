//
//  ImageProcessorTests.swift
//  CanfieldCodingChallengeTests
//
//  Created by Patrick Ramirez on 2/28/21.
//

import XCTest
@testable import CanfieldCodingChallenge

class ImageProcessorTests: XCTestCase {
    
    var sut : CanfieldImageProcessor!
    
    override func setUp() {
        super.setUp()
        sut = CanfieldImageProcessor()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //Given
    func givenAlphanumericTestID() {
        sut.subjectID = "TEST123"
    }
    
    func givenNonAlphanumericTestID() {
        sut.subjectID = ""
    }
    
    //MARK:
    
    func testSubjectID_whenProcessorRestart_isUnset() {
        
        //Given
        givenAlphanumericTestID()
        
        //When
        sut.restart()
        
        //Then
        XCTAssertNil(sut.subjectID)
    }
    
    func testSubjectID_whenValidSubjectIDIsSet_isAlphanumeric() {
        
        //Given
        givenAlphanumericTestID()
        
        //Then
        XCTAssertTrue(sut.isAlphanumeric)
    }
    
    func testSubjectID_whenInvalidSubjectIDIsSet_isAlphanumeric() {
        
        //Given
        givenNonAlphanumericTestID()
        
        //Then
        XCTAssertFalse(sut.isAlphanumeric)
    }
    
    func testBeginImage_whenSystemImageIsSet_noFaceDetected() {
        //Given
        sut.beginImage = UIImage(systemName: "camera")?.cgImage
        
        //When
        let isFaceDetected = sut.isFacesDetected
        
        //Then
        XCTAssertFalse(isFaceDetected)
    }
    
    func testCanfieldImageProcessor_whenRestarted_restartsDataModel() {
        // Given
        givenAlphanumericTestID()
        
        // When
        sut.restart()
        
        // Then
        XCTAssertNil(sut.subjectID)
    }
}
