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
                BackgroundViewRepresentable()
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    
                    Spacer()
                    Spacer()
                    
                
                    Image(.galerie)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                    Text("PhotoSwipe")
                        .font(.system(size: 50)).bold()
                        .foregroundStyle(.white)
                        .shadow(radius: 10)
                
                    
                    Spacer()
                    
                    NavigationLink(destination: Swipe()) {
                        Text("Start to Swipe")
                            .frame(width: 280, height: 60)
                            .background(.white)
                            .cornerRadius(12)
                            .font(.title2).bold()
                            .foregroundStyle(.black)
                            .shadow(radius: 10)
                    }
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
