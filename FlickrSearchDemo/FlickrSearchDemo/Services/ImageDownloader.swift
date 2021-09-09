//
//  ImageDownloader.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 19/02/21.
//


import UIKit

typealias ImageClosure = (_ result: Result<UIImage>, _ url: String, _ isFromDirectory: Bool) -> Void


class ImageDownloader: NSObject {
    
    static let shared = ImageDownloader()
    
    private var operationQueue = OperationQueue()
    private var dictionaryBlocks = [UIImageView: (String, ImageClosure, ImageDownloadOperation)]()
    
    private override init() {
        operationQueue.maxConcurrentOperationCount = 100
    }
    
    func addOperation(url: String, imageView: UIImageView, completion: @escaping ImageClosure) {
        
        // if it is already in cache then no need to download
        if let image = DocumentDirectoryManager.getImage(name: url.components(separatedBy: "/").last!) {
            completion(.Success(image), url, true)
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                tupple.2.cancel()
            }
            
            // return from cache
        }else if let image = CacheManager.shared.getImageFromCache(key: url)  {
            
            completion(.Success(image), url, false)
            if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                tupple.2.cancel()
            }
            
        } else {
            
            if !checkOperationExists(with: url,completion: completion) {
            
                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                    tupple.2.cancel()
                }
                
                let newOperation = ImageDownloadOperation(url: url) { (image,downloadedImageURL) in
                
                    if let tupple = self.dictionaryBlocks[imageView] {
                    
                        if tupple.0 == downloadedImageURL {
                        
                            if let image = image {
                            
                                CacheManager.shared.saveImageToCache(key: downloadedImageURL, image: image)
                                tupple.1(.Success(image), downloadedImageURL, false)
                                
                                if let tupple = self.dictionaryBlocks.removeValue(forKey: imageView){
                                    tupple.2.cancel()
                                }
                                
                            } else {
                                tupple.1(.Failure("Not fetched"), downloadedImageURL, false)
                            }
                            
                            _ = self.dictionaryBlocks.removeValue(forKey: imageView)
                        }
                    }
                }
                
                dictionaryBlocks[imageView] = (url, completion, newOperation)
                operationQueue.addOperation(newOperation)
            }
        }
    }
    
    func checkOperationExists(with url: String, completion: @escaping ImageClosure) -> Bool {
        
        if let arrayOperation = operationQueue.operations as? [ImageDownloadOperation] {
            let opeartions = arrayOperation.filter{$0.url == url}
            return opeartions.count > 0 ? true : false
        }
        
        return false
    }
}
