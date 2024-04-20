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
    
    var similarMovies: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SimilarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimilarCollectionViewCell")
    }
}

extension SimilarTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarCollectionViewCell", for: indexPath) as! SimilarCollectionViewCell
        
        let similarMovie = similarMovies[indexPath.item]
        if let posterPath = similarMovie.posterPath {
            let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.posterImage.sd_setImage(with: posterUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        return cell
    }
}
