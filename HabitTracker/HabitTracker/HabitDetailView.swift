//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by Husnain on 31/10/2025.
//

import Foundation
import SwiftUI

struct HabitDetailView : View {
    
    @Binding var activity : Activity
    @State private var showingEditSheet = false
    
    var body : some View {
//        VStack(alignment: .leading){
//            Text("\(activity.title)")
//            Text("\(activity.description)")
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .border(.black)
//        .childPadding()
        GeometryReader{ geo in
            
            VStack{
                Text("\(activity.title)")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .underline()
                    .textCase(.uppercase)
                    .frame(height: geo.size.height * 0.3)
//                    .border(.blue, width: 5)
                Divider()
                    .frame(height: 2)
                Text("\(activity.description)")
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.7, alignment: .topLeading)
//                    .border(.red, width: 5)
                    .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .border(.green, width: 5)
        }
//        .border(.black)
        .toolbar{
            Button("Edit"){
                showingEditSheet = true
                            }
                .padding(.trailing, 2)
                .sheet(isPresented: $showingEditSheet){
                    EditDetailView(activity: $activity)

                }
        }
        
    }
}

extension View {
    func childPadding() -> some View {
        self.padding(.horizontal, 20)
            .padding(.vertical, 8)
    }
}
