//
//  SnackBar.swift
//  ApiFormSubmission
//
//  Created by Salman Mhaskar on 23/01/25.
//

import SwiftUI

struct SnackBar: View {
    @Binding var showSnackBar: Bool
    var text: String
    var body: some View {
        VStack{
            Text(text)
                .font(.callout)
                .fontWeight(.light)
                .foregroundColor(Color("primaryText"))
        }
        .padding()
        .background{
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(
                    Color(.accent)
                    .shadow(.drop(color:.shadow,radius: 4,x:4,y:4))
                )
        }
        .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                    withAnimation(.easeInOut){
                        showSnackBar = false
                }
            }
        }
    }
}

#Preview {
    SnackBar(showSnackBar: .constant(true), text: "salman")
}
