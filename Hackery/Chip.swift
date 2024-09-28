//
//  Chip.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/25/24.
//

import SwiftUI

struct Chip: View {
    let icon: String?
    let text: String
    
    var body: some View {
        HStack {
            if let icon {
                Image(systemName: icon)
            }
            Text(text).font(.subheadline)
        }
        .padding(5)
        .padding(.horizontal, 3)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primary, lineWidth: 1)
        )
    }
}

#Preview {
    Chip(icon: "person", text: "Person")
}
