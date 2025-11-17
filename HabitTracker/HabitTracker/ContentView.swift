//
//  ContentView.swift
//  HabitTracker
//
//  Created by Husnain on 30/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var activities = Activities()
    @State private var showingSheet = false
    @State private var showingNotes = false
    @State private var showingTestView = false
    
//    init(){
//        print(activities.items.count)
//    }
//    
    var body: some View {
        NavigationStack {
            VStack(spacing: -10){
                VStack(alignment: .center){
                    HStack(){
                        Text("Your Activites")
                            .font(.headline)
                            .padding(.leading, 10)
                        Spacer()
                    }
                    Divider()
                    List{
                        ForEach($activities.items){$activity in
                            
                            NavigationLink{

                                    HabitDetailView(activity: $activity)
                                
                            }label:{
                                Text("\(activity.title)")
                            }
                            
                            
                            
                        }.onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
//                    .scrollContentBackground(.hidden)
//                        .border(.black)
                    .background(.white)
//                    Text("text12")
                    Spacer() 
                }
//                    .padding()
//                            Spacer()
                HStack(){
                    Spacer()
                    Button("+"){
                        showingSheet = true
                    }
                    .font(.system(size: 25))
                    .font(.headline)
                    .foregroundColor(.white)
                    
                    .frame(width: 60, height: 63)
                    .background(.blue)
                    .clipShape(Ellipse())
                    .shadow(radius: 2)
                    .padding(.trailing)
//                    .border(.red)
//                    Spacer()
                }.frame(maxWidth: .infinity)
//                .border(.black)
                .padding()
                .sheet(isPresented: $showingSheet){
                    AddActivityView(activities: activities)
                }
                Button("Test View"){
                    showingTestView = true
                }.sheet(isPresented: $showingTestView){
                    RatingView(rating: .constant(4))
                }
                
            }.navigationTitle("Habit Tracker")
                .toolbarBackground(Color.blue.opacity(0.7), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)       // ensure it’s visible
                    .toolbarColorScheme(.light, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .border(.blue)
                .padding(10)
                .ignoresSafeArea(edges: .bottom)
            }
        
    }
    func deleteItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }

    
//    func load<T: Codable>(_ filename: String) -> T {
//        let data : Data
//        
//        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't file \(filename) in main bundle.")
//        }
//        
//        do {
//            data = try Data(contentsOf: file)
//        }catch{
//            fatalError("Couldn't load \(filename): \(error)")
//        }
//        
//        do{
//            let decoder = JSONDecoder()
//            let decodedValue = try decoder.decode(T.self, from: data)
//            return decodedValue
//        }catch{
//            fatalError("Couldn't parse \(filename) as \(T.self): \(error)")
//        }
//                
//    }
}

#Preview {
    ContentView()
}
