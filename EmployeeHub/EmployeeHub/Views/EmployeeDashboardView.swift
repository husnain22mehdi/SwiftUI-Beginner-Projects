//
//  EmployeeDashboardView.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI

struct EmployeeDashboardView: View {
    
    @Binding var userLoggedIn : Bool
    
    @ObservedObject var employeeViewModel : EmployeeViewModel
    @ObservedObject var authViewModel : EmployeeAuthService
    
    var body: some View {
        NavigationStack{
            //1st vstack
            VStack{
                if let img = employeeViewModel.employee.profileImg {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
//                    else {
//                    Image(systemName: "person.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 150, height: 150)
//                }
                Text("Employee Name: \(employeeViewModel.employee.employeeFullName)")
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
                //button
            }
            //1st Vstack
            .navigationTitle("Employee Dashboard")
        }
        //navigationStack
    }
    //body
}
//struct

