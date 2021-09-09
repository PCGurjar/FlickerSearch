//
//  FlickrSearchViewController.swift
//  FlickrSearchDemo
//
//  Created by Poonamchand on 20/02/21.
//

import UIKit

class FlickrSearchViewController: UIViewController {
    
    @IBOutlet weak var lblSearching: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel = FlickrViewModel()

    // to handle cancel
    var workItemReference: DispatchWorkItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        viewModelClosures()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showAlert(title: String = "Flickr", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}

//MARK:- Configure UI
extension FlickrSearchViewController {
    
    fileprivate func configureUI() {
        // Do any additional setup after loading the view, typically from a nib.
        setSearchBar()
        self.lblSearching.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib: ImageCollectionViewCell.nibName)
    }
    
    // MARK:- Set search bar data
    func setSearchBar() {
        self.searchBar.isUserInteractionEnabled = true
        self.searchBar.delegate = self
    }
}


//MARK:- Clousers
extension FlickrSearchViewController {
    
    fileprivate func viewModelClosures() {
        viewModel.showAlert = { [weak self] (message) in
            self?.showAlert(message: message)
        }
        
        viewModel.dataUpdated = { [weak self] in
            print("data source updated")
            self?.lblSearching.isHidden = true
            
            self?.collectionView.reloadData()
        }
    }
    
    private func loadNextPage() {
        viewModel.fetchNextPage {
            print("next page fetched")
        }
    }
}



// MARK:- search bar delegates
extension FlickrSearchViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.endEditing(true)
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // cancel previous task
        workItemReference?.cancel()
        
        let workItem = DispatchWorkItem {
            self.searchImageOnTextChange()
        }
        
        workItemReference = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: workItemReference!)
    }
    
    
    // This is for searching
    private func searchImageOnTextChange() {
        guard let text = searchBar.text, text.count > 1 else {
            // cancel network manager
            NetworkManager.shared.cancelTask()
            self.lblSearching.isHidden = true
            self.viewModel.removeAllEelement()
            collectionView.reloadData()
            return
        }
        
        collectionView.reloadData()
        self.lblSearching.isHidden = false
        
        viewModel.search(text: text) {
            print("search completed.")
        }
    }

}


//MARK:- UICollectionViewDataSource
extension FlickrSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.nibName, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        
        let model = viewModel.photoArray[indexPath.row]
        cell.model = ImageModel.init(withPhotos: model)
        
        if indexPath.row == (viewModel.photoArray.count - 10) {
            loadNextPage()
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FlickrSearchViewController: UICollectionViewDelegateFlowLayout {
    
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


