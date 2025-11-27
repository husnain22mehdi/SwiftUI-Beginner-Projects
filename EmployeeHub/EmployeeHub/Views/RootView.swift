//
//  RootView.swift
//  EmployeeHub
//
//  Created by Husnain on 26/11/2025.
//

import SwiftUI

struct RootView: View {
    
    //presenting dashboard on launch
    @State private var userLoggedIn = false
    @ObservedObject var employeeViewModel : EmployeeViewModel
    @ObservedObject var authViewModel : EmployeeAuthService
    
    var body: some View {
        if userLoggedIn {
            EmployeeDashboardView(userLoggedIn: $userLoggedIn, employeeViewModel: employeeViewModel, authViewModel: authViewModel)
        }
        else {
            LoginView(userLoggenIn: $userLoggedIn, employeeViewModel: employeeViewModel, authViewModel: authViewModel)
        }
    }
}
