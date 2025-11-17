//
//  EditDetailView.swift
//  HabitTracker
//
//  Created by Husnain on 31/10/2025.
//

import Foundation
import SwiftUI


struct EditDetailView : View{
    
    @Binding var activity : Activity
    @State private var oldActivityName : String
    @State private var oldActivityDescription : String
    @State private var newActivityName : String
    @State private var newActivityDescription : String
    @State private var showTitleError = false
    @State private var showDescriptionError = false
    
    @Environment(\.dismiss) var dismiss
    
    init(activity: Binding<Activity>){
        _activity = activity
        _oldActivityName = State(initialValue: activity.wrappedValue.title)
        _oldActivityDescription = State(initialValue: activity.wrappedValue.description)
        _newActivityName = State(initialValue: activity.wrappedValue.title)
        _newActivityDescription = State(initialValue: activity.wrappedValue.description)
    }
    
    var body: some View{
        NavigationStack{
            VStack{
                Form{
                    Section("Habit Title"){
                        TextField("\(oldActivityName)", text: $newActivityName)
                    }
                    if showTitleError {
                        Text("Please enter habit title!")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                    }
                    Section("Enter Description"){
                        TextField("\(oldActivityDescription)", text: $newActivityDescription)
                    }
                    if showDescriptionError{
                        Text("Please enter habit description!")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                    }
                }
            }.navigationTitle("Edit Habit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    Button("Done"){
                        print(newActivityName)
                        print(newActivityDescription)
                        if newActivityName.isEmpty || newActivityDescription.isEmpty{
                            showTitleError = newActivityName.isEmpty
                            showDescriptionError = newActivityDescription.isEmpty
                            
                        }
                        else {
                            showTitleError = false
                            showDescriptionError = false
                            activity.title = newActivityName
                            activity.description = newActivityDescription
                            dismiss()
                        }
                        
                       
                        
                    }.padding(.trailing, 10)
                }
        }
    }
}

#Preview {
    AddActivityView(activities: Activities())
}

