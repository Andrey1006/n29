import SwiftUI

private enum ProfileColors {
    static let navBar = Color(red: 17, green: 17, blue: 17)
    static let background = Color(red: 29, green: 28, blue: 30)
    static let cardBackground = Color(red: 52, green: 52, blue: 52)
    static let accent = Color(red: 255, green: 187, blue: 0)
    static let logoutRed = Color(red: 231, green: 0, blue: 11)
    static let deleteAccountGray = Color(red: 80, green: 80, blue: 80)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let shadowColor = Color(red: 104, green: 0, blue: 0)
}

struct ProfileView: View {
    @Environment(\.showTabBar) private var showTabBar
    @State private var showEditProfileOverlay = false
    @State private var profileName = "Username"
    @State private var profileAvatarId = 1
    @State private var profileRefreshId = 0
    @State private var showDeleteAccountConfirmation = false
    @State private var showDeleteAccountError = false
    @State private var deleteAccountErrorMessage: String?
    @State private var isDeletingAccount = false

    private let profileService = UserProfileService.shared
    private let favoritesService = FavoritesService.shared
    private let authService = AuthService.shared
    private var favoritesCount: Int {
        _ = profileRefreshId
        return favoritesService.favoritesCount()
    }
    private let reservesAvailable = 10

    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 0) {
                    headerView
                    contentView
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ProfileColors.background)
                .onAppear {
                    showTabBar?.wrappedValue = true
                    profileName = profileService.getDisplayName()
                    profileAvatarId = profileService.getAvatarId()
                }
            }
            .navigationBarHidden(true)

            if showEditProfileOverlay {
                EditProfileOverlayView(
                    isPresented: $showEditProfileOverlay,
                    onSave: { name, avatarId in
                        profileService.save(displayName: name, avatarId: avatarId)
                        profileName = profileService.getDisplayName()
                        profileAvatarId = profileService.getAvatarId()
                    },
                    initialName: profileName,
                    initialAvatarId: profileAvatarId
                )
            }
        }
        .alert("Delete Account", isPresented: $showDeleteAccountConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                performDeleteAccount()
            }
        } message: {
            Text("Are you sure? All your local data will be removed. This cannot be undone.")
        }
        .alert("Error", isPresented: $showDeleteAccountError) {
            Button("OK", role: .cancel) { showDeleteAccountError = false }
        } message: {
            Text(deleteAccountErrorMessage ?? "Could not delete account.")
        }
    }

    private func performDeleteAccount() {
        isDeletingAccount = true
        Task {
            let result = await authService.deleteAccount()
            await MainActor.run {
                isDeletingAccount = false
                switch result {
                case .success:
                    profileService.clear()
                    favoritesService.clearAll()
                    UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
                case .failure(let error):
                    deleteAccountErrorMessage = error.localizedDescription
                    showDeleteAccountError = true
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Text("Profile")
                    .font(.poppinsBold(size: 18))
                    .foregroundColor(ProfileColors.textPrimary)

                Spacer()

                NavigationLink(destination: {
                    SettingsView()
                        .navigationBarBackButtonHidden(true)
                        .onAppear { showTabBar?.wrappedValue = false }
                }) {
                    Image(.settingsButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .background(
            ProfileColors.navBar
                .ignoresSafeArea()
                .shadow(color: ProfileColors.shadowColor, radius: 24, x: 0, y: 10)
        )
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileCard
                privacyNotice
            }
            .padding(20)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    private var profileCard: some View {
        VStack(spacing: 16) {
            Image(profileAvatarId >= 1 && profileAvatarId <= 4 ? ["icon1", "icon2", "icon3", "icon4"][profileAvatarId - 1] : "avatarPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 118, height: 118)

            Text(profileName)
                .font(.poppinsSemiBold(size: 24))
                .foregroundColor(ProfileColors.textPrimary)

            Text("Mountain Explorer")
                .font(.poppinsRegular(size: 12))
                .foregroundColor(ProfileColors.textPrimary)

            HStack(spacing: 0) {
                VStack(spacing: 4) {
                    Text("\(favoritesCount)")
                        .font(.poppinsRegular(size: 24))
                        .foregroundColor(ProfileColors.accent)
                    Text("Favorites")
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(ProfileColors.textPrimary)
                }
                .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(ProfileColors.textSecondary.opacity(0.1))
                    .frame(width: 1, height: 40)

                VStack(spacing: 4) {
                    Text("\(reservesAvailable)")
                        .font(.poppinsRegular(size: 24))
                        .foregroundColor(ProfileColors.accent)
                    Text("Reserves Available")
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(ProfileColors.textPrimary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 8)
            
            actionButtons
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(ProfileColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showEditProfileOverlay = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "pencil")
                        .font(.system(size: 18))
                    Text("Edit Profile")
                        .font(.poppinsSemiBold(size: 18))
                }
                .foregroundColor(ProfileColors.navBar)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(ProfileColors.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: {
                favoritesService.clearAll()
                profileRefreshId += 1
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                    Text("Clear Favorites")
                        .font(.poppinsSemiBold(size: 18))
                }
                .foregroundColor(ProfileColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                }
            }

            Button(action: {
                try? authService.signOut()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18))
                    Text("Log Out")
                        .font(.poppinsSemiBold(size: 18))
                }
                .foregroundColor(ProfileColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(ProfileColors.logoutRed)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button(action: { showDeleteAccountConfirmation = true }) {
                HStack(spacing: 12) {
                    if isDeletingAccount {
                        ProgressView()
                            .tint(ProfileColors.textSecondary)
                            .scaleEffect(0.9)
                    } else {
                        Image(systemName: "person.crop.circle.badge.minus")
                            .font(.system(size: 18))
                    }
                    Text("Delete Account")
                        .font(.poppinsSemiBold(size: 18))
                }
                .foregroundColor(ProfileColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(ProfileColors.deleteAccountGray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(isDeletingAccount)
        }
    }

    private var privacyNotice: some View {
        Text("All your data is stored locally on your device. No information is collected or sent to any server.")
            .font(.poppinsRegular(size: 14))
            .foregroundColor(Color(red: 135, green: 206, blue: 235))
            .multilineTextAlignment(.center)
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(red: 135, green: 206, blue: 235).opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ProfileView()
}
