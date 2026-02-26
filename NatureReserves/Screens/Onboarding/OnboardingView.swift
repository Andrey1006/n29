import SwiftUI

private struct OnboardingPage {
    let iconName: String
    let title: String
    let description: String
}

struct OnboardingView: View {
    var onComplete: (() -> Void)?

    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            iconName: "onb1Icon",
            title: "Explore the World's Greatest Nature Reserves",
            description: "Discover protected natural areas across the globe and learn why they matter. Explore unique landscapes, wildlife, and ecosystems in one simple offline app."
        ),
        OnboardingPage(
            iconName: "onb2Icon",
            title: "Interactive Map with Reserve Pins",
            description: "Browse the world map and tap on pins to explore the most famous nature reserves. Each reserve includes detailed descriptions, biodiversity highlights, and key conservation information."
        ),
        OnboardingPage(
            iconName: "onb3Icon",
            title: "Save Your Favorites",
            description: "Add reserves to your Favorites and build your personal list of dream destinations. Access all information offline anytime, anywhere."
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Skip") {
                    onComplete?()
                }
                .font(.poppinsBold(size: 12))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(.white.opacity(0.1))
                .cornerRadius(10)
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)

            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageContent(
                        page: page,
                        pageIndex: index,
                        totalPages: pages.count,
                        onNext: { goNext(from: index) }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(
            Image(.mainBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }

    private func goNext(from index: Int) {
        if index < pages.count - 1 {
            withAnimation {
                currentPage = index + 1
            }
        } else {
            onComplete?()
        }
    }
}

private struct OnboardingPageContent: View {
    let page: OnboardingPage
    let pageIndex: Int
    let totalPages: Int
    let onNext: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer()
                
                Image(page.iconName)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 94)
                
                Text(page.title)
                    .font(.poppinsMedium(size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 50)
                
                Text(page.description)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                
                
                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(index == pageIndex ? Color(red: 255, green: 187, blue: 0) : .white.opacity(0.2))
                            .frame(width: 24, height: 6)
                    }
                }
                .padding(.top, 24)
                
                Spacer()
                
                Button(action: onNext) {
                    Text(pageIndex == totalPages - 1 ? "Continue" : "Next")
                        .font(.poppinsSemiBold(size: 18))
                        .foregroundColor(Color(red: 18, green: 18, blue: 18))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color(red: 255, green: 187, blue: 0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 26)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
