//
//  FormView.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 20/01/25.
//

import SwiftUI

struct FormView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: FormViewModel = FormViewModel()
    
    var body: some View {
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                HStack {
                    Text("Job Details ")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.accent)
                    
                    Spacer()
                    
                    Image(systemName: "xmark.app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.red)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            dismiss()
                        }
                }
                .padding(.horizontal)
                .padding(.top)
                   
                
                customTextFiled(feildFor: $viewModel.name, title: "Your Name")
                
                customTextFiled(feildFor: $viewModel.age, title: "Age in years")
                
                customTextFiled(feildFor: $viewModel.jobRole, title: "Job Role")
                
                customTextFiled(feildFor: $viewModel.experience, title: "Experience (in years)")
                
                customTextFiled(feildFor: $viewModel.package, title: "Anual CTC (in ₹)")
                
                Text("Save")
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("primaryText"))
                    .bold()
                    .onTapGesture {
                        Task{
                            try await viewModel.submitFormData()
                            dismiss()
                        }
                    }
                    .frame(width: 150)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(
                                Color(.gradient1)
                                    .shadow(.drop(color:.shadow,radius: 10,x:8,y:8))
                            )
                    }
                    .padding(.bottom)
                
                
                    
                Spacer()
                
            }
            
        }
    }
    
    @ViewBuilder
    private func textFieldBg() -> some View{
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(
                Color(.gradient1)
                    .shadow(.inner(color:.shadow,radius: 4,x:4,y:4))
            )
    }
    
    @ViewBuilder
    private func customTextFiled(feildFor: Binding<String>, title: String) -> some View{
        TextField("",text: feildFor, prompt: Text(title).foregroundStyle(.accent))
            .padding()
            .background{
                textFieldBg()
            }
            .foregroundStyle(.primaryText)
            .padding()
    }
}

#Preview {
    FormView()
}
