//
//  EmployeeService.swift
//  EmployeeHub
//
//  Created by Husnain on 07/11/2025.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseFirestore


// responsible for handling database
struct EmployeeService {
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    
    func saveEmployeeDocument(_ employee: Employee, imageURL: String?, completion: @escaping (Bool) -> Void){
        
        let employeeData : [String : Any] = [
            "employeeName" : employee.employeeFullName,
            "userName" : employee.userName,
            "password" : employee.password,
            "age" : employee.age,
            "designation" : employee.designation,
            "department" : employee.department,
            "joiningDate" : employee.joiningDate,
            "salary" : employee.salary,
            "profileImageURL" : imageURL ?? ""
        ]
        
        db.collection("employees").document(employee.id).setData(employeeData){ error in
            if let error = error {
                print("Error saving employee: \(error)")
                completion(false)
            }
            else{
                print("Employee saved successfully")
                completion(true)
            }
        }
    }
    
    func saveEmployee(_ employee: Employee, completion: @escaping (Bool) -> Void){
        
        let storageRef = self.storage.child("employees/\(employee.id).jpg")
        
        //convert image to data
        if let imageData = employee.profileImg?.jpegData(compressionQuality: 0.7){
            
            //upload to firebase storage
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                    completion(false)
                    return
                }
                
                //get download URL
                storageRef.downloadURL{ url, error in
                    guard let imageURL = url?.absoluteString else {
                        print("Failed to get download URL")
                        completion(false)
                        return
                    }
                    
                    //save employee data to firestore
                    saveEmployeeDocument(employee, imageURL: imageURL, completion: completion)
                    
                }
                
            }
        }
        //no image stored
        else{
            saveEmployeeDocument(employee, imageURL: nil, completion: completion)
        }
    }
    
    
}
