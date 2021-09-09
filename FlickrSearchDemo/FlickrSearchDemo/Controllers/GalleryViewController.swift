//
//  GalleryViewController.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 21/02/21.
//

import UIKit

class GalleryViewController: UIViewController, GalleryViewModelDelegate {
    
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let galleryVm = GalleryViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        galleryVm.delegate = self
        galleryVm.getAllDirectoryImages()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // view model delegates
    func didImagesFetched() {
        handleEmptyLabel ()
        self.collectionView.reloadData()
    }
    

    fileprivate func configureUI() {
        // Do any additional setup after loading the view, typically from a nib.
        handleEmptyLabel ()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib: ImageCollectionViewCell.nibName)
    }
    
    func handleEmptyLabel () {
        if galleryVm.arrAllImageNames.count == 0 {
            lblEmpty.isHidden = false
        }else{
            lblEmpty.isHidden = true
        }
    }

}


//MARK:- UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryVm.arrAllImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.nibName, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = nil
        cell.isGallery = true
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        
        cell.imageFromDirectory = galleryVm.arrAllImageNames[indexPath.row]
    }

}

//MARK: - UICollectionViewDelegateFlowLayout
extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width;
        var itemWidth = collectionWidth / 3 - 1;
        
        if(UI_USER_INTERFACE_IDIOM() == .pad) {
            itemWidth = collectionWidth / 4 - 1;
        }
        return CGSize(width: itemWidth, height: itemWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}



extension GalleryViewController : ImageCollectionViewCellDelegate {
    func didDeleteDocument(name: String) {
        self.galleryVm.arrAllImageNames = self.galleryVm.arrAllImageNames.filter({ (nameIn) -> Bool in
            return nameIn != name
        })
        handleEmptyLabel ()
        self.collectionView.reloadData()
    }
}
