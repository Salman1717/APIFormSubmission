//
//  FormViewModel.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 20/01/25.
//

import Foundation

@MainActor
class FormViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var jobRole: String = ""
    @Published var package: String = ""
    @Published var experience: String = ""
    @Published var FetchedData :[FormData] = []
    @Published var errorMessage = ""
    @Published var showErrorMessage = false
    
   
//MARK: - Submit Data To Api using POST
    func submitFormData() async throws {
        let data = try validateAndConvertData()

        let jsonParameters: [String: Any] = [
            "name": data.name,
            "age": data.age,
            "jobRole": data.jobRole,
            "experience": data.experience,
            "package": data.package
        ]
        
        guard let url = URL(string: "https://678fcd1749875e5a1a9369db.mockapi.io/salman/api/users"),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonParameters) else {
            throw NSError(domain: "Error serializing Json Data", code: 2)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    if String(data: data, encoding: .utf8) != nil {
                        self.errorMessage = "Data Uploded to the Server)"
                        self.showErrorMessage = true
                    } else {
                        self.errorMessage = "Parsing Failed"
                        self.showErrorMessage = true
                    }
                } else {
                    let errorString = String(data: data, encoding: .utf8) ?? "No response body"
                    self.errorMessage = "Server Error: \(httpResponse.statusCode), Body: \(errorString)"
                    self.showErrorMessage = true
                }
            } else {
                self.errorMessage = "Server Error"
                self.showErrorMessage = true
            }
        } catch {
            throw error
        }
        
        clearFields()
    }
//MARK: - Retive Data from the Api using GET
    func fetchApiData() async {
            guard let url = URL(string:"https://678fcd1749875e5a1a9369db.mockapi.io/salman/api/users") else {
                errorMessage = "Invalid URL"
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            let decodedData = try JSONDecoder().decode([FormData].self, from: data)
                            DispatchQueue.main.async {
                                self.FetchedData = decodedData
                                self.errorMessage = ""
                                
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                                self.showErrorMessage = true
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorMessage = "Server Error: \(httpResponse.statusCode)"
                            self.showErrorMessage = true
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Request Failed: \(error.localizedDescription)"
                    self.showErrorMessage = true
                }
            }
        }
    
//MARK: - Delete Data From Server
    func deleteData(id: Int) async throws {
        guard let url = URL(string: "https://678fcd1749875e5a1a9369db.mockapi.io/salman/api/users/\(id)") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.errorMessage = "Invalid response type"
                self.showErrorMessage = true
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                self.errorMessage = "Data Deleted Successfully"
                self.showErrorMessage = true
                await fetchApiData()
                
            case 404:
                self.errorMessage = "User not found"
                self.showErrorMessage = true
                
            default:
                self.errorMessage = "Server returned status code: \(httpResponse.statusCode)"
                self.showErrorMessage = true
            }
        } catch {
            self.errorMessage = "Network error: \(error.localizedDescription)"
            self.showErrorMessage = true
            throw error
        }
    }
    
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
