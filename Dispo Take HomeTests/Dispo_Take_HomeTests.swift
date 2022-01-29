//
//  Dispo_Take_HomeTests.swift
//  Dispo Take HomeTests
//
//  Created by Borna Libertines on 28/01/22.
//

import XCTest
@testable import Dispo_Take_Home

class Dispo_Take_HomeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGifListViewModel(){
        let obj = GifObject(id: "10", title: "10", source_tld: "10", rating: "g", url: URL(string: "https://api.giphy.com"), images: nil)
        let gifListViewModel = GifCollectionViewCellViewModel(obj: obj)
        XCTAssertEqual(obj.rating, gifListViewModel.obj.rating, "rating")
        XCTAssertEqual(obj.id, gifListViewModel.obj.id, "id")
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
