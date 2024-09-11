//
//  SentimentViews.swift
//  qandao
//
//  Created by bill donner on 8/31/24.
//

import SwiftUI


let positiveFeelings = ["Vague", "Unclear", "Illogical", "Stimulating", "Insightful", "Brilliant"]
let negativeFeelings = ["Incorrect", "Crazy", "Illogical", "Confusing", "Boring", "I Hate It"]

 

struct PositiveSentimentView: View {
    let id: String
    @State private var cloudKitManager = CloudKitManager.shared
    @State private var message: String = ""
    @State private var selectedFeeling: String = "Insightful"
    @State private var showAlert = false
    
    @Environment(\.dismiss) var dismiss  // Environment value for dismissing the view
    
  var body: some View {
    NavigationView {
      VStack {
        TextField("Enter positive sentiment message", text: $message) 
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        Picker("Select a feeling", selection: $selectedFeeling) {
          ForEach(positiveFeelings, id: \.self) { feeling in
            Text(feeling)
          }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        
        Button(action: {
          let timestamp = Date()
          cloudKitManager.saveLogRecord(
            message: message,
            sentiment: "Positive",
            predefinedFeeling: selectedFeeling,
            timestamp: timestamp,
            challengeIdentifier: id
          ) { result in
            switch result {
            case .success(let record):
              print("Successfully saved positive sentiment record: \(record)")
              dismiss()
            case .failure(let error):
              print("Error saving positive sentiment record: \(error)")
              showAlert = true
            }
          }
        }) {
          Text("Submit Positive Sentiment")
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .alert(isPresented: $showAlert) {
          Alert(title: Text("Error"), message: Text(cloudKitManager.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
      }
      .padding()
      .navigationTitle("Send Positive Sentiment")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .foregroundColor(.primary)  // Adjust color as needed
          }
        }
      }
    }
  }
}
#Preview("Positive") {
  PositiveSentimentView(id: "31434")
}
 
struct NegativeSentimentView: View {
    let id: String
    
    @State private var cloudKitManager = CloudKitManager.shared
    @State private var message: String = ""
    @State private var selectedFeeling: String = "Incorrect"
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss  // Environment value for dismissing the view
    
  var body: some View {
    NavigationView {
      VStack {
        TextField("Enter negative sentiment message", text: $message)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        Picker("Select a feeling", selection: $selectedFeeling) {
          ForEach(negativeFeelings, id: \.self) { feeling in
            Text(feeling)
          }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        
        Button(action: {
          let timestamp = Date()
          cloudKitManager.saveLogRecord(
            message: message,
            sentiment: "Negative",
            predefinedFeeling: selectedFeeling,
            timestamp: timestamp,
            challengeIdentifier: id
          ) { result in
            switch result {
            case .success(let record):
              print("Successfully saved negative sentiment record: \(record)")
              dismiss()
            case .failure(let error):
              print("Error saving negative sentiment record: \(error)")
              showAlert = true
            }
          }
        }) {
          Text("Submit Negative Sentiment")
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .alert(isPresented: $showAlert) {
          Alert(title: Text("Error"), message: Text(cloudKitManager.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
      }
      .padding()
      .navigationTitle("Send Negative Sentiment")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .foregroundColor(.primary)  // Adjust the color as needed
          }
        }
      }
    }
  }
}
#Preview("Negative") {
  NegativeSentimentView(id: "31434")
}
