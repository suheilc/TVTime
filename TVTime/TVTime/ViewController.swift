//
//  ViewController.swift
//  TVTime
//
//  Created by Suheil on 08/09/23.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchResults: [TVShow] = []
    var currentAiredResult : [TVShow] = []
    var segmentVisibilityBool : Bool? = nil
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if(segmentVisibilityBool != nil)
        {
            segmentedControl.isHidden = segmentVisibilityBool!
        }
    }
    
    
    @IBAction func segmentTouch(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableView.reloadData()
        case 1:
            currentAiredResult = []
            let currentDate = Date()
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: currentDate)
            for searchResult in searchResults {
                if(searchResult.airtime != nil)
                {
                    let airedHour = searchResult.airtime!.components(separatedBy: ":")[0]
                    if(currentHour == Int(airedHour)) {
                        currentAiredResult.append(searchResult)
                    }
                }
            }
            if(currentAiredResult.count == 0)
            {
                DispatchQueue.main.async {
                    self.alert(message: "Currently no programs are being aired")
                    self.segmentedControl.selectedSegmentIndex = 0
                }
                return
            }
            tableView.reloadData()
        default:
            print("Default case")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MetaDataViewController
        let selectedShow = tableView.indexPathForSelectedRow!
        let index = segmentedControl.selectedSegmentIndex
        if(index == 0) {
            destination.showData = searchResults[selectedShow.row]
        }
        else if (index == 1) {
            destination.showData = currentAiredResult[selectedShow.row]
        }
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = segmentedControl.selectedSegmentIndex
        if(index == 0) {
            return searchResults.count
        }
        else if (index == 1) {
            return currentAiredResult.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = segmentedControl.selectedSegmentIndex
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TVShowTableViewCell
        if(index == 0) {
            cell.configure(with: searchResults[indexPath.row])
        }
        else if (index == 1) {
            cell.configure(with: currentAiredResult[indexPath.row])
        }
        return cell
    }
    
    
}

