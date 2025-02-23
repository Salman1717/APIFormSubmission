//
//  InformationCardView.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 22/01/25.
//

import SwiftUI

struct InformationCardView: View {
    @ObservedObject var viewModel: FormViewModel
    var data: FormData
    var body: some View {
        
        VStack{
            HStack{
                Text(data.name)
                    .font(.title3)
                    .fontWeight(.heavy)
                    .foregroundColor(Color("primaryText"))
                    .bold()
                Spacer()
                Text("\(data.age) years old")
                    .fontWeight(.regular)
                    .foregroundColor(Color("secondaryText"))
                    .bold()
                    .font(.subheadline)
            }
            .padding(.horizontal)
            .padding(.bottom,12)
            
            HStack{
                VStack(alignment: .leading){
                    Text(data.jobRole)
                        .font(.headline)
                        .foregroundColor(Color("primaryText"))
                        .bold()
                    
                    Text("\(data.experience) years of Experience")
                        .font(.callout)
                        .foregroundColor(Color("secondaryText"))
                        .italic()
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text("CTC")
                        .font(.footnote)
                        .foregroundColor(Color("secondaryText"))
                        .bold()
                    
                    Text("\(data.package) ₹ ")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("primaryText"))
                        .italic()
                    
                }
                
            }
            .padding(.horizontal)
            
            HStack{
                Image(systemName: "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.primaryText)
                    .padding()
                    .background{
                        Circle()
                            .foregroundStyle(
                                Color(.gradient1)
                                    .shadow(.inner(color:.white,radius: 2))
                                    .shadow(.drop(color:.shadow,radius: 10,x:8,y:8))
                            )
                    }
                Spacer()
                
                Image(systemName: "trash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.red)
                    .padding()
                    .background{
                        Circle()
                            .foregroundStyle(
                                Color(.gradient1)
                                    .shadow(.inner(color:.white,radius: 2))
                                    .shadow(.drop(color:.shadow,radius: 10,x:8,y:8))
                            )
                    }
                    .onTapGesture {
                        Task{
                            try await viewModel.deleteData(id: Int(data.id) ?? 0)
                        }
                    }
            }
            .padding(.horizontal)
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: 0.2)
                .foregroundStyle(.white)
                .background{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(
                            LinearGradient(colors: [.gradient1,.gradient1], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .shadow(.inner(color:.shadow,radius: 4,x:4,y:4))
                        )
                }
            
        }
        .padding()
    }
    
}

#Preview {
    InformationCardView(viewModel: FormViewModel(), data: FormData(id: "1", name: "Salman Mhaskar", age: 22, jobRole: "iOS Developer", experience: 2, package: 1200000))
}
