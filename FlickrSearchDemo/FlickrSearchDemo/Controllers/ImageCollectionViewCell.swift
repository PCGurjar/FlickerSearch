//
//  ImageCollectionViewCell.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 20/02/21.
//

import UIKit

protocol ImageCollectionViewCellDelegate {
    func didDeleteDocument(name: String)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    static let nibName = "ImageCollectionViewCell"
    var isGallery = false
    var delegate: ImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnSave.isHidden = true
        self.btnDelete.isHidden = true
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    
    
    // this is for search
    var model: ImageModel? {
        didSet {
            if let model = model {
                self.btnSave.isHidden = true
                self.btnDelete.isHidden = true
                imageView.image = UIImage(named: "placeholder")
                imageView.downloadImage(model.imageURL) { (isDownload, isInDirectory) in
                    // show save button here
                    if isInDirectory {
                        self.btnSave.isHidden = true
                        self.btnDelete.isHidden = false
                    }else{
                        self.btnSave.isHidden = false
                        self.btnDelete.isHidden = true
                    }
                }
            }
        }
    }
    

    // when show image in gallery controller
    var imageFromDirectory: String? {
        didSet {
            self.btnSave.isHidden = true
            self.btnDelete.isHidden = true
            imageView.image = UIImage(named: "placeholder")
            
            if let name = imageFromDirectory {
                DispatchQueue.global().async { [weak self] in
                    if let image = DocumentDirectoryManager.getImage(name: name){
                        DispatchQueue.main.async {
                            // save in cache
                            self?.imageView.image = image
                            self?.btnDelete.isHidden = false
                        }
                    }
                }
            }
        }
    }

    
    @IBAction func deleteBtnClick(_ sender: Any) {
        if isGallery {
            if let name = imageFromDirectory {
                DocumentDirectoryManager.removeImage(name: name)
                self.btnSave.isHidden = false
                self.btnDelete.isHidden = true
                self.delegate?.didDeleteDocument(name: name)
            }
        }else{
            if let model = model {
                if let name = model.imageURL.components(separatedBy: "/").last {
                    DocumentDirectoryManager.removeImage(name: name)
                    self.btnSave.isHidden = false
                    self.btnDelete.isHidden = true
                }
            }
        }
        
    }
    
    @IBAction func saveBtnClick(_ sender: Any) {
        if let model = model {
            if let name = model.imageURL.components(separatedBy: "/").last {
                if let image = self.imageView.image {
                    DocumentDirectoryManager.saveImage(image, name: name)
                    self.btnSave.isHidden = true
                    self.btnDelete.isHidden = false
                }
            }
        }
    }
}
