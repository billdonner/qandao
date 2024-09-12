//
//  TopicSelectorView.swift
//  basic
//
//  Created by bill donner on 7/9/24.
//
import SwiftUI

struct TopicSelectorView: View {
    // Existing properties
    let allTopics: [String]
    @Binding var selectedTopics: [String]
    @Binding var selectedScheme: ColorSchemeName
    let chmgr: ChaMan
    let gs: GameState
    let minTopics: Int
    let maxTopics: Int
    @Binding var gimms: Int
    
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var rerolledTopics: [String: String] = [:]  // Dictionary to keep track of rerolled topics
    
    // New state variables for alerts
    @State private var showAlert = false
    @State private var selectedAction: ActionType?
    @State private var pendingTopic: String?

    enum ActionType {
        case add, remove
    }
    
    var filteredTopics: [String] {
        if searchText.isEmpty {
            return allTopics.filter { !selectedTopics.contains($0) }
        } else {
            return allTopics.filter { $0.localizedCaseInsensitiveContains(searchText) && !selectedTopics.contains($0) }
        }
    }
    
    fileprivate func isNotReallyAvailable() -> Bool {
        return gimms <= 0 || selectedTopics.count >= maxTopics
    }
    
    fileprivate func isNotRemoveable() -> Bool {
        return gimms <= 0 || selectedTopics.count <= minTopics
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {

                
                TopicIndexView(gs: gs, chmgr: chmgr, inPlayTopics: $selectedTopics, scheme: $selectedScheme)
                
                Form {
                    // Active Topics Section
                    Section(header: HStack {
                        Text("Active Topics")
                        Image(systemName: "info.circle")
                        Spacer()
                        Text("min \(minTopics) \( minTopics==1 ? "topic" : "topics")")
                        .font(.caption2)
                    }) {
                        ForEach(selectedTopics, id: \.self) { topic in
                            HStack {
                                Text(topic).font(.body)
                                Spacer()
                                Button(action: {
                                    pendingTopic = topic
                                    selectedAction = .remove
                                    showAlert = true
                                }) {
                                    Text("remove?").font(.footnote)
                                        .foregroundColor(.orange)
                                        .opacity(isNotRemoveable() ? 0.0 : 1.0)
                                }
                            }
                            .disabled(isNotRemoveable())
                        }
                    }
                    
                    // Available Topics Section
                  Section(header:HStack{
                    Text("Available Topics"); Spacer()
                    Text("add \(maxTopics - selectedTopics.count) more \(maxTopics - selectedTopics.count == 1 ? "topic" : "topics").")
               
                  } ) {
                        ForEach(filteredTopics, id: \.self) { topic in
                            HStack {
                                Text(topic).font(.body)
                                Spacer()
                                Button(action: {
                                    pendingTopic = topic
                                    selectedAction = .add
                                    showAlert = true
                                }) {
                                    Text("add?").font(.footnote)
                                        .foregroundColor(.orange)
                                        .opacity(isNotReallyAvailable() ? 0.0 : 1.0)
                                }
                            }
                            .disabled(isNotReallyAvailable())
                        }
                    }
                }
            }
            .navigationTitle("Choose Topics")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
            .alert(isPresented: $showAlert) {
                getConfirmationAlert()
            }
        }
    }
    
    // New function for generating the alert based on the selected action
    private func getConfirmationAlert() -> Alert {
        guard let action = selectedAction, let topic = pendingTopic else {
            return Alert(title: Text("Error"), message: Text("An unexpected error occurred."))
        }
        
        let title = action == .add ? "Add Topic" : "Remove Topic"
        let message = action == .add ? "Are you sure you want to add this topic?\nIt will cost you one gimmee" : "Are you sure you want to remove this topic?\nIt will cost you one gimmee"
        
        return Alert(
            title: Text(title),
            message: Text(message),
            primaryButton: .default(Text("Confirm")) {
                if action == .add {
                    addTopic(topic)
                } else if action == .remove {
                    removeTopic(topic)
                }
            },
            secondaryButton: .cancel()
        )
    }
    
    // Functions to handle adding and removing topics
    private func addTopic(_ topic: String) {
        if !selectedTopics.contains(topic) && selectedTopics.count < maxTopics {
            selectedTopics.append(topic)
            gimms -= 1
        }
    }
    
    private func removeTopic(_ topic: String) {
        if selectedTopics.contains(topic) {
            selectedTopics.removeAll { $0 == topic }
            gimms -= 1
        }
    }
}
