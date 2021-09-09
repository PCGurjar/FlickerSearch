//
//  ImageModel.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 19/02/21.
//

import UIKit

struct ImageModel {

    let imageURL: String
    
    init(withPhotos photo: FlickrPhoto) {
        imageURL = photo.imageURL
    }
}
