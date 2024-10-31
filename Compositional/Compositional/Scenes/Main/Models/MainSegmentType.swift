enum MainSegmentType: Int, CaseIterable {
    case music = 0
    case library = 1
    
    var title: String {
        switch self {
        case .music:
            return "Music"
        case .library:
            return "Library"
        }
    }
} 