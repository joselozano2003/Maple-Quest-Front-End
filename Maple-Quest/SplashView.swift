//
//  SplashView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack{
                    Text("Maple")
                        .font(.title)
                        .fontWeight(.bold)
                        .offset(x: -40)
                        .foregroundColor(.black)
                    Text("Quest")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .offset(x: 25)
                }
                .padding(.bottom, -150)
                Image("splashIcon")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 10, y: -90)
                
                ProgressView()
                    .scaleEffect(1.2)
                    .padding(.top, -60)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.white))
    }
}

#Preview {
    SplashView()
}
