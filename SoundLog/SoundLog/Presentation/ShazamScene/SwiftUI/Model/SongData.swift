//
//  Song.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/08.
//

import Foundation

struct SongData {
	let title: String
	let artist: String
	let genres: [String]
	let artworkUrl: URL?
	let appleMusicUrl: URL?
	
	static func example() -> SongData {
		
		SongData(title: "You & Me", artist: "제니", genres: ["K-Pop", "음악", "팝"], artworkUrl: URL(string:"https://www.apple.com"), appleMusicUrl: URL(string:"https://is1-ssl.mzstatic.com/image/thumb/Video126/v4/e8/cb/f8/e8cbf841-a93b-dc37-2e79-e271c3a0e8ba/Jobeae961ab-9b5b-4e4f-8f9d-0c64e947b22f-156441193-PreviewImage_preview_image_nonvideo_sdr-Time1696021271364.png/316x316bb.webp"))
	}
}
