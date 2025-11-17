//
//  EmployeeHubApp.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI
import Firebase

@main
struct EmployeeHubApp: App {
    
    @StateObject var employee = Employee()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(employee: employee)
        }
    }
}
