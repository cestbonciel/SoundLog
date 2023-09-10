//
//  Model.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/05.
//

import Foundation

class Model {
//	func getVideos() {
//		// Create a URL object
//		let url = URL(string: Constants.API_URL)
//		
//		guard url != nil else {
//			return
//		}
//		// Get a URLSession object
//		let session = URLSession.shared
//		
//		// Get a data task from the URLSession object
//		let dataTask = session.dataTask(with: url!) { data, response, error in
//			
//			if error != nil || data == nil {
//				return
//			}
//			do {
//				// Parsing the data into video objects
//				let decoder = JSONDecoder()
//				// representation Date and time
//				decoder.dateDecodingStrategy = .iso8601
//				
//				let response = try decoder.decode(Response.self, from: data!)
//				
//				dump(response)
//			}
//			catch {
//				
//			}
//			
//		}
//		// kick off the task
//		dataTask.resume()
//	}
}
