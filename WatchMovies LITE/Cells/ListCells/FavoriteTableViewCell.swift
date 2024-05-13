//
//  FavoriteTableViewCell.swift
//  test_movieList
//
//  Created by User on 03.02.2024.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
  
       var favorites: [Favorites] = [] {
           didSet {
               collectionView.reloadData()
           }
       }
    
    var genre: String? {
           didSet {
               genreLabel.text = genre
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.showsVerticalScrollIndicator = false
        genreLabel.font = UIFont.lotaBold(ofSize: 18)
        genreLabel.textColor = UIColor.orange
  
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}

extension FavoriteTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 160, height: 240)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        
        let favorite = favorites[indexPath.item]
        cell.fill(withData: favorite)
        
        
        return cell
    }
}
