import Foundation
import FirebaseAuth

enum AuthResult {
    case success
    case failure(Error)
}

final class AuthService {
    static let shared = AuthService()

    private init() {}

    var currentUser: User? {
        Auth.auth().currentUser
    }

    var isAnonymous: Bool {
        currentUser?.isAnonymous ?? false
    }

    func signUp(email: String, password: String) async -> AuthResult {
        do {
            _ = try await Auth.auth().createUser(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            return .success
        } catch {
            return .failure(error)
        }
    }

    func signIn(email: String, password: String) async -> AuthResult {
        do {
            _ = try await Auth.auth().signIn(withEmail: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            return .success
        } catch {
            return .failure(error)
        }
    }

    func signInAnonymously() async -> AuthResult {
        do {
            _ = try await Auth.auth().signInAnonymously()
            return .success
        } catch {
            return .failure(error)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func deleteAccount() async -> AuthResult {
        guard let user = Auth.auth().currentUser else {
            return .failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in"]))
        }
        if user.isAnonymous {
            try? Auth.auth().signOut()
            return .success
        }
        do {
            try await user.delete()
            return .success
        } catch {
            return .failure(error)
        }
    }
}
