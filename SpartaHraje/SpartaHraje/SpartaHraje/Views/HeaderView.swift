//
//  HeaderView.swift
//  SpartaHraje
//
//  Created by Claude Code
//

import SwiftUI

struct HeaderView: View {
    let theme: AppTheme

    var body: some View {
        ZStack {
            LinearGradient(
                colors: theme.headerColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 10) {
                Text("⚽ AC Sparta Praha")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text("Hraje dnes na Letné?")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.white.opacity(0.95))
            }
            .padding(.vertical, 30)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 0) {
        HeaderView(theme: .red)
        Spacer()
    }
}
