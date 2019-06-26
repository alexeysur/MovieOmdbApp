//
//  SearchTableViewCell.swift
//  MovieOMDbApp
//
//  Created by Alexey on 6/23/19.
//  Copyright © 2019 Alexey. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    private let networkService = NetworkService.shared()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(with info: JSON.Search.Movie){
        let activityView = UIActivityIndicatorView()
        activityView.style = .gray
        
        posterImageView.image = UIImage()
        posterImageView.clipsToBounds = true
        posterImageView.addSubview(activityView)
        posterImageView.layer.cornerRadius = 5
        activityView.center = posterImageView.center
        activityView.startAnimating()
        
        networkService.getImage(url: info.poster, handler: { [weak self] (data, error) in
            if let _data = data {
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    self?.posterImageView.image = UIImage(data: _data)
                    self?.posterImageView.contentMode = .scaleAspectFill
                }
            }
        })
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        nameLabel.text = info.title
        
        yearLabel.numberOfLines = 1
        yearLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        yearLabel.textColor = UIColor.gray
        yearLabel.text = "(\(info.year))"
        
        typeLabel.numberOfLines = 1
        typeLabel.text = info.type.capitalized
        typeLabel.textColor = UIColor.lightGray
        
    }
    
    
}
