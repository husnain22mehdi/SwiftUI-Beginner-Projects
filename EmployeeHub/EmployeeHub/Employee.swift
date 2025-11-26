//
//  Employee.swift
//  EmployeeHub
//
//  Created by Husnain on 05/11/2025.
//

import Foundation
import SwiftUI

class Employee : Identifiable, ObservableObject {
    
    @Published var id = UUID().uuidString
    @Published var profileImg : UIImage? = nil
    @Published var firstName : String = ""
    @Published var middleName : String? = ""
    @Published var lastName : String = ""
    @Published var userName : String = ""
    @Published var password : String = ""
    @Published var age : Int = 20
    @Published var designation : String = ""
    @Published var department : String = ""
    @Published var joiningDate : Date = Date.now
    @Published var salary : Int = 0
    
    
    let designations = [
        
        "Board Member",
        "Project Director",
        "Team Lead",
        "Junior Executive"
        
    ]
    
    let departments = [
        
        "Finance",
        "Research and Development",
        "Human Resources",
        "Design",
        "Marketing",
        "Sales"
        
    ]
    
//    init(id: UUID, profileImg : Image?, firstName: String, middleName: String?, lastName : String, age: Int, designation: String, department: String, salary: Int, workExperience: Int) {
//        self.id = id
//        self.profileImg = nil
//        self.firstName = ""
//        self.middleName = ""
//        self.lastName = ""
//        self.age = 20
//        self.designation = ""
//        self.department = ""
//        self.salary = 20000
//        self.workExperience = 2
//    }
//    
    var employeeFullName : String {
        get{
            return firstName + (middleName ?? "") + lastName
        }
        set {
            firstName = newValue
            middleName = ""
            lastName = ""
        }
    }

    //initializer to create an employee from data returned from firestore
//    init?( _ dataDictionary : [String : Any]) {
//        
//        self.id = dataDictionary["employeeID"] as? String ?? ""
//        self.employeeFullName = dataDictionary["employeeName"]
//        self.userName = dataDictionary["userName"] as? String ?? ""
//        self.password = dataDictionary["password"]
//        self.age = dataDictionary["age"]
//        self.designation = dataDictionary["designation"]
//        self.department = dataDictionary["department"]
//        self.joiningDate = dataDictionary["joiningDate"]
//        self.salary = dataDictionary["salary"]
//        //data contains profile image url, we need the actual image
//        self.pro
//    }
}
