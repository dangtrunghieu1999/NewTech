import UIKit
import SnapKit

class StretchyHeaderView: UIView {
    // MARK: - Public Types
    public enum ScrollDirection {
        case none, up, down
    }
    
    // MARK: - Constants
    private enum Constants {
        static let maxHeaderHeight: CGFloat = 200
        static let minHeaderHeight: CGFloat = 100
        static let maxAvatarSize: CGFloat = 100
        static let minAvatarSize: CGFloat = 50
        static let avatarTransitionPoint: CGFloat = 100
    }
    
    // MARK: - Properties
    private var headerHeightConstraint: Constraint?
    private var avatarSizeConstraint: Constraint?
    private var avatarCenterXConstraint: Constraint?
    private var avatarLeadingConstraint: Constraint?
    
    private var headerProgress: CGFloat = 0
    
    // MARK: - UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.maxAvatarSize / 2
        imageView.backgroundColor = .systemGray5 // Default background
        return imageView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(avatarImageView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            headerHeightConstraint = make.height.equalTo(Constants.maxHeaderHeight).constraint
        }
        
        avatarImageView.snp.makeConstraints { make in
            avatarSizeConstraint = make.width.height.equalTo(Constants.maxAvatarSize).constraint
            make.centerY.equalToSuperview()
            avatarCenterXConstraint = make.centerX.equalToSuperview().constraint
        }
        
        avatarImageView.snp.prepareConstraints { make in
            avatarLeadingConstraint = make.leading.equalTo(16).constraint
        }
        avatarLeadingConstraint?.deactivate()
    }
    
    // MARK: - Public Methods
    public func configure(with image: UIImage?) {
        avatarImageView.image = image
    }
    
    public func updateHeader(withOffset offset: CGFloat, scrollDirection: ScrollDirection) {
        let normalizedOffset = min(max(offset, 0), Constants.maxHeaderHeight - Constants.minHeaderHeight)
        let progress = normalizedOffset / (Constants.maxHeaderHeight - Constants.minHeaderHeight)
        
        headerProgress = progress
        
        updateHeaderHeight(progress: progress)
        updateAvatarTransform(progress: progress)
    }
    
    public func snapToNearestState() {
        let targetProgress = headerProgress > 0.5 ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3,
                      delay: 0,
                      usingSpringWithDamping: 0.7,
                      initialSpringVelocity: 0.5,
                      options: .allowUserInteraction,
                      animations: {
            let headerHeight = Constants.maxHeaderHeight - (targetProgress * (Constants.maxHeaderHeight - Constants.minHeaderHeight))
            self.headerHeightConstraint?.update(offset: headerHeight)
            self.layoutIfNeeded()
        })
    }
    
    // MARK: - Private Methods
    private func updateHeaderHeight(progress: CGFloat) {
        let headerHeight = Constants.maxHeaderHeight - (progress * (Constants.maxHeaderHeight - Constants.minHeaderHeight))
        headerHeightConstraint?.update(offset: headerHeight)
    }
    
    private func updateAvatarTransform(progress: CGFloat) {
        let avatarSize = Constants.maxAvatarSize - (progress * (Constants.maxAvatarSize - Constants.minAvatarSize))
        avatarSizeConstraint?.update(offset: avatarSize)
        avatarImageView.layer.cornerRadius = avatarSize / 2
        
        if progress > 0.5 && avatarCenterXConstraint?.isActive == true {
            UIView.animate(withDuration: 0.3,
                         delay: 0,
                         options: [.curveEaseOut, .beginFromCurrentState],
                         animations: {
                self.avatarCenterXConstraint?.deactivate()
                self.avatarLeadingConstraint?.activate()
                self.layoutIfNeeded()
            })
        } else if progress <= 0.5 && avatarLeadingConstraint?.isActive == true {
            UIView.animate(withDuration: 0.3,
                         delay: 0,
                         options: [.curveEaseOut, .beginFromCurrentState],
                         animations: {
                self.avatarLeadingConstraint?.deactivate()
                self.avatarCenterXConstraint?.activate()
                self.layoutIfNeeded()
            })
        }
    }
} 
