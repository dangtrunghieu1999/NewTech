
import Foundation

final class MainLayoutFactory {
    static func createLayout(for type: MainSegmentType) -> MainLayoutProvider {
        switch type {
        case .music:
            return MusicLayoutProvider()
        case .library:
            return LibraryLayoutProvider()
        }
    }
} 
