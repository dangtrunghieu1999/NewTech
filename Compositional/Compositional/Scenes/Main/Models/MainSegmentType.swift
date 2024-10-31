enum MainSegmentType: Int, CaseIterable {
    case music = 0
    case library
    
    var title: String {
        switch self {
        case .music: return "Music"
        case .library: return "Library"
        }
    }
} 