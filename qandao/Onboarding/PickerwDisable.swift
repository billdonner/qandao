//
//  PickerwDisable.swift
//  transtest
//
//  Created by bill donner on 2/29/24.
//

import SwiftUI
 
struct PickerItem: Identifiable, Hashable {
    let id = UUID() 
    var name: String
    var isEnabled: Bool
}

struct PickerwDisable: View {
  let prompt:String
 var items:[PickerItem]
  @State  var   selectedItem: PickerItem?

    var body: some View {
            Picker(prompt, selection: $selectedItem) {
                ForEach(items) { item in
                    Text(item.name)
                        .disabled(!item.isEnabled) // Doesn't visibly disable but used for our custom handling.
                        .tag(Optional(item))
                        .opacity(!item.isEnabled ? 0.5:1.0)
                        .foregroundStyle(item.isEnabled ? .green:.blue)
                        .font(.largeTitle)
                }
            }
            .onChange(of: selectedItem) { oldvalue,newValue in
                // Only allow selection if the item is enabled. You could provide user feedback here if needed.
                if let newValue = newValue, !newValue.isEnabled {
                    // If the new item is disabled, revert to the previous selection or do nothing.
                    selectedItem = nil // Or keep the previous selection if available
                }
            }
            .pickerStyle(InlinePickerStyle())// You can adjust the picker style
        } 
}
#Preview {
  PickerwDisable(prompt: "Foobar? ", items: [PickerItem(name: "Theatre",isEnabled:false),
                                             PickerItem(name: "Music",isEnabled:true),
                                             PickerItem(name: "Cinema",isEnabled:false),
                                             PickerItem(name: "Sport",isEnabled:true)])
}
