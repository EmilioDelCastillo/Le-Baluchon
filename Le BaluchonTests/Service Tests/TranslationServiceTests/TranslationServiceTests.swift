//
//  TranslationServiceTests.swift
//  Le BaluchonTests
//
//  Created by Emilio Del Castillo on 02/06/2022.
//

import XCTest

class TranslationServiceTests: XCTestCase {

    private var subject: TranslationService!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        subject = TranslationService(session: urlSession)
    }
    
    func testTranslate() async {
        let translationData = getData(name: "TranslationData")
        let textToTranslate = "dummy text"
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            if response.url == URLFactory.translate(text: textToTranslate, to: "EN") {
                return (response, translationData)
            }
            
            XCTFail("Wrong URL: \(response.url!)")
            throw TranslationServiceError.translationError
        }
        
        do {
            let translation = try await subject.translate(text: textToTranslate, to: "EN")
            XCTAssertEqual(translation.text, "This is genuine translated text.")
            XCTAssertEqual(translation.detectedSourceLanguage, "FR")
            
        } catch {
            XCTFail("An error was thrown: \(error)")
        }
    }
    
    func testTranslateFailing() async {
        let translationData = getData(name: "TranslationDataFailing")
        let textToTranslate = "dummy text"
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            if response.url == URLFactory.translate(text: textToTranslate, to: "EN") {
                return (response, translationData)
            }
            
            XCTFail("Wrong URL: \(response.url!)")
            throw TranslationServiceError.translationError
        }
        
        do {
            let _ = try await subject.translate(text: textToTranslate, to: "EN")
            XCTFail("An error should have been thrown.")
            
        } catch {
            XCTAssertEqual(error as! BaseServiceError, BaseServiceError.networkError)
        }
    }

}
