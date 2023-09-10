//
//  Constants.swift
//  OmyAk
//
//  Created by Seohyun Kim on 2023/08/05.
//

import Foundation

struct Constants {
	
	static var API_KEY = "AIzaSyD4epxqpzlrbmCNVqVfI_GttATHGAos79E"
	static var PLAYLIST_ID = "PLKRZTF1Q1uwbb1-ty2nzc7nY3Z1i22jSD"
	static var API_URL = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
	
}
