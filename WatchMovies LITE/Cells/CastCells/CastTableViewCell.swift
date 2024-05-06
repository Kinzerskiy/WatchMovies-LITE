//
//  CastTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 06.05.2024.
//

import UIKit

protocol CastTableViewCellDelegate: AnyObject {
    func didselsectCredential(with id: Int)
}

class CastTableViewCell: UITableViewCell {

    @IBOutlet weak var castAndCrewLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: CastTableViewCellDelegate?
    
    var movieCast: [MovieCast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var tvSeriesCast: [TVSeriesCast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CastCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CastCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        castAndCrewLabel.font = UIFont.lotaBold(ofSize: 18)
        castAndCrewLabel.textColor = UIColor.orange
    }
    
}

extension CastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !movieCast.isEmpty {
            return movieCast.count
        } else {
            return tvSeriesCast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movieCast.isEmpty {
            let cast = movieCast[indexPath.item]
            delegate?.didselsectCredential(with: cast.id)
        } else if !tvSeriesCast.isEmpty {
            let cast = tvSeriesCast[indexPath.item]
            delegate?.didselsectCredential(with: cast.id)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 150, height: 250)
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 10
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         print("collectionView cellForItemAt indexPath: \(indexPath.item)")
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCollectionViewCell", for: indexPath) as! CastCollectionViewCell
         
        if !movieCast.isEmpty {
               let cast = movieCast[indexPath.item]
               cell.fill(with: cast)
           } else if !tvSeriesCast.isEmpty {
               let cast = tvSeriesCast[indexPath.item]
               cell.fill(with: cast)
           }
           return cell
    }
 }
