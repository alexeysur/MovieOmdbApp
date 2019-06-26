//
//  DetailTableViewController.swift
//  MovieOMDbApp
//
//  Created by Alexey on 6/24/19.
//  Copyright © 2019 Alexey. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imdbRateScoreLabel: UILabel!
    @IBOutlet weak var metascoreLabel: UILabel!
    
  
    @IBOutlet weak var directorCell: UITableViewCell!
    @IBOutlet weak var writerCell: UITableViewCell!
    @IBOutlet weak var plotCell: UITableViewCell!
    @IBOutlet weak var genreCell: UITableViewCell!
    
    
    private let networkService = NetworkService.shared()
    private var numberOfSections = 1
    
    var imdbID: String? {
        didSet{
            if let id = imdbID {
                loadMovie(withID: id)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI(){
        tableView.tableFooterView = UIView()
        navigationItem.title = "Movie Details"
        tableView.rowHeight = UITableView.automaticDimension
 
        for item in [plotCell, writerCell, genreCell, directorCell] {
            item?.textLabel?.numberOfLines = 0
            item?.textLabel?.lineBreakMode = .byWordWrapping
        }
   
        
        
        infoLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        infoLabel.minimumScaleFactor = 0.6
        infoLabel.adjustsFontSizeToFitWidth = true
   
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        nameLabel.textColor = UIColor.black
        
        yearLabel.textColor = UIColor.black
        yearLabel.numberOfLines = 1
        yearLabel.font = UIFont.preferredFont(forTextStyle: .body)
 
        
 }
 
    func loadMovie(withID id: String){
        networkService.getMovie(with: id) { [weak self] (movieObject, error) in
            if let movie = movieObject, error == nil {
                if movie.response.lowercased() ==  "true" {
                    self?.numberOfSections = 1
                    self?.setMovieInfo(with: movie)
                }else{
                    self?.numberOfSections = 0
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    self?.showAlert(title: "Message", message: "Could not find anything!")
                }
                
            }else{
                self?.numberOfSections = 0
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                self?.showAlert(title:"Error", message:  "Error")
                print(error?.localizedDescription ?? "Error")
            }
        }
    }
 
 
    func setMovieInfo(with movie: JSON.Movie){
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView()
            activityView.style = .gray
            self.tableView.backgroundView = UIView()
            
            self.posterImageView.image = UIImage()
            self.posterImageView.clipsToBounds = true
            self.posterImageView.addSubview(activityView)
            activityView.center = self.posterImageView.center
            activityView.startAnimating()
            
            self.networkService.getImage(url: movie.poster, handler: { [weak self] (data, error) in
                if let _data = data {
                    DispatchQueue.main.async {
                        activityView.stopAnimating()
                        activityView.removeFromSuperview()
                        self?.posterImageView.image = UIImage(data: _data)
                        self?.posterImageView.contentMode = .scaleAspectFill
                    }
                }
            })
            
            self.nameLabel.text = movie.title
            
            self.yearLabel.text = movie.year
            
            for label in [self.imdbRateScoreLabel, self.metascoreLabel ] {
                label?.textAlignment = .center
                label?.numberOfLines = 2
            }
            
            let defaultCalloutFont = UIFont.preferredFont(forTextStyle: .callout)
            
            var _title = NSAttributedString(string: "IMDB\n",
                                            attributes: [NSAttributedString.Key.font: UIFont.preferredBoldFont(forTextStyle: .callout) ?? defaultCalloutFont])
            var _value = NSAttributedString(string: movie.imdbRating,
                                            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.imdbRateScoreLabel.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "Metascore\n",
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredBoldFont(forTextStyle: .callout) ?? defaultCalloutFont ])
            _value = NSAttributedString(string: movie.metascore,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.metascoreLabel.attributedText = self.attributedString(from: [_title, _value])
            
            self.infoLabel.text = "\(movie.language) | \(movie.runtime)"
            
            
            _title = NSAttributedString(string: "Director: ",
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredBoldFont(forTextStyle: .callout) ?? defaultCalloutFont ])
            _value = NSAttributedString(string: movie.director,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.directorCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "Writer(s): ",
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredBoldFont(forTextStyle: .callout) ?? defaultCalloutFont ])
            _value = NSAttributedString(string: movie.writer,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.writerCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "Genre: ",
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredBoldFont(forTextStyle: .callout) ?? defaultCalloutFont ])
            _value = NSAttributedString(string: movie.genre,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .callout), NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.genreCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            
            _title = NSAttributedString(string: "Plot: ",
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredBoldFont(forTextStyle: .callout) ?? defaultCalloutFont ])
            _value = NSAttributedString(string: movie.plot,
                                        attributes: [NSAttributedString.Key.font: UIFont.preferredItalicFont(forTextStyle: .callout) ?? defaultCalloutFont, NSAttributedString.Key.foregroundColor: UIColor.gray])
            self.plotCell.textLabel?.attributedText = self.attributedString(from: [_title, _value])
            self.tableView.reloadData()

      }
    }

    func attributedString(from items: [NSAttributedString]) -> NSMutableAttributedString {
        let mutableAttributedString = NSMutableAttributedString()
        for item in items {
            mutableAttributedString.append(item)
        }
        
        return mutableAttributedString
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 130
        case 2:
            return 55
        default:
            return UITableView.automaticDimension
        }
    }


}
