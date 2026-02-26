import SwiftUI

private enum EditProfileOverlayColors {
    static let cardBackground = Color(red: 34, green: 34, blue: 34)
    static let accent = Color(red: 255, green: 187, blue: 0)
    static let saveGreen = Color(red: 76, green: 175, blue: 80)
    static let cancelRed = Color(red: 231, green: 0, blue: 11)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let fieldBackground = Color(red: 45, green: 45, blue: 45)
}

struct EditProfileOverlayView: View {
    @Binding var isPresented: Bool
    var onSave: ((String, Int) -> Void)?
    var initialName: String = ""
    var initialAvatarId: Int = 1

    @State private var name: String = ""
    @State private var selectedAvatarId: Int = 1

    private let avatarIds = [1, 2, 3, 4]
    private let avatarNames = ["icon1", "icon2", "icon3", "icon4"]

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    VStack(spacing: 24) {
                        Text("Edit Profile")
                            .font(.poppinsBold(size: 22))
                            .foregroundColor(EditProfileOverlayColors.textPrimary)
                        
                        avatarGrid
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your Name")
                                .font(.poppinsBold(size: 12))
                                .foregroundColor(EditProfileOverlayColors.textPrimary)
                            
                            TextField("Enter Your Name", text: $name)
                                .font(.poppinsRegular(size: 15))
                                .foregroundColor(EditProfileOverlayColors.textPrimary)
                                .padding(20)
                                .background(EditProfileOverlayColors.fieldBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        VStack(spacing: 12) {
                            Button(action: {
                                onSave?(name, selectedAvatarId)
                                isPresented = false
                            }) {
                                Text("Save Changes")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(EditProfileOverlayColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(EditProfileOverlayColors.saveGreen)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Button(action: {
                                isPresented = false
                            }) {
                                Text("Cancel")
                                    .font(.poppinsSemiBold(size: 18))
                                    .foregroundColor(EditProfileOverlayColors.textPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .background(EditProfileOverlayColors.cancelRed)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(24)
                    .background(EditProfileOverlayColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: EditProfileOverlayColors.saveGreen, radius: 240, x: 0, y: 0)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            name = initialName
            selectedAvatarId = initialAvatarId
        }
    }

    private var avatarGrid: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                avatarButton(avatarNames[0], id: 1)
                avatarButton(avatarNames[1], id: 2)
            }
            HStack(spacing: 16) {
                avatarButton(avatarNames[2], id: 3)
                avatarButton(avatarNames[3], id: 4)
            }
        }
    }

    private func avatarButton(_ iconName: String, id: Int) -> some View {
        Button(action: { selectedAvatarId = id }) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 118, height: 118)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(selectedAvatarId == id ? EditProfileOverlayColors.accent : Color.clear, lineWidth: 1)
                )
                .shadow(color: selectedAvatarId == id ? EditProfileOverlayColors.accent.opacity(0.4) : .clear, radius: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView()
}
