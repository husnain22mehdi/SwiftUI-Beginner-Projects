//
//  EmployeeViewModel.swift
//  EmployeeHub
//
//  Created by Husnain on 26/11/2025.
//

import Foundation
import SwiftUI

class EmployeeViewModel : ObservableObject {
    
    @Published var employee = Employee()
    
    func setEmployee( _ employee : Employee){
        self.employee = employee
    }
}
