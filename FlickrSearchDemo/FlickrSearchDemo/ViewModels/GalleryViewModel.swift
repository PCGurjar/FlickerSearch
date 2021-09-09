//
//  GalleryViewModel.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 21/02/21.
//

import UIKit

protocol GalleryViewModelDelegate {
    func didImagesFetched()
}

class GalleryViewModel: NSObject {
    
    // get all image from directory
    var arrAllImageNames = [String]()
    var delegate: GalleryViewModelDelegate?
    
    // MARK:- get all image from directory
    func getAllDirectoryImages() {
        if let allImages = DocumentDirectoryManager.getAllImageFromDirectory() {
            self.arrAllImageNames = allImages
            self.delegate?.didImagesFetched()
        }
    }
}
