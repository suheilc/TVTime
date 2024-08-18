//
//  TVApiViewModel.swift
//  TVTime
//
//  Created by Suheil on 08/09/23.
//

///ViewModel class from MVVM architecture
///This class sends the request to the TVMaze API and passes it to the TVShow struct to convert it into corresponding keys
///Written by Suheil Babu C on 08/09/2023
import Foundation

class TVApiViewModel {
    
    func fetchTVSchedule(_ apiUrl : String,completion: @escaping ([TVShow]?) -> Void) {
        DispatchQueue.main.async { [self] in
            fetchTVShows(apiUrl) { tvShows in
                if let tvShows = tvShows {
                    //self?.shows = tvShows
                    completion(tvShows)
                    return
                }
                completion(nil)
            }
        }
        
    }
    
    func fetchTVShows(_ apiUrl : String,completion: @escaping ([TVShow]?) -> Void) {
        let tvMazeURL = "https://api.tvmaze.com"
        guard let apiURL = URL(string: tvMazeURL+apiUrl)
        else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if error != nil {
                //print("Error fetching TV shows: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                //print("No data received from the server.")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // If TVMaze returns an array of TV shows, you can decode it like this:
                let tvShows = try decoder.decode([TVShow].self, from: data)
                completion(tvShows)
            } catch {
                //debugPrint(error)
                //print("Error decoding TV shows: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
