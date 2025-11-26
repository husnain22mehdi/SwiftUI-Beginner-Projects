//
//  EmployeeDetailView.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import SwiftUI

struct EmployeeDashboardView: View {
    
    @ObservedObject var employee : Employee
    
    var body: some View {
        Text("This is dashboard view")
        Text("Employee Name : \(employee.employeeFullName)")
        Text("Employee Salary : \(employee.salary)")
    }
}

