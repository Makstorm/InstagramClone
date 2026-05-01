//
//  CompleteSignUpView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI

struct CompleteSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject private var authManager: AuthManager

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Text("Welcome to Instagram, \(viewModel.username)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text(
                "Click below to complete registration and start using Instagram"
            )
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)

            IGButton("Complete Sign Up", isLoading: viewModel.isLoading, action: onCompleteSignUp)
                .padding(.vertical)

            Spacer()
        }
        .alert("Oops!", isPresented: $viewModel.showError, actions: {}) {
            Text(
                viewModel.authError?.localizedDescription
                    ?? "An unknown error occurred"
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

extension CompleteSignUpView {
    fileprivate func onCompleteSignUp() {
        Task {
            await viewModel.createUser(with: authManager)
        }
    }
}
#Preview {
    CompleteSignUpView()
}
