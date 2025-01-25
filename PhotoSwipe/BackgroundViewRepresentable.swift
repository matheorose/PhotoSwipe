import SwiftUI

struct BackgroundViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BackgroundView {
        return BackgroundView()
    }
    
    func updateUIViewController(_ uiViewController: BackgroundView, context: Context) {
    }
}
