//
//  AdvertismentEditView.swift
//  NIBM Broker
//
//  Created by Maheesha on 4/16/22.
//


import SwiftUI
 
enum Mode {
  case new
  case edit
}
 
enum Action {
  case delete
  case done
  case cancel
}
 
struct AdvertismentEditView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
     
    @ObservedObject var viewModel = AdvertismentViewModel()
    var mode: Mode = .new
    var completionHandler: ((Result<Action, Error>) -> Void)?
     
     
    var cancelButton: some View {
      Button(action: { self.handleCancelTapped() }) {
        Text("Cancel")
      }
    }
     
    var saveButton: some View {
      Button(action: { self.handleDoneTapped() }) {
        Text(mode == .new ? "Done" : "Save")
      }
      .disabled(!viewModel.modified)
    }
     
    var body: some View {
      NavigationView {
        Form {
          Section(header: Text("Advertisment")) {
            TextField("Title", text: $viewModel.advertisment.title)
            TextField("Year", text: $viewModel.advertisment.year)
          }
           
          Section(header: Text("Description")) {
            TextField("Description", text: $viewModel.advertisment.description)
          }
           
          if mode == .edit {
            Section {
              Button("Delete Advertisment") { self.presentActionSheet.toggle() }
                .foregroundColor(.red)
            }
          }
        }
        .navigationTitle(mode == .new ? "New Advertisment" : viewModel.advertisment.title)
        .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
        .navigationBarItems(
          leading: cancelButton,
          trailing: saveButton
        )
        .actionSheet(isPresented: $presentActionSheet) {
          ActionSheet(title: Text("Are you sure?"),
                      buttons: [
                        .destructive(Text("Delete Advertisment"),
                                     action: { self.handleDeleteTapped() }),
                        .cancel()
                      ])
        }
      }
    }
     
    // Action Handlers
     
    func handleCancelTapped() {
      self.dismiss()
    }
     
    func handleDoneTapped() {
      self.viewModel.handleDoneTapped()
      self.dismiss()
    }
     
    func handleDeleteTapped() {
      viewModel.handleDeleteTapped()
      self.dismiss()
      self.completionHandler?(.success(.delete))
    }
     
    func dismiss() {
      self.presentationMode.wrappedValue.dismiss()
    }
  }

 
struct AdvertismentEditView_Previews: PreviewProvider {
  static var previews: some View {
    let advertisment = Advertisment(title: "Sample title", description: "Sample Description", year: "2020")
    let advertismentViewModel = AdvertismentViewModel(advertisment: advertisment)
    return AdvertismentEditView(viewModel: advertismentViewModel, mode: .edit)
  }
}
