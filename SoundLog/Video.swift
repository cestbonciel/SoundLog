//
//  Video.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/05.
//

import Foundation

struct Video: Decodable {
	var videoId = ""
	var title = ""
	var description = ""
	var thumbnail = ""
	var published = Date()
	
	enum CodingKeys: String, CodingKey {
		
		case snippet
		case thumbnails
		case high
		case resourceId
		
		case published = "publishedAt"
		case title
		case description
		case thumbnail = "url"
		case videoId
		
		
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
		
		self.videoId = try container.decode(String.self, forKey: .videoId)
		// Parse title
		self.title = try snippetContainer.decode(String.self, forKey: .title)
		// Parse description
		self.description = try snippetContainer.decode(String.self, forKey: .description)
//		self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
		// Parse published date
		self.published = try snippetContainer.decode(Date.self, forKey: .published)
		
		// Parse thumbnails
		let thumbnailContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
		
		let highContainer = try thumbnailContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
		
		self.thumbnail = try highContainer.decode(String.self, forKey: .thumbnail)
		
		// Parse VideoID
		let resourceIdContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
		
		self.videoId = try resourceIdContainer.decode(String.self, forKey: .videoId)
	}
}
