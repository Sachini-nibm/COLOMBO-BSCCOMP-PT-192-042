

import Foundation

import Combine
import FirebaseFirestore
 
class AdvertismentViewModel: ObservableObject {
   
  @Published var advertisment: Movie
  @Published var modified = false
   
  private var cancellables = Set<anycancellable>()
   
  init(advertisment: Advertisment = Advertisment(title: "", description: "", year: "")) {
    self.advertisment = advertisment
     
    self.$advertisment
      .dropFirst()
      .sink { [weak self] movie in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
   
  // Firestore
   
  private var db = Firestore.firestore()
   
  private func addAdvertisment(_ advertisment: Advertisment) {
    do {
      let _ = try db.collection("advertismentlist").addDocument(from: advertisment)
    }
    catch {
      print(error)
    }
  }
   
  private func updateAdvertisment(_ movie: Movie) {
    if let documentId = advertisment.id {
      do {
        try db.collection("advertismentlist").document(documentId).setData(from: advertisment)
      }
      catch {
        print(error)
      }
    }
  }
   
  private func updateOrAddAdvertisment() {
    if let _ = advertisment.id {
      self.updateAdvertisment(self.advertisment)
    }
    else {
      addAdvertisment(advertisment)
    }
  }
   
  private func removeAdvertisment() {
    if let documentId = advertisment.id {
      db.collection("advertismentlist").document(documentId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
   
  // UI handlers
   
  func handleDoneTapped() {
    self.updateOrAddAdvertisment()
  }
   
  func handleDeleteTapped() {
    self.removeAdvertisment()
  }
   
}

