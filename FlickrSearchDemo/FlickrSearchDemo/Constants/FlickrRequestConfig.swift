//
//  FlickrRequestConfig.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 20/02/21.
//

import UIKit

enum FlickrRequestConfig {
    
    case searchRequest(String, Int) // Associated type and values
    
    var value: Request? {
        
        switch self {
            
        case .searchRequest(let searchText, let pageNo):
            let urlString = String(format: FlickrConstants.searchURL, searchText, pageNo)
            let reqConfig = Request.init(requestMethod: .get, urlString: urlString)
            return reqConfig
        }
    }
}

