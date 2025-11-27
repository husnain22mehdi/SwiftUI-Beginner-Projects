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
    
    @StateObject var employeeViewModel = EmployeeViewModel()
    @StateObject var authViewModel = EmployeeAuthService()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(employeeViewModel: employeeViewModel, authViewModel: authViewModel)
        }
    }
}
