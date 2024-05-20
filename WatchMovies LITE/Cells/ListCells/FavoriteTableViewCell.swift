//
//  FavoriteTableViewCell.swift
//  test_movieList
//
//  Created by User on 03.02.2024.
//

import UIKit

struct GenreDetails {
    let genre: String
    var movies: [MovieDetails]
    var tvSeries: [TVSeriesDetails]
}


protocol FavoriteTableViewCellDelegate: AnyObject {
    func didSelectId(_ movie: MovieDetails)
    func didSelectId(_ tvSeries: TVSeriesDetails)
}

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var segmentIndex: Int = 0
    weak var delegate: FavoriteTableViewCellDelegate?
    
    var movieDetails: [MovieDetails] = [] {
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
        collectionView.backgroundColor = .white
    }
}

extension FavoriteTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetails.count
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movieDetails.isEmpty {
            let movie = movieDetails[indexPath.item]
            delegate?.didSelectId(movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        cell.fill(withData: movieDetails[indexPath.row])
        
        return cell
    }
}
