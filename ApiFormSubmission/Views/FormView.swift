//
//  FormView.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 20/01/25.
//

import SwiftUI

struct FormData: Decodable,Hashable{
    var name: String
    var age: Int
    var jobRole: String
    var package: Int
}

struct FormView: View {
    
    @StateObject var viewModel: FormViewModel = FormViewModel()
    
    var body: some View {
        ZStack{
            
            VStack{
                TextField("",text: $viewModel.name, prompt: Text("Ener Youuu Name"))
                    .padding()
                
                TextField("",text: $viewModel.age, prompt: Text("Age"))
                    .keyboardType(.numberPad)
                    .padding()
                
                TextField("",text: $viewModel.jobRole, prompt: Text("Role"))
                    .padding()
                
                TextField("",text: $viewModel.package, prompt: Text("Package"))
                    .keyboardType(.numberPad)
                    .padding()
                
                Text("Save")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        Task{
                            try await viewModel.submitFormData()
                        }
                    }
                
                Text("fetch")
                    .foregroundStyle(.blue)
                    .onTapGesture {
                        Task{
                            await viewModel.fetchBinData()
                        }
                    }
            }
            
        }
    }
}

#Preview {
    FormView()
}
