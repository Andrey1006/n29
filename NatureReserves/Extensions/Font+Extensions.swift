import SwiftUI

extension Font {

    private enum Poppins {
        static let bold = "Poppins-Bold"
        static let medium = "Poppins-Medium"
        static let regular = "Poppins-Regular"
        static let semiBold = "Poppins-SemiBold"
    }

    static func poppinsBold(size: CGFloat) -> Font {
        .custom(Poppins.bold, size: size)
    }

    static func poppinsMedium(size: CGFloat) -> Font {
        .custom(Poppins.medium, size: size)
    }

    static func poppinsRegular(size: CGFloat) -> Font {
        .custom(Poppins.regular, size: size)
    }

    static func poppinsSemiBold(size: CGFloat) -> Font {
        .custom(Poppins.semiBold, size: size)
    }
}
