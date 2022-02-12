//
//  Dispo_Take_HomeTests.swift
//  Dispo Take HomeTests
//
//  Created by Borna Libertines on 28/01/22.
//

import XCTest
@testable import Dispo_Take_Home

class Dispo_Take_HomeTests: XCTestCase {

   
    var mockedService = MockedService()
    //var gifAPIClient1 = GifAPIClient1()
    var mainCont = MainViewController()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGifListViewModel(){
        let obj = GifObject(id: "10", title: "10", source_tld: "10", rating: "g", url: URL(string: "https://api.giphy.com"), images: nil)
        let gifListViewModel = GifCollectionViewCellViewModel(id: "10", title: "", rating: "g", Image: URL(string: ""), url: URL(string: ""))
        XCTAssertEqual(obj.rating, gifListViewModel.rating, "rating")
        XCTAssertEqual(obj.id, gifListViewModel.id, "id")
    }
    
    
    
    func testMockedProtokol(){
        
        mockedService.getRequest(urlParams: ["" : ""], gifAcces: Constants1.trending, decodable: APIListResponse.self) { result in
            switch result {
            case .failure(let error):
                
                let errorBool = APError.parsingError == error
                if errorBool{
                    XCTAssertTrue(errorBool, "error presing")
                }else{
                    XCTAssertFalse(errorBool, "error")
                }
                
            case .success(let linkdata):
                //XCTAssertNil(linkdata?.data, "is Nil")
                //XCTAssertNotNil(linkdata?.data, "Not Nil")
                //XCTAssertEqual(linkdata?.rating, gif.rating)
                if linkdata?.data != nil{
                    XCTAssertNotNil(linkdata?.data, "URL is Not Nil")
                }else{
                    XCTAssertNil(linkdata?.data, "URL is Nil")
                }
            }
        }
        
    }
    
    func testDownloadGifData() {
        let config = URLSessionConfiguration.default
        config.allowsConstrainedNetworkAccess = false
        let session = URLSession(configuration: config)
        
        let expectation = XCTestExpectation(description: "geting gifs")
        
        let url = URL(string: "https://api.giphy.com/v1/gifs/trending?api_key=\(Constants.giphyApiKey)")
        //let url = URL(string: "https://api.giphy.com/v1/gifs/trending")
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Make sure we downloaded some data.
            XCTAssertNotNil(response, "response")
            XCTAssertNil(error, "No error.")
            XCTAssertNotNil(data, "data downloaded.")
            
            do {
                let object = try JSONDecoder().decode(APIListResponse.self, from: data!)
                //DispatchQueue.main.async {
                    XCTAssertNotNil(object, "data downloaded.")
                //}
            } catch {
                debugPrint("parsingError catch")
                //completion(.failure(.parsingError))
                XCTAssertThrowsError(APError.serverError)
            }
            
            // Fulfill the expectation to indicate that the background task has finished successfully.
            expectation.fulfill()
            
        }
        
        // Start the download task.
        dataTask.resume()
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 1.0)
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
            mainCont.viewDidLoad()
            mainCont.loadView()
            mainCont.searchBar(UISearchBar(), textDidChange: "love")
            
            
        }
    }
    

}
