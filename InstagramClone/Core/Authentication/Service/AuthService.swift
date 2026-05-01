//
//  AuthService.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 18.04.2026.
//

import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
    func createUser(withEmail email: String, password: String, username: String) async throws -> String
    func deleteAccount() async throws
    func getUserSession() -> String?
    func login(withEmail email: String, password: String) async throws -> String
    func sendRessetPasswordLink(toEmail email: String) async throws
    func signout()
}

struct AuthService: AuthServiceProtocol {
    
    
    func createUser(withEmail email: String, password: String, username: String)
        async throws -> String
    {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            await uploadUserData(uid: result.user.uid, username: username, email: email)
            return result.user.uid
        } catch {
            let nsError = error as NSError
            guard let authErrorCode = AuthErrorCode(rawValue: nsError.code) else { throw error }
            throw AuthenticationError(rawValue: authErrorCode.rawValue)
        }
    }
    
    func deleteAccount() async throws {
    }

    func getUserSession() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func login(withEmail email: String, password: String) async throws -> String
    {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return result.user.uid
        } catch {
            let nsError = error as NSError
            guard let authErrorCode = AuthErrorCode(rawValue: nsError.code) else { throw error }
            throw AuthenticationError(rawValue: authErrorCode.rawValue)
        }
    }
    
    func sendRessetPasswordLink(toEmail email: String) async throws {
        
    }

    func signout() {
        try? Auth.auth().signOut()
    }

    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
}
