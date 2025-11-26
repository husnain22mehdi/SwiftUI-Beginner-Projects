//
//  EmployeeDetailView.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI

struct EmployeeDashboardView: View {
    
    @ObservedObject var employee : Employee
    @Binding var userLoggedIn : Bool
    
    @ObservedObject var authViewModel : EmployeeAuthService
    
    var body: some View {
        Text("This is dashboard view")
        Text("Employee Name : \(employee.employeeFullName)")
        Text("Employee Salary : \(employee.salary)")
        Button("SignOut"){
            authViewModel.signOutEmployee(){success in
                if success {
                    print("SignOut Succesful!")
                }else{
                    print("SignOut Failed!")
                }
            }
            userLoggedIn.toggle()
        }
    }
}

