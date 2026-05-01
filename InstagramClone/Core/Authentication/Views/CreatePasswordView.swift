//
//  CreatePasswordView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: AuthenticationRouter

    var body: some View {
        VStack(spacing: 12) {
            Text("Create a passwors")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)

            Text("Your password must be at least 6 characters in length")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            SecureField("Password", text: $viewModel.password)
                .textInputAutocapitalization(.never)
                .modifier(IGTextFieldModifier())
                .padding(.top)

            IGButton("Next", action: onNext)
                .opacity(formIsValid ? 1.0 : 0.5)
                .disabled(!formIsValid)
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

extension CreatePasswordView {
    fileprivate var formIsValid: Bool {
        return viewModel.password.isValidPassword()
    }

    fileprivate func onNext() {
        router.navigate()
    }
}

#Preview {
    CreatePasswordView()
}
