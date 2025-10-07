//
//  MovieCollectionViewCell.swift
//  GloboPlayChallenge
//
//  Created by ana on 02/10/25.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        
        
    }
    
    public func configure(with model: String) {
     
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else {
            return
        }
        posterImageView.kf.setImage(with: url)
    }
    
}
