//
//  AddEmailView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: AuthenticationRouter
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack(spacing: 12) {
            Text("Add your email")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text("You'll use this email to sign in to your account")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            IGInpuntField(
                "Enter your email",
                text: $viewModel.email,
                error: $viewModel.validationError,
                isLoading: viewModel.isValidating
            )
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)

            IGButton("Next", action: onNext)
                .disabled(!formIsValid || viewModel.isValidating)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.vertical)

            Spacer()
        }
        .onAppear {
            viewModel.validationError = nil
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

extension AddEmailView {
    fileprivate var formIsValid: Bool {
        return viewModel.email.isValidEmail()
    }

    fileprivate func onNext() {
        Task {
            let emailIsValid = await viewModel.validateEmail()

            if emailIsValid {
                router.navigate()
            }
        }
    }
}

#Preview {
    AddEmailView()
}
