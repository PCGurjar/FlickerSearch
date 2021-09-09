//
//  DocumentDirectoryManager.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 21/02/21.
//

import UIKit

class DocumentDirectoryManager {
    
    class func getAllImageFromDirectory()-> [String]? {
        let fileMngr = FileManager.default;
            
        // Full path to documents directory
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        return try? fileMngr.contentsOfDirectory(atPath:docs)
    }
    
    class func saveImage(_ image: UIImage, name: String) {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // choose a name for your image
        let fileName = name
        
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image.pngData() {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
    class func getImage(name: String)-> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
            return UIImage(contentsOfFile: imageURL.path)
            // Do whatever you want with the image
        }
        return nil
    }
    
    class func removeImage(name: String) {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // choose a name for your image
        let fileName = name
        
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // get your UIImage jpeg data representation and check if the destination file url already exists
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
}
