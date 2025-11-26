//
//  RootView.swift
//  EmployeeHub
//
//  Created by Husnain on 26/11/2025.
//

import SwiftUI

struct RootView: View {
    
    @State private var userLoggedIn = false
    @ObservedObject var employee : Employee
    @ObservedObject var authViewModel : EmployeeAuthService
    
    var body: some View {
        if userLoggedIn {
            EmployeeDashboardView(employee: employee, userLoggedIn: $userLoggedIn, authViewModel: authViewModel)
        }
        else {
            LoginView(employee: employee, userLoggenIn: $userLoggedIn, authViewModel: authViewModel)
        }
    }
}
