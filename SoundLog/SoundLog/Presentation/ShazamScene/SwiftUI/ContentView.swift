//
//  ContentView.swift
//  SoundLog
//
//  Created by Seohyun Kim on 2023/11/08.
//

import SwiftUI

struct ContentView: View {
	@StateObject var shazamViewModel = ShazamViewModel()
    var body: some View {
		 
        ShazamView()
			 .environmentObject(shazamViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
