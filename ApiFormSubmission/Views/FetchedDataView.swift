//
//  FetchedDataView.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 22/01/25.
//

import SwiftUI

struct FetchedDataView: View {
    @StateObject var viewModel = FormViewModel()
    @State private var showForm =  false
    var body: some View {
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                Text("Job Data")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .bold()
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                
                ScrollView(.vertical){
                    VStack(spacing: 10){
                        ForEach(viewModel.FetchedData, id: \.self){ data in
                            InformationCardView(data: data)
                        }
                    }
                }
                    
                Spacer()
            }
            .overlay{
                if viewModel.showErrorMessage{
                    SnackBar(showSnackBar: $viewModel.showErrorMessage, text: viewModel.errorMessage)
                    
                }
            }
            .overlay(alignment: .bottomTrailing){
                showFormButton()
            }
            .onAppear(){
                Task{
                    await viewModel.fetchApiData()
                }
            }
            .sheet(isPresented: $showForm){
                FormView(viewModel: viewModel)
                    .onDisappear{
                        Task{
                            await viewModel.fetchApiData()
                        }
                    }
            }
        }
    }
    @ViewBuilder
    private func showFormButton() -> some View{
        Image(systemName: "plus")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.primaryText)
            .frame(width: 25, height: 25)
            .padding()
            .background{
                Circle()
                    .foregroundStyle(
                        LinearGradient(colors: [.gradient1,.gradient2], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .shadow(.inner(color:.shadow,radius: 4,x:4,y:4))
                    )
            }
            .padding()
            .onTapGesture {
                showForm = true
            }
    }
    
}

#Preview {
    FetchedDataView()
}
