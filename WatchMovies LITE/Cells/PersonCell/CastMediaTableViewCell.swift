//
//  CastMediaTableViewCell.swift
//  WatchMovies LITE
//
//  Created by User on 06.05.2024.
//

import UIKit

protocol CastMediaTableViewCellDelegate: AnyObject {
    func didSelectMovieCast(_ movieCast: MovieCastMember)
    func didSelectTVSeriesCast(_ tvCast: TVSeriesMember)
}

class CastMediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var castMediaLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: CastMediaTableViewCellDelegate?
    
    var movieCast: [MovieCastMember] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var tvCast: [TVSeriesMember] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
    }
    
    func prepareUI() {
        castMediaLabel.font = UIFont.lotaBold(ofSize: 18)
        castMediaLabel.textColor = UIColor.orange
        castMediaLabel.text = "CAST MEMBER"
    }
}

extension CastMediaTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !movieCast.isEmpty {
            return movieCast.count
        } else {
            return tvCast.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !movieCast.isEmpty {
            let movieCaset = movieCast[indexPath.item]
            delegate?.didSelectMovieCast(movieCaset)
        } else if !tvCast.isEmpty {
            let tvSeriesCast = tvCast[indexPath.item]
            delegate?.didSelectTVSeriesCast(tvSeriesCast)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView cellForItemAt indexPath: \(indexPath.item)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell

        if !movieCast.isEmpty && indexPath.item < movieCast.count {
            let movieCast = movieCast[indexPath.item]
            cell.fill(withData: movieCast)
        } else if !tvCast.isEmpty && indexPath.item - movieCast.count < tvCast.count {
            let tvSeriesCast = tvCast[indexPath.item - movieCast.count]
            cell.fill(withData: tvSeriesCast)
        }
        return cell
    }
}
