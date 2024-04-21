//
//  SimilarTableViewCell.swift
//  test_movieList
//
//  Created by User on 20.04.2024.
//

import UIKit

class SimilarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var similarLabel: UILabel!
    
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
        
    }
}

extension SimilarTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let delegate = collectionView.delegate {
            print("UICollectionView delegate is set \(String(describing: collectionView.delegate))")
        } else {
            print("UICollectionView delegate is nil")
        }
        print("Similar movies count: \(similarMovies.count)")
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         print("collectionView cellForItemAt indexPath: \(indexPath.item)")
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as! SimilarCollectionViewCell
         
         let similarMovie = similarMovies[indexPath.item]
         cell.fill(with: similarMovie)
         
         return cell
    }
 }
