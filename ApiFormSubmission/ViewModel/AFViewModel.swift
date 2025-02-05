//
//  AFViewModel.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 05/02/25.
//
import Foundation
import Alamofire

class AFViewModel{
    
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var jobRole: String = ""
    @Published var package: String = ""
    @Published var experience: String = ""
    @Published var FetchedData :[FormData] = []
    @Published var errorMessage = ""
    @Published var showErrorMessage = false
    
    
    
    
    //MARK: - private validation function
        private func validateAndConvertData() throws -> FormData {
            
            guard let Age = Int(age), let package = Int(package), let exp = Int(experience), !name.isEmpty, !jobRole.isEmpty else{
                self.errorMessage = "Invalid Form Data"
                self.showErrorMessage = true
                throw NSError(domain: "Invalid Form Data", code: 1)
            }
            
            let formData = FormData(id: "", name: name, age: Age, jobRole: jobRole, experience: exp, package: package)
            
            return formData
        }
        
        private func clearFields(){
            self.name = ""
            self.age = ""
            self.jobRole = ""
            self.package = ""
        }
}
