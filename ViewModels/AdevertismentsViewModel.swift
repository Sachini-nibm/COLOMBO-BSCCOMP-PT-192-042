
import Foundation

//
//  AdevertismentsViewModel.swift

import Foundation
import Combine
import FirebaseFirestore
 
class AdvertismentsViewModel: ObservableObject {
  @Published var advertisments = [Advertisment]()
   
  private var db = Firestore.firestore()
  private var listenerRegistration: ListenerRegistration?
   
  deinit {
    unsubscribe()
  }
   
  func unsubscribe() {
    if listenerRegistration != nil {
      listenerRegistration?.remove()
      listenerRegistration = nil
    }
  }
   
  func subscribe() {
    if listenerRegistration == nil {
      listenerRegistration = db.collection("advertismentlist").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
         
        self.advertisments = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Advertisment.self)
        }
      }
    }
  }
   
  func removeAdvertisments(atOffsets indexSet: IndexSet) {
    let advertisments = indexSet.lazy.map { self.advertisments[$0] }
    movies.forEach { advertisment in
      if let documentId = advertisment.id {
        db.collection("advertismentlist").document(documentId).delete { error in
          if let error = error {
            print("Unable to remove document: \(error.localizedDescription)")
          }
        }
      }
    }
  }
 
   
}
