//
//  ContentView.swift
//  PhotoSwipe
//
//  Created by matheo rose on 17/01/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20){
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack(spacing: 15){
                        Image(.galerie)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                            .cornerRadius(12)
                        Text("PhotoSwipe")
                            .font(.title).bold()
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: Swipe()) {
                        Text("Start to swipe")
                            .frame(width: 150, height: 50)
                            .background(.white)
                            .cornerRadius(12)
                            .font(.title3).bold()
                            .foregroundStyle(.black)
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}
