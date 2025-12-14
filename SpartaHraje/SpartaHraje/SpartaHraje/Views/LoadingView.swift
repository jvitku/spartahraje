//
//  LoadingView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.spartaRed)

            Text("Načítám informace o zápasech...")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
        }
        .padding(40)
    }
}

#Preview {
    LoadingView()
}
