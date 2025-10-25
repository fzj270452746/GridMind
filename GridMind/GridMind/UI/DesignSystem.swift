//
//  DesignSystem.swift
//  GridMind
//
//  Modern Design System with Gradients and Glassmorphism
//

import UIKit

// MARK: - Color Palette

struct DesignColors {
    // Primary Gradients
    static let primaryGradientStart = UIColor(red: 0.49, green: 0.31, blue: 0.94, alpha: 1.0)  // #7D4FF0
    static let primaryGradientEnd = UIColor(red: 0.29, green: 0.51, blue: 0.95, alpha: 1.0)    // #4A82F2
    
    static let accentGradientStart = UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0)   // #FF6B6B
    static let accentGradientEnd = UIColor(red: 1.0, green: 0.65, blue: 0.31, alpha: 1.0)     // #FFA64F
    
    static let successGradientStart = UIColor(red: 0.25, green: 0.82, blue: 0.58, alpha: 1.0) // #40D194
    static let successGradientEnd = UIColor(red: 0.15, green: 0.67, blue: 0.75, alpha: 1.0)   // #26ABC0
    
    static let warningGradientStart = UIColor(red: 1.0, green: 0.75, blue: 0.29, alpha: 1.0)  // #FFBF4A
    static let warningGradientEnd = UIColor(red: 1.0, green: 0.55, blue: 0.36, alpha: 1.0)    // #FF8C5C
    
    // Background Gradients - More vibrant and dynamic
    static let backgroundGradient1 = UIColor(red: 0.08, green: 0.05, blue: 0.25, alpha: 1.0)  // Deep Purple #140840
    static let backgroundGradient2 = UIColor(red: 0.15, green: 0.10, blue: 0.35, alpha: 1.0)  // Rich Purple #261959
    static let backgroundGradient3 = UIColor(red: 0.20, green: 0.08, blue: 0.40, alpha: 1.0)  // Violet #331466
    static let backgroundGradient4 = UIColor(red: 0.10, green: 0.15, blue: 0.30, alpha: 1.0)  // Deep Blue #19264D
    
    // Accent colors for background particles/shapes
    static let accentPink = UIColor(red: 1.0, green: 0.20, blue: 0.58, alpha: 0.3)    // #FF3394
    static let accentCyan = UIColor(red: 0.20, green: 0.85, blue: 0.95, alpha: 0.3)   // #33D9F2
    static let accentYellow = UIColor(red: 1.0, green: 0.85, blue: 0.20, alpha: 0.3)  // #FFD933
    
    // Text Colors
    static let textPrimary = UIColor(red: 0.15, green: 0.15, blue: 0.20, alpha: 1.0)
    static let textSecondary = UIColor(red: 0.50, green: 0.52, blue: 0.60, alpha: 1.0)
    static let textLight = UIColor.white
    
    // Glass Colors
    static let glassFill = UIColor(white: 1.0, alpha: 0.15)
    static let glassBorder = UIColor(white: 1.0, alpha: 0.25)
    static let glassShadow = UIColor.black.withAlphaComponent(0.15)
}

// MARK: - Typography

struct DesignTypography {
    static let largeTitle = UIFont.systemFont(ofSize: 52, weight: .black)
    static let title1 = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let title2 = UIFont.systemFont(ofSize: 24, weight: .bold)
    static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let body = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let callout = UIFont.systemFont(ofSize: 17, weight: .semibold)
    static let caption = UIFont.systemFont(ofSize: 13, weight: .medium)
}

// MARK: - Spacing

struct DesignSpacing {
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
    static let xxLarge: CGFloat = 48
}

// MARK: - Corner Radius

struct DesignRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
}

// MARK: - Shadows

enum DesignShadow {
    case small
    case medium
    case large
    
    var offset: CGSize {
        switch self {
        case .small: return CGSize(width: 0, height: 2)
        case .medium: return CGSize(width: 0, height: 4)
        case .large: return CGSize(width: 0, height: 8)
        }
    }
    
    var opacity: Float {
        switch self {
        case .small: return 0.08
        case .medium: return 0.12
        case .large: return 0.20
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 8
        case .large: return 16
        }
    }
}

// MARK: - Gradient Factory

