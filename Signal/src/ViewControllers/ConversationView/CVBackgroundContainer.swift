//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

import Foundation

@objc
public protocol CVBackgroundContainerDelegate: class {
    func updateSelectionHighlight()
    func updateScrollingContent()
}

// MARK: -

@objc
public class CVBackgroundContainer: ManualLayoutViewWithLayer {

    private enum ZPositioning: CGFloat {
        case wallpaperContent = 0
        case wallpaperDimming = 1
        case selectionHighlight = 2
        case wallpaperBlur = 3
    }

    fileprivate var wallpaperView: WallpaperView?

    public let selectionHighlightView = SelectionHighlightView()

    fileprivate var updateScrollingContentTimer: Timer?
    fileprivate var shouldHaveUpdateScrollingContentTimer = AtomicUInt(0)

    @objc
    public weak var delegate: CVBackgroundContainerDelegate?

    public init() {
        super.init(name: "CVBackgroundContainer")

        self.shouldDeactivateConstraints = false
        self.isUserInteractionEnabled = false
        // Render all background views behind the collection view.
        self.layer.zPosition = -1

        selectionHighlightView.isUserInteractionEnabled = false
        addSubview(selectionHighlightView)
        selectionHighlightView.layer.zPosition = ZPositioning.selectionHighlight.rawValue
        #if TESTABLE_BUILD
        selectionHighlightView.accessibilityIdentifier = "selectionHighlightView"
        #endif
    }

    @available(*, unavailable, message: "use other constructor instead.")
    @objc
    public required init(name: String) {
        notImplemented()
    }

    public func set(wallpaperView: WallpaperView?) {
        self.wallpaperView?.blurView?.removeFromSuperview()
        self.wallpaperView?.contentView?.removeFromSuperview()
        self.wallpaperView?.dimmingView?.removeFromSuperview()
        self.wallpaperView = wallpaperView

        if let wallpaperView = wallpaperView {
            self.backgroundColor = .clear

            if let contentView = wallpaperView.contentView {
                addSubview(contentView)
                contentView.layer.zPosition = ZPositioning.wallpaperContent.rawValue
            }
            if let dimmingView = wallpaperView.dimmingView {
                addSubview(dimmingView)
                dimmingView.layer.zPosition = ZPositioning.wallpaperDimming.rawValue
            }
            if let blurView = wallpaperView.blurView {
                addSubview(blurView)
                blurView.layer.zPosition = ZPositioning.wallpaperBlur.rawValue
            }

            setNeedsLayout()
        } else {
            self.backgroundColor = Theme.backgroundColor
        }
    }

    public override func layoutSubviews() {
        AssertIsOnMainThread()

        super.layoutSubviews()

        let shouldUpdateWallpaperBlur = wallpaperView?.blurView?.frame != bounds
        let shouldUpdateSelectionHighlight = selectionHighlightView.frame != bounds

        wallpaperView?.blurView?.frame = bounds
        wallpaperView?.contentView?.frame = bounds
        wallpaperView?.dimmingView?.frame = bounds
        selectionHighlightView.frame = bounds

        if shouldUpdateWallpaperBlur {
            wallpaperView?.updateBlurContentAndMask()
        }
        if shouldUpdateSelectionHighlight {
            delegate?.updateSelectionHighlight()
        }
    }
}

// MARK: -

fileprivate extension CVBackgroundContainer {

    func updateWallpaperBlurMask() {
        AssertIsOnMainThread()

        let isAnimating = shouldHaveUpdateScrollingContentTimer.get() > 0
        wallpaperView?.updateBlurMask(isAnimating: isAnimating)
    }

    func updateScrollingContentForAnimation(duration: TimeInterval) {
        AssertIsOnMainThread()

        // To ensure a "smooth landing" of these animations, we need to continue
        // to update the mask for a short period after the animations lands.
        let duration = duration * 2
        
        startUpdateScrollingContentTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.stopUpdateScrollingContentTimer()
        }
    }

    func startUpdateScrollingContentTimer() {
        AssertIsOnMainThread()

        shouldHaveUpdateScrollingContentTimer.increment()

        if updateScrollingContentTimer == nil {
            let timerInterval: TimeInterval = TimeInterval(1) / TimeInterval(60)
            updateScrollingContentTimer = WeakTimer.scheduledTimer(timeInterval: timerInterval,
                                                                   target: self,
                                                                   userInfo: nil,
                                                                   repeats: true) { [weak self] _ in
                self?.updateScrollingContentTimerDidFire()
            }
        }
    }

    func stopUpdateScrollingContentTimer() {
        AssertIsOnMainThread()

        shouldHaveUpdateScrollingContentTimer.decrementOrZero()
    }

    func updateScrollingContentTimerDidFire() {
        AssertIsOnMainThread()

        if shouldHaveUpdateScrollingContentTimer.get() == 0 {
            // Stop
            updateScrollingContentTimer?.invalidate()
            updateScrollingContentTimer = nil
        }
        delegate?.updateScrollingContent()
    }
}

// MARK: -

extension ConversationViewController: CVBackgroundContainerDelegate {
    var selectionHighlightView: SelectionHighlightView {
        viewState.backgroundContainer.selectionHighlightView
    }

    @objc
    public func updateScrollingContent() {
        AssertIsOnMainThread()

        viewState.backgroundContainer.updateWallpaperBlurMask()
        updateSelectionHighlight()
    }

    @objc
    public func updateScrollingContentForAnimation(duration: TimeInterval) {
        AssertIsOnMainThread()

        viewState.backgroundContainer.updateScrollingContentForAnimation(duration: duration)
    }

    @objc
    public func startUpdateScrollingContentTimer() {
        AssertIsOnMainThread()

        viewState.backgroundContainer.startUpdateScrollingContentTimer()
    }

    @objc
    public func stopUpdateScrollingContentTimer() {
        AssertIsOnMainThread()

        viewState.backgroundContainer.stopUpdateScrollingContentTimer()
    }
}
