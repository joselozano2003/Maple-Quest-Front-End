//
//  SplashView.swift
//  Maple-Quest
//
//  Created by Jose Lozano on 11/5/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "map.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("Maple Quest")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ProgressView()
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    SplashView()
}