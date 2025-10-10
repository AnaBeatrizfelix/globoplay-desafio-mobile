import Foundation

final class SplashWorker {
    func simulateLoading() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 segundos
    }
}
