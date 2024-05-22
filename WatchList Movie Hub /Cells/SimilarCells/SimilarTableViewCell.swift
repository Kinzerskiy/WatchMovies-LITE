//
//  SimilarTableViewCell.swift
//  test_movieList
//
//  Created by User on 20.04.2024.
//

import UIKit

protocol SimilarTableViewCellDelegate: AnyObject {
    func didSelectSimilarMovie(_ movie: SimilarMovie)
    func didSelectSimilarTVSeries(_ tvSeries: SimilarTVSeries)
}

class SimilarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var similarLabel: UILabel!
    
    weak var delegate: SimilarTableViewCellDelegate?
    
    var similarMovie: [SimilarMovie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var similarTVSeries: [SimilarTVSeries] = [] {
        didSet {
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
        similarLabel.font = UIFont.lotaBold(ofSize: 20)
        similarLabel.textColor = UIColor.orange
        collectionView.backgroundColor = .white
    }
}

extension SimilarTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !similarMovie.isEmpty {
            return similarMovie.count
        } else {
            return similarTVSeries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !similarMovie.isEmpty {
            let movie = similarMovie[indexPath.item]
            delegate?.didSelectSimilarMovie(movie)
        } else if !similarTVSeries.isEmpty {
            let tvSeries = similarTVSeries[indexPath.item]
            delegate?.didSelectSimilarTVSeries(tvSeries)
        }
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
         
        if !similarMovie.isEmpty {
               let movie = similarMovie[indexPath.item]
               cell.fill(with: movie)
           } else if !similarTVSeries.isEmpty {
               let tvSeries = similarTVSeries[indexPath.item]
               cell.fill(with: tvSeries)
           }
           return cell
    }
 }
