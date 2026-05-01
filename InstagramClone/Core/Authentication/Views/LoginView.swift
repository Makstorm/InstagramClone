//
//  LoginView.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 16.04.2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authManager: AuthManager
    @StateObject var viewModel = LoginViewModel()

    @StateObject var router = AuthenticationRouter()

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            VStack {
                Spacer()

                Image(.instagramLogoBlack)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 100)

                VStack {
                    IGInpuntField("Enter your email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    SecureField("Password", text: $viewModel.password)
                        .modifier(IGTextFieldModifier())
                }

                Button {
                    print("Show forgot password")
                } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)

                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                IGButton(
                    "Login",
                    isLoading: viewModel.isLoading,
                    action: onLoginTapped
                )
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.vertical)

                HStack {
                    Rectangle()
                        .containerRelativeFrame([.horizontal, .vertical]) {
                            length,
                            axis in
                            if axis == .horizontal {
                                return (length / 2) - 40
                            } else {
                                return 0.5
                            }
                        }
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)

                    Rectangle()
                        .containerRelativeFrame([.horizontal, .vertical]) {
                            length,
                            axis in
                            if axis == .horizontal {
                                return (length / 2) - 40
                            } else {
                                return 0.5
                            }
                        }
                }
                .foregroundStyle(.gray)

                HStack {
                    Image(.facebookLogo)
                        .resizable()
                        .frame(width: 20, height: 20)

                    Text("Continule with facebook")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.systemBlue))
                }
                .padding(.top, 8)

                Spacer()

                Divider()

                Button {
                    router.startRegistration()
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")

                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)

                }
                .padding(.vertical, 16)

            }
            .alert("Oops!", isPresented: $viewModel.showError, actions: {}) {
                Text(
                    viewModel.error?.localizedDescription
                        ?? "An unknown error occurred"
                )
            }
            .navigationDestination(for: RegistrationSteps.self) { step in
                Group {
                    switch step {
                    case .email:
                        AddEmailView()
                    case .username:
                        CreateUsernameView()
                    case .password:
                        CreatePasswordView()
                    case .completion:
                        CompleteSignUpView()
                    }
                }
                .environmentObject(router)
                .navigationBarBackButtonHidden()
            }
        }
    }
}

extension LoginView {
    var formIsValid: Bool {
        return viewModel.email.isValidEmail()
            && viewModel.password.isValidPassword()
    }

    func onLoginTapped() {
        Task { await viewModel.logIn(with: authManager) }
    }
}

#Preview {
    LoginView()
}
