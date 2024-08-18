//
//  TVShow.swift
//  TVTime
//
//  Created by Suheil on 09/09/23.
//

///Model class from MVVM architecture
///This struct decodes the JSON from the TVMaze API and converts it into the corresponding key
///Written by Suheil Babu C on 09Sep2023

import Foundation
struct TVShow: Codable {
    let id: Int?
    let airtime : String?
    var show : showPayload?
    let season : Int?
    
    // Add more properties as needed
}
struct showPayload: Codable {
    let name: String?
    let image : Image?
    let network : Network?
    let summary : String?
    let language : String?
    let genres : [String]?
    let runtime : Int?
}

struct Image : Codable {
    let medium : String?
}

struct Network : Codable {
    let name : String?
}
