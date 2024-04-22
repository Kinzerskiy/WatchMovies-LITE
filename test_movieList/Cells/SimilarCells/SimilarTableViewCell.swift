//
//  SimilarTableViewCell.swift
//  test_movieList
//
//  Created by User on 20.04.2024.
//

import UIKit

protocol SimilarTableViewCellDelegate: AnyObject {
    func didSelectSimilarMovie(_ movie: SimilarMovie)
}

class SimilarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var similarLabel: UILabel!
    
    weak var delegate: SimilarTableViewCellDelegate?
    
    var similarMovies: [SimilarMovie] = [] {
        didSet {
            print("Did set similarMovies. Count: \(similarMovies.count)")
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        similarLabel.font = UIFont.lotaBold(ofSize: 18)
        similarLabel.textColor = UIColor.orange
    }
}

extension SimilarTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = similarMovies[indexPath.item]
        delegate?.didSelectSimilarMovie(selectedMovie)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: 160, height: 240)
      }
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 10
      }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         print("collectionView cellForItemAt indexPath: \(indexPath.item)")
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as! SimilarCollectionViewCell
         
         let similarMovie = similarMovies[indexPath.item]
         cell.fill(with: similarMovie)
         
         return cell
    }
 }
