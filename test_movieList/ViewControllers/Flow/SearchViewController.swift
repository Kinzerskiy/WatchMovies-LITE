//
//  SearchViewController.swift
//  test_movieList
//
//  Created by User on 24.04.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var segmentBarView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var ganrePicker: UIPickerView!
    
    var currentSegmentIndex: Int = 0
    var movieGenres = [String]()
    var tvGenres = [String]()

    
    var router: SearchRouting?
    let navigationView = NavigationHeaderView.loadView()
    let filterView = FilterView.loadView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBar()
        prepareUI()
        prepareSegmenBar()
        updateGenrePicker()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func makeNavigationBar() {
        navigationItem.titleView = navigationView
        navigationView.titleName.isHidden = true
        navigationView.titleImage.contentMode = .scaleAspectFit
        navigationView.titleImage.image = UIImage(named: "Search")
        navigationView.backButton.isHidden = true
        navigationView.delegate = self
    }
    
    func prepareSegmenBar() {
        segmentBarView.addSubview(filterView)
        filterView.delegate = self
        let segmentTitles = ["Movie", "TV"]
        let font = UIFont.lotaBold(ofSize: 12)
        let color = UIColor.orange
        filterView.setSegmentTitles(titles: segmentTitles, font: font, color: color)
        
        filterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: segmentBarView.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: segmentBarView.leadingAnchor),
            filterView.bottomAnchor.constraint(equalTo: segmentBarView.bottomAnchor),
            filterView.trailingAnchor.constraint(equalTo: segmentBarView.trailingAnchor)
        ])
    }
    
    func prepareUI() {
        searchButton.layer.cornerRadius = 15
        searchButton.titleLabel?.text = "Search"
        searchButton.titleLabel?.font = UIFont.lotaBold(ofSize: 20)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        var years = [String]()
        for year in stride(from: currentYear, through: 1900, by: -1) {
            years.append(String(year))
        }
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPicker.selectRow(0, inComponent: 0, animated: true)
        
        ganrePicker.dataSource = self
        ganrePicker.delegate = self
        ganrePicker.selectRow(0, inComponent: 0, animated: true)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
    }
    
    @IBAction func didTapSwitch(_ sender: UISwitch) {
        let circleColor: UIColor = sender.isOn ? .white : .gray
        sender.thumbTintColor = circleColor
    }
}


extension SearchViewController: NavigationHeaderViewDelegate {
    func leftButtonTapped() { }
}

extension SearchViewController: FilterViewDelegate {
    func segment1() {
        currentSegmentIndex = 0
        updateGenrePicker()
    }
    
    func segment2() {
        currentSegmentIndex = 1
        updateGenrePicker()
    }
    
    func segment3() { }
    
    func segment4() { }
    
    func updateGenrePicker() {
        if currentSegmentIndex == 0 {
            movieGenres = MovieGenreID.allCases.map { genreID in
                switch genreID {
                case .action: return "Action"
                case .adventure: return "Adventure"
                case .animation: return "Animation"
                case .comedy: return "Comedy"
                case .crime: return "Crime"
                case .documentary: return "Documentary"
                case .drama: return "Drama"
                case .family: return "Family"
                case .fantasy: return "Fantasy"
                case .history: return "History"
                case .horror: return "Horror"
                case .music: return "Music"
                case .mystery: return "Mystery"
                case .romance: return "Romance"
                case .scienceFiction: return "Science Fiction"
                case .tvMovie: return "TV Movie"
                case .thriller: return "Thriller"
                case .war: return "War"
                case .western: return "Western"
                }
            }
            ganrePicker.reloadAllComponents()
        } else {
            tvGenres = TVGenreID.allCases.map { genreID in
                switch genreID {
                case .actionAdventure: return "Action & Adventure"
                case .animation: return "Animation"
                case .comedy: return "Comedy"
                case .crime: return "Crime"
                case .documentary: return "Documentary"
                case .drama: return "Drama"
                case .family: return "Family"
                case .kids: return "Kids"
                case .mystery: return "Mystery"
                case .news: return "News"
                case .reality: return "Reality"
                case .sciFiFantasy: return "Sci-Fi & Fantasy"
                case .soap: return "Soap"
                case .talk: return "Talk"
                case .warPolitics: return "War & Politics"
                case .western: return "Western"
                }
            }
            ganrePicker.reloadAllComponents()
        }
    }

}

extension SearchViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == yearPicker {
            let currentYear = Calendar.current.component(.year, from: Date())
            return currentYear - 1900 + 1
        } else if pickerView == ganrePicker {
            if currentSegmentIndex == 0 {
                return MovieGenreID.allCases.count
            } else {
                return TVGenreID.allCases.count
            }
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true

        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.lotaRegular(ofSize: 15)
        ]

        if pickerView == yearPicker {
            let currentYear = Calendar.current.component(.year, from: Date())
            let year = currentYear - row + 1
            if row == 0 {
                label.attributedText = NSAttributedString(string: "Select Year", attributes: attributes)
                label.backgroundColor = UIColor.white
                label.textColor = UIColor.orange
            } else {
                label.attributedText = NSAttributedString(string: "\(year)", attributes: attributes)
                label.backgroundColor = UIColor.orange
            }
        } else if pickerView == ganrePicker {
            if currentSegmentIndex == 0 {
                if row == 0 {
                    label.attributedText = NSAttributedString(string: "Select Genre", attributes: attributes)
                    label.backgroundColor = UIColor.clear
                    label.textColor = UIColor.orange
                } else if row < movieGenres.count {
                    label.attributedText = NSAttributedString(string: movieGenres[row], attributes: attributes)
                    label.backgroundColor = UIColor.orange
                }
            } else {
                if row == 0 {
                    label.attributedText = NSAttributedString(string: "Select Genre", attributes: attributes)
                    label.backgroundColor = UIColor.clear
                    label.textColor = UIColor.orange
                } else if row < tvGenres.count {
                    label.attributedText = NSAttributedString(string: tvGenres[row], attributes: attributes)
                    label.backgroundColor = UIColor.orange
                }
            }
        }
        return label
    }




    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == yearPicker {
            // Handle year selection
        } else if pickerView == ganrePicker {
            var genreID: String?
            if currentSegmentIndex == 0 {
                if row != 0 {
                    genreID = MovieGenreID.allCases[row - 1].rawValue
                }
            } else {
                if row != 0 {
                    genreID = TVGenreID.allCases[row - 1].rawValue
                }
            }
            // Use genreID for your request
        }
    }
}
