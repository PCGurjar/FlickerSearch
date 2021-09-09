//
//  Photos.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 19/02/21.
//


import UIKit

struct Photos: Codable {
    
    let page: Int
    let pages: Int
    let perpage: Int
    let photo: [FlickrPhoto]
    let total: String
    
}
