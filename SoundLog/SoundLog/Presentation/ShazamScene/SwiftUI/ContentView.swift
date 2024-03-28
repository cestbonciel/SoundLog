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

/*
 
 NavigationView { // Wrap your content in a NavigationView
             VStack {
                 Label("Shazam 검색", systemImage: "magnifyingglass") // Correct initializer for Label
                 ShazamView()
                     .environmentObject(shazamViewModel)
             }
             .navigationTitle("Shazam 검색") // Add a title to the navigation bar
         }
 
 import SwiftUI

 struct ContentView: View {
     @StateObject var shazamViewModel = ShazamViewModel()
     var body: some View {
         VStack {
             Label("Shazam 검색", image: UIImage(systemName: "􁈵"))
             //Cannot convert value of type 'UIImage?' to expected argument type 'String'
             ShazamView()
                  .environmentObject(shazamViewModel)
         }
        
     }
 }

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView()
     }
 }

 
 */
