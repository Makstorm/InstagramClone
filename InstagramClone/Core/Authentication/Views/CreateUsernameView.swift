//
//  CreateUsernameView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import SwiftUI

struct CreateUsernameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @EnvironmentObject var router: AuthenticationRouter
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Create username")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Your account handle. You can always change this later.")
                .font(.footnote)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            IGInpuntField("Username", text: $viewModel.username, error: $viewModel.validationError, isLoading: viewModel.isValidating)
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

private extension CreateUsernameView {
    var formIsValid: Bool {
        return viewModel.username.isValidUsername()
    }
    
    func onNext() {
        Task {
            let usernameIsValid = await viewModel.validateUsername()
            
            if usernameIsValid {
                router.navigate()
            } else {
                print("Debug: error validating username")
            }
        }
    }
}

#Preview {
    CreateUsernameView()
}