class GradientFactory {
    static func createLinearGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        return gradient
    }
    
    static func primaryGradient() -> CAGradientLayer {
        return createLinearGradient(
            colors: [DesignColors.primaryGradientStart, DesignColors.primaryGradientEnd],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
    }
    
    static func accentGradient() -> CAGradientLayer {
        return createLinearGradient(
            colors: [DesignColors.accentGradientStart, DesignColors.accentGradientEnd],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
    }
    
    static func successGradient() -> CAGradientLayer {
        return createLinearGradient(
            colors: [DesignColors.successGradientStart, DesignColors.successGradientEnd],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
    }
    
    static func warningGradient() -> CAGradientLayer {
        return createLinearGradient(
            colors: [DesignColors.warningGradientStart, DesignColors.warningGradientEnd],
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
    }
    
    static func backgroundGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            DesignColors.backgroundGradient1.cgColor,
            DesignColors.backgroundGradient2.cgColor,
            DesignColors.backgroundGradient3.cgColor,
            DesignColors.backgroundGradient4.cgColor,
            DesignColors.backgroundGradient1.cgColor
        ]
        gradient.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.type = .axial
        return gradient
    }
    
    // Animated background gradient with rotation
    static func animatedBackgroundGradient() -> CAGradientLayer {
        let gradient = backgroundGradient()
        
        // Add rotation animation
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 8.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.fromValue = [
            DesignColors.backgroundGradient1.cgColor,
            DesignColors.backgroundGradient2.cgColor,
            DesignColors.backgroundGradient3.cgColor,
            DesignColors.backgroundGradient4.cgColor,
            DesignColors.backgroundGradient1.cgColor
        ]
        animation.toValue = [
            DesignColors.backgroundGradient3.cgColor,
            DesignColors.backgroundGradient4.cgColor,
            DesignColors.backgroundGradient1.cgColor,
            DesignColors.backgroundGradient2.cgColor,
            DesignColors.backgroundGradient3.cgColor
        ]
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        gradient.add(animation, forKey: "colorChange")
        
        return gradient
    }
}

// MARK: - Glass Effect Factory

class GlassEffectFactory {
    static func createGlassView(cornerRadius: CGFloat = DesignRadius.medium) -> UIView {
        let view = UIView()
        view.backgroundColor = DesignColors.glassFill
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1.5
        view.layer.borderColor = DesignColors.glassBorder.cgColor
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    static func applyGlassEffect(to view: UIView, cornerRadius: CGFloat = DesignRadius.medium) {
        view.backgroundColor = DesignColors.glassFill
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1.5
        view.layer.borderColor = DesignColors.glassBorder.cgColor
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Shadow Extension

extension CALayer {
    func applyShadow(_ shadow: DesignShadow) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = shadow.offset
        shadowOpacity = shadow.opacity
        shadowRadius = shadow.radius
        masksToBounds = false
    }
}

// MARK: - Gradient Button

class GradientButton: UIButton {
    private var gradientLayer: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = DesignRadius.medium
        layer.applyShadow(.medium)
        titleLabel?.font = DesignTypography.callout
        setTitleColor(.white, for: .normal)
    }
    
    func setGradient(_ gradient: CAGradientLayer) {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = gradient
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
}

// MARK: - UIColor Extensions

extension UIColor {
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    private func adjustBrightness(by percentage: CGFloat) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let newBrightness = max(min(brightness + percentage, 1.0), 0.0)
            return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
        }
        
        return self
    }
}

// MARK: - Dynamic Background Factory

class DynamicBackgroundFactory {
    /// Creates an animated background with floating shapes
    static func createAnimatedBackground(for view: UIView) {
        // Add the animated gradient
        let gradientLayer = GradientFactory.animatedBackgroundGradient()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add floating shapes
        addFloatingShapes(to: view)
    }
    
    private static func addFloatingShapes(to view: UIView) {
        let shapeCount = 8
        let colors = [
            DesignColors.accentPink,
            DesignColors.accentCyan,
            DesignColors.accentYellow,
            DesignColors.primaryGradientStart.withAlphaComponent(0.2),
            DesignColors.accentGradientStart.withAlphaComponent(0.2)
        ]
        
        for i in 0..<shapeCount {
            let size = CGFloat.random(in: 60...150)
            let x = CGFloat.random(in: 0...view.bounds.width)
            let y = CGFloat.random(in: 0...view.bounds.height)
            
            let shapeView = UIView(frame: CGRect(x: x, y: y, width: size, height: size))
            shapeView.backgroundColor = colors[i % colors.count]
            shapeView.layer.cornerRadius = size / 2
            shapeView.alpha = 0.0
            
            // Add blur effect to shapes
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = shapeView.bounds
            blurView.layer.cornerRadius = size / 2
            blurView.clipsToBounds = true
            blurView.alpha = 0.6
            shapeView.addSubview(blurView)
            
            view.insertSubview(shapeView, at: 1)
            
            // Animate the shape
            animateFloatingShape(shapeView, in: view, delay: Double(i) * 0.3)
        }
    }
    
    private static func animateFloatingShape(_ shape: UIView, in container: UIView, delay: TimeInterval) {
        // Fade in
        UIView.animate(withDuration: 1.0, delay: delay, options: .curveEaseIn) {
            shape.alpha = 1.0
        }
        
        // Floating animation
        let duration = Double.random(in: 15...25)
        let newX = CGFloat.random(in: -50...container.bounds.width + 50)
        let newY = CGFloat.random(in: -50...container.bounds.height + 50)
        
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                shape.center = CGPoint(x: newX, y: newY)
                shape.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }
        )
        
        // Scale animation
        UIView.animate(
            withDuration: duration / 2,
            delay: delay,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                let scale = CGFloat.random(in: 0.8...1.3)
                shape.transform = shape.transform.scaledBy(x: scale, y: scale)
            }
        )
    }
    
    /// Updates the gradient frame when view bounds change
    static func updateBackgroundFrame(for view: UIView) {
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientLayer.frame = view.bounds
            CATransaction.commit()
        }
    }
}

// MARK: - Animation Utilities

class AnimationUtilities {
    static func springAnimation(duration: TimeInterval = 0.6, damping: CGFloat = 0.7, velocity: CGFloat = 0.5, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: .curveEaseOut,
            animations: animations,
            completion: completion
        )
    }
    
    static func fadeIn(view: UIView, duration: TimeInterval = 0.3, delay: TimeInterval = 0, completion: ((Bool) -> Void)? = nil) {
        view.alpha = 0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            view.alpha = 1
        }, completion: completion)
    }
    
    static func scaleAnimation(view: UIView, from: CGFloat = 0.8, to: CGFloat = 1.0, duration: TimeInterval = 0.5) {
        view.transform = CGAffineTransform(scaleX: from, y: from)
        AnimationUtilities.springAnimation(duration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: to, y: to)
        })
    }
    
    static func pulseAnimation(view: UIView) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.05
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        view.layer.add(pulse, forKey: "pulse")
    }
    
    static func shimmerAnimation(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = view.bounds
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: "shimmer")
        view.layer.addSublayer(gradientLayer)
    }
}

