

import SwiftUI
 
struct ContentView: View {
     
    @StateObject var viewModel = AdvertismentViewModel() //MovieViewModel.swift
    @State var presentAddMovieSheet = false
     
     
    private var addButton: some View {
      Button(action: { self.presentAddMovieSheet.toggle() }) {
        Image(systemName: "plus")
      }
    }
     
     
    var body: some View {
      NavigationView {
         
      }// End Navigation
    }// End Body
}
 
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
