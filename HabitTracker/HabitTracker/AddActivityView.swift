//
//  AddActivityView.swift
//  HabitTracker
//
//  Created by Husnain on 30/10/2025.
//

import Foundation
import SwiftUI


struct AddActivityView : View{
    
    @ObservedObject var activities: Activities
//    @State private var totalActivities: Int
    @State private var habitName = ""
    @State private var habitDescription = ""
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View{
        NavigationStack{
            VStack{
                Form{
                    Section("Habit Title"){
                        TextField("Cycling", text: $habitName)
                    }
                    Section("Enter Description"){
                        TextField("I like biking because...", text: $habitDescription)
                    }
                }
            }.navigationTitle("Add Habit")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    Button("Add"){
                        activities.items.append(Activity(id: UUID(), title: habitName, description: habitDescription))
                        dismiss()
                        
                    }.padding(.trailing, 10)
                }
        }
    }
}

#Preview {
    AddActivityView(activities: Activities())
}
