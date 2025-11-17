//
//  Activities.swift
//  HabitTracker
//
//  Created by Husnain on 30/10/2025.
//

import Foundation


//@Observable
class Activities : ObservableObject{
    
    @Published var items: [Activity] = []{
        didSet{
            save()
        }
    }
    private let filename = "activities.json"
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("activities.json")
    
    init(){
        load()
    }
    
    func load(){
//        guard let url = Bundle.main.url(forResource: filename, withExtension: nil)
//        else{
////            fatalError("Couldn't find \(filename) in main bundle")
//            print("cant find file(loading)")
//            return
//        }
        
        do {
//            print("at line 1")
            let data = try Data(contentsOf: savePath)
//            print("at line 2")
//            guard !data.isEmpty else{}
            let decoded = try? JSONDecoder().decode([Activity].self, from: data)
//            print("at line 3")
            self.items = decoded ?? [Activity(id: UUID(), title: "", description: "")]
//            print("items decoded")
        }catch{
//            fatalError("Failed to load \(filename): \(error.localizedDescription)")
            print("cant load file (loading)")
        }
    }
    
    func save(){
        do {
            let data = try JSONEncoder().encode(items)
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            try data.write(to: url)
            
        }catch{
//            fatalError("Failed to save data: \(error.localizedDescription)")
            print("cant save data")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension FileManager{
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
