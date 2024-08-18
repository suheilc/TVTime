//
//  SearchViewController.swift
//  TVTime
//
//  Created by Suheil on 09/09/23.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var searchBar: UISearchBar!
    let viewModel = TVApiViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchTVShows(query: searchText)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchTVShows(query: String) {
        let searchApiRequest = "/search/shows?q=\(query)"
        
        viewModel.fetchTVSchedule(searchApiRequest) { tvShows in
            DispatchQueue.main.async { [self] in
                if(tvShows == nil || tvShows?.count == 0)
                {
                    self.alert(message: "No TV shows available in the name \(query)")
                    return
                }
                if let presentedViewController = self.presentedViewController {
                    presentedViewController.dismiss(animated: false) {
                        self.presentResultsViewController(tvShows,true)
                    }
                } else {
                    self.presentResultsViewController(tvShows,true)
                }
            }
        }
        
    }
    
    
    @IBAction func dateSearchBtn(_ sender: Any) {
        searchDateTVShows()
    }
    
    func searchDateTVShows() {
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "h:mm a"
        let dateSearchString = dateFormatter.string(from: datePicker.date)
        let timeSearchString = timeFormatter.string(from: datePicker.date)
        let date = timeFormatter.date(from: timeSearchString)
        dateFormatter.dateFormat = "HH:mm"
        let searchTime = dateFormatter.string(from: date!)
        let searchTimeHour = searchTime.components(separatedBy: ":")[0]
        let searchApiRequest = "/schedule?date=\(dateSearchString)"
        var dateSearchTVShows : [TVShow] = []
        viewModel.fetchTVSchedule(searchApiRequest) { tvShows in
            DispatchQueue.main.async { [self] in
                if(tvShows == nil || tvShows?.count == 0)
                {
                    self.alert(message: "Sorry, something went wrong. No TV shows available")
                    return
                }
                for tvSearchResult in tvShows! {
                    if(tvSearchResult.airtime != nil)
                    {
                        let airedHour = tvSearchResult.airtime!.components(separatedBy: ":")[0]
                        if(Int(searchTimeHour) == Int(airedHour)) {
                            dateSearchTVShows.append(tvSearchResult)
                        }
                    }
                }
                if(dateSearchTVShows.count == 0)
                {
                    self.alert(message: "No TV shows available at the selected time")
                    return
                }
                if let presentedViewController = self.presentedViewController {
                    presentedViewController.dismiss(animated: false) {
                        self.presentResultsViewController(dateSearchTVShows,true)
                    }
                } else {
                    self.presentResultsViewController(dateSearchTVShows,true)
                }
            }
        }
    }
    
    @IBAction func onCurrentAirBtnClick(_ sender: Any) {
        currentAiredTVShows()
    }
    
    func currentAiredTVShows() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDateStr = formatter.string(from: currentDate)
        
        let searchApiRequest = "/schedule?country=US&date=\(currentDateStr)"
        
        viewModel.fetchTVSchedule(searchApiRequest) { tvShows in
            DispatchQueue.main.async { [self] in
                if(tvShows == nil || tvShows?.count == 0)
                {
                    self.alert(message: "Sorry, something went wrong. No TV shows available")
                    return
                }
                if let presentedViewController = self.presentedViewController {
                    presentedViewController.dismiss(animated: false) {
                        self.presentResultsViewController(tvShows,false)
                    }
                } else {
                    self.presentResultsViewController(tvShows,false)
                }
            }
        }
    }
    
    
    func presentResultsViewController(_ tvShows : [TVShow]?,_ hideSegmentControl : Bool) {
        DispatchQueue.main.async { [self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resultsViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            if(tvShows != nil)
            {
                resultsViewController.searchResults = tvShows!
                resultsViewController.segmentVisibilityBool = hideSegmentControl
            }
            self.navigationController?.pushViewController(resultsViewController, animated: true)
        }
    }
    
}
