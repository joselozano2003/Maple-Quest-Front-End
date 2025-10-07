//
//  HomeView.swift
//  Maple-Quest
//
//  Created by Camila Hernandez on 2025-10-06.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        // Home view title
        VStack(alignment: .leading) {
            Text("Explore")
            HStack {
                Text("Beautiful").bold()
                Text("Canada!").bold().foregroundColor(.red)
            }
        }
        .font(.largeTitle)
    }
}

#Preview {
    HomeView()
}
