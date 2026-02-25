import SwiftUI

private enum CreateProfileColors {
    static let background = Color(red: 29, green: 28, blue: 30)
    static let accent = Color(red: 255, green: 187, blue: 0)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.5)
    static let fieldBackground = Color(red: 34, green: 34, blue: 34)
    static let buttonSecondary = Color(red: 34, green: 34, blue: 34)
}

private struct AvatarOption: Identifiable {
    let id: Int
    let iconName: String
    let label: String
}

struct CreateProfileView: View {
    var onAuthSuccess: (() -> Void)?
    var onAnonymousSuccess: (() -> Void)?

    @State private var selectedAvatarId: Int = 3
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false

    private let authService = AuthService.shared
    private let profileService = UserProfileService.shared
    private let avatars: [AvatarOption] = [
        AvatarOption(id: 1, iconName: "icon1", label: "Mountain Explorer"),
        AvatarOption(id: 2, iconName: "icon2", label: "Forest Ranger"),
        AvatarOption(id: 3, iconName: "icon3", label: "Mountain Explorer"),
        AvatarOption(id: 4, iconName: "icon4", label: "Adventure Seeker")
    ]

    private var selectedAvatar: AvatarOption? {
        avatars.first { $0.id == selectedAvatarId }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                avatarSection
                inputSection
                buttonsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(CreateProfileColors.background)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }

    private func handleCreateAccount() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter email and password"
            showError = true
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            showError = true
            return
        }
        isLoading = true
        errorMessage = nil
        Task {
            let result = await authService.signUp(email: email, password: password)
            await MainActor.run {
                isLoading = false
                switch result {
                case .success:
                    profileService.save(displayName: nil, avatarId: selectedAvatarId)
                    onAuthSuccess?()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    private func handleSignIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter email and password"
            showError = true
            return
        }
        isLoading = true
        errorMessage = nil
        Task {
            let result = await authService.signIn(email: email, password: password)
            await MainActor.run {
                isLoading = false
                switch result {
                case .success:
                    profileService.save(displayName: nil, avatarId: selectedAvatarId)
                    onAuthSuccess?()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    private func handleContinueAsGuest() {
        isLoading = true
        errorMessage = nil
        Task {
            let result = await authService.signInAnonymously()
            await MainActor.run {
                isLoading = false
                switch result {
                case .success:
                    profileService.save(displayName: nil, avatarId: selectedAvatarId)
                    onAnonymousSuccess?()
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Create Your Profile")
                .font(.poppinsBold(size: 30))
                .foregroundColor(CreateProfileColors.textPrimary)

            Text("Choose Your Avatar")
                .font(.poppinsBold(size: 12))
                .foregroundColor(CreateProfileColors.textPrimary)
        }
        .padding(.top, 32)
        .padding(.bottom, 24)
    }

    private func avatarButton(_ avatar: AvatarOption) -> some View {
        Button(action: { selectedAvatarId = avatar.id }) {
            Image(avatar.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 118, height: 118)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(selectedAvatarId == avatar.id ? CreateProfileColors.accent : Color.clear, lineWidth: 1)
                )
                .shadow(color: selectedAvatarId == avatar.id ? CreateProfileColors.accent.opacity(0.4) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
    }

    private var avatarSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    avatarButton(avatars[0])
                    avatarButton(avatars[1])
                }
                HStack(spacing: 16) {
                    avatarButton(avatars[2])
                    avatarButton(avatars[3])
                }
            }

            if let selected = selectedAvatar {
                Text(selected.label)
                    .font(.poppinsRegular(size: 12))
                    .foregroundColor(CreateProfileColors.textPrimary)
            }
        }
        .padding(.bottom, 32)
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Email")
                    .font(.poppinsBold(size: 12))
                    .foregroundColor(CreateProfileColors.textPrimary)

                TextField("", text: $email, prompt:
                            Text("Enter Your Email")
                    .font(.poppinsRegular(size: 15))
                    .foregroundColor(CreateProfileColors.textSecondary)
                )
                    .font(.poppinsRegular(size: 15))
                    .foregroundColor(CreateProfileColors.textPrimary)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding(20)
                    .background(CreateProfileColors.fieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Your Password")
                    .font(.poppinsBold(size: 12))
                    .foregroundColor(CreateProfileColors.textPrimary)

                SecureField("", text: $password, prompt:
                            Text("Enter Your Password")
                                .font(.poppinsRegular(size: 15))
                                .foregroundColor(CreateProfileColors.textSecondary)
                )
                .font(.poppinsRegular(size: 15))
                .foregroundColor(CreateProfileColors.textPrimary)
                .padding(20)
                .background(CreateProfileColors.fieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.bottom, 32)
    }

    private var buttonsSection: some View {
        VStack(spacing: 12) {
            Button(action: handleCreateAccount) {
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: CreateProfileColors.background))
                    } else {
                        Text("Create Account")
                            .font(.poppinsSemiBold(size: 18))
                            .foregroundColor(CreateProfileColors.background)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(CreateProfileColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isLoading)

            Button(action: handleSignIn) {
                Text("Sign In")
                    .font(.poppinsSemiBold(size: 18))
                    .foregroundColor(CreateProfileColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(CreateProfileColors.fieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isLoading)

            Button(action: handleContinueAsGuest) {
                Text("Continue as Guest")
                    .font(.poppinsSemiBold(size: 18))
                    .foregroundColor(CreateProfileColors.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isLoading)
        }
    }
}

#Preview {
    CreateProfileView()
}
