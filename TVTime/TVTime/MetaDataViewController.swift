//
//  MetaDataViewController.swift
//  TVTime
//
//  Created by Suheil on 09/09/23.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

class MetaDataViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var seasonVal: UILabel!
    @IBOutlet weak var runTimeVal: UILabel!
    @IBOutlet weak var channelVal: UILabel!
    @IBOutlet weak var summaryVal: UILabel!
    @IBOutlet weak var languageVal: UILabel!
    @IBOutlet weak var airTimeVal: UILabel!
    @IBOutlet weak var genreVal: UILabel!
    
    var showData : TVShow!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard showData != nil else
        {
            return
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(displaySummaryInAlert))
        summaryVal.isUserInteractionEnabled = true
        summaryVal.addGestureRecognizer(tap)
        updateMetaDataForShow()
        // Do any additional setup after loading the view.
    }
    @objc func displaySummaryInAlert(sender:UITapGestureRecognizer) {
        if(showData.show?.summary != nil)
        {
            let finalSummary = showData.show?.summary!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            if(finalSummary != nil)
            {
                alert(message: finalSummary!)
            }
        }
    }
    
    func updateMetaDataForShow()
    {
        titleLabel.text = showData.show?.name ?? "-"
        if(showData.season != nil)
        {
            seasonVal.text = String(showData.season!)
        }
        else
        {
            seasonVal.text = "-"
        }
        if(showData.show?.runtime != nil)
        {
            let runTimeNumber = String(showData.show!.runtime!)
            let runTimeText = "\(runTimeNumber) mins"
            runTimeVal.text = runTimeText
        }
        else
        {
            runTimeVal.text = "-"
        }
        channelVal.text = showData.show?.network?.name ?? "-"
        if(showData.show?.summary != nil)
        {
            let finalSummary = showData.show?.summary!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            summaryVal.text = finalSummary
        }
        languageVal.text = showData.show?.language ?? "-"
        airTimeVal.text = showData.airtime ?? "-"
        let genreArray = showData.show?.genres
        if(genreArray != nil)
        {
            if(genreArray!.count < 1)
            {
                genreVal.text = "-"
            }
            else
            {
                genreVal.text = genreArray!.joined(separator: ",")
            }
        }
        else
        {
            genreVal.text = "-"
        }
        guard let imgUrl = URL (string: showData.show?.image?.medium ?? "") else {
            DispatchQueue.main.async {
                self.showImage.image = UIImage(named: "no_image")
            }
            return
            
        }
        URLSession.shared.dataTask(with: imgUrl) { (data, response, error) in
            // Error handling...
            DispatchQueue.main.async {
                guard let imageData = data else {
                    self.showImage.image = UIImage(named: "no_image")
                    return
                }
                self.showImage.image = UIImage(data: imageData)
            }
        }.resume()
    }
}
