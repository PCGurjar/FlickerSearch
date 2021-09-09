//
//  Extension.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 19/02/21.
//

import UIKit

//MARK:- UICollectionView
extension UICollectionView {
    func register(nib nibName: String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}

//MARK:- UIImageView
extension UIImageView {
    
    func downloadImage(_ url: String, completion: @escaping (_ isSuccess: Bool, _ isInDirectory: Bool)-> Void) {
        
        ImageDownloader.shared.addOperation(url: url,imageView: self) {  [weak self](result,downloadedImageURL,isFromDirectory)  in
            GCD.runOnMainThread {
                switch result {
                case .Success(let image):
                    self?.image = image
                    completion(true, isFromDirectory)
                case .Failure(_):
                    completion(false, isFromDirectory)
                    break
                case .Error(_):
                    completion(false, isFromDirectory)
                    break
                }
            }
        }
    }
}


