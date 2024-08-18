//
//  TVShowTableViewCell.swift
//  TVTime
//
//  Created by Suheil on 08/09/23.
//

import Foundation
import UIKit

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    func configure(with show: TVShow) {
        titleLabel.text = show.show?.name
        detailLabel.text = show.airtime
    }
}
