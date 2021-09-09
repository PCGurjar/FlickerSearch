//
//  FlickrViewModel.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 19/02/21.
//

import UIKit

class FlickrViewModel: NSObject {

    // Read only property
    private(set) var photoArray = [FlickrPhoto]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    
    var showAlert: ((String) -> Void)?
    var dataUpdated: (() -> Void)?
    
    
    func search(text: String, completion:@escaping () -> Void) {
        searchText = text
        photoArray.removeAll()
        fetchResults(completion: completion)
    }
    
    private func fetchResults(completion:@escaping () -> Void) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FlickrSearchService().request(searchText, pageNo: pageNo) { (result) in
        
            GCD.runOnMainThread {
            
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch result {
                case .Success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photoArray.append(contentsOf: result.photo)
                        self.dataUpdated?()
                    }
                    completion()
                case .Failure(let message):
                    self.showAlert?(message)
                    completion()
                case .Error(let error):
                    if self.pageNo > 1 {
                        self.showAlert?(error)
                    }
                    completion()
                }
            }
        }
    }
    
    func fetchNextPage(completion:@escaping () -> Void) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResults {
                completion()
            }
        } else {
            completion()
        }
    }
    
    func removeAllEelement() {
        self.photoArray.removeAll()
    }
    
}
