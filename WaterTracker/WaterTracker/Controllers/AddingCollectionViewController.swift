//
//  AddingCollectionViewController.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 04.07.2023.
//

import UIKit

private let reuseIdentifier = "AddingCell"

class AddingCollectionViewController: UICollectionViewController {
    
    
    
    let photos = ["100", "200", "250", "500", "1000"]
    let names = ["Shot glass", "Glass", "Cup", "Bottle", "Big bottle"]
    
    let paddingValue: CGFloat = 20
    let itemsPerRow: CGFloat = 1
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AddingCollectionViewCell
    
        cell.nameLabel.text = names[indexPath.row]
        cell.amountlabel.text = photos[indexPath.row] + " ml"
        cell.imageView.image = UIImage(named: photos[indexPath.row])
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = navigationController?.viewControllers.first as! MainViewController
        vc.addingAmount = Int(photos[indexPath.row])!
        
        navigationController?.popViewController(animated: true)
    }
    
   

}



extension AddingCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = paddingValue * (itemsPerRow + 1)
        let avaliableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avaliableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: paddingValue, left: paddingValue, bottom: paddingValue, right: paddingValue)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return paddingValue
    }

}
