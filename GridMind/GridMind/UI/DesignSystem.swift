//
//  DesignSystem.swift
//  GridMind
//
//  Modern Design System with Gradients and Glassmorphism
//

import UIKit

// MARK: - Color Registry

struct DesignColors {
    // Primary color scheme
    static let primaryGradientStart = fabrik_koulè(h: 0.49, s: 0.31, b: 0.94)
    static let primaryGradientEnd = fabrik_koulè(h: 0.29, s: 0.51, b: 0.95)
    
    static let accentGradientStart = fabrik_koulè(h: 1.0, s: 0.42, b: 0.42)
    static let accentGradientEnd = fabrik_koulè(h: 1.0, s: 0.65, b: 0.31)
    
    static let successGradientStart = fabrik_koulè(h: 0.25, s: 0.82, b: 0.58)
    static let successGradientEnd = fabrik_koulè(h: 0.15, s: 0.67, b: 0.75)
    
    static let warningGradientStart = fabrik_koulè(h: 1.0, s: 0.75, b: 0.29)
    static let warningGradientEnd = fabrik_koulè(h: 1.0, s: 0.55, b: 0.36)
    
    // Background gradients
    static let backgroundGradient1 = fabrik_koulè(h: 0.08, s: 0.05, b: 0.25)
    static let backgroundGradient2 = fabrik_koulè(h: 0.15, s: 0.10, b: 0.35)
    static let backgroundGradient3 = fabrik_koulè(h: 0.20, s: 0.08, b: 0.40)
    static let backgroundGradient4 = fabrik_koulè(h: 0.10, s: 0.15, b: 0.30)
    
    // Accent colors
    static let accentPink = fabrik_koulè_alfa(h: 1.0, s: 0.20, b: 0.58, a: 0.3)
    static let accentCyan = fabrik_koulè_alfa(h: 0.20, s: 0.85, b: 0.95, a: 0.3)
    static let accentYellow = fabrik_koulè_alfa(h: 1.0, s: 0.85, b: 0.20, a: 0.3)
    
    // Text colors
    static let textPrimary = fabrik_koulè(h: 0.15, s: 0.15, b: 0.20)
    static let textSecondary = fabrik_koulè(h: 0.50, s: 0.52, b: 0.60)
    static let textLight = UIColor.white
    
    // Glass effects
    static let glassFill = UIColor(white: 1.0, alpha: 0.15)
    static let glassBorder = UIColor(white: 1.0, alpha: 0.25)
    static let glassShadow = UIColor.black.withAlphaComponent(0.15)
    
    private static func fabrik_koulè(h: CGFloat, s: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: h, green: s, blue: b, alpha: 1.0)
    }
    
    private static func fabrik_koulè_alfa(h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: h, green: s, blue: b, alpha: a)
    }
}

// MARK: - Typography System

struct DesignTypography {
    static let largeTitle = konstryi_fon(gwosè: 52, pwa: .black)
    static let title1 = konstryi_fon(gwosè: 32, pwa: .bold)
    static let title2 = konstryi_fon(gwosè: 24, pwa: .bold)
    static let title3 = konstryi_fon(gwosè: 20, pwa: .semibold)
    static let body = konstryi_fon(gwosè: 16, pwa: .regular)
    static let callout = konstryi_fon(gwosè: 17, pwa: .semibold)
    static let caption = konstryi_fon(gwosè: 13, pwa: .medium)
    
    private static func konstryi_fon(gwosè: CGFloat, pwa: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: gwosè, weight: pwa)
    }
}

// MARK: - Spacing Constants

struct DesignSpacing {
    static let tiny: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
    static let xxLarge: CGFloat = 48
}

// MARK: - Radius Values

struct DesignRadius {
    static let small: CGFloat = 12
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xLarge: CGFloat = 32
}

// MARK: - Shadow Configuration

enum DesignShadow {
    case small
    case medium
    case large
    
    var offset: CGSize {
        let valè: [DesignShadow: (CGFloat, CGFloat)] = [
            .small: (0, 2),
            .medium: (0, 4),
            .large: (0, 8)
        ]
        let (x, y) = valè[self] ?? (0, 2)
        return CGSize(width: x, height: y)
    }
    
    var opacity: Float {
        let tab: [DesignShadow: Float] = [
            .small: 0.08,
            .medium: 0.12,
            .large: 0.20
        ]
        return tab[self] ?? 0.08
    }
    
    var radius: CGFloat {
        let mappaj: [DesignShadow: CGFloat] = [
            .small: 4,
            .medium: 8,
            .large: 16
        ]
        return mappaj[self] ?? 4
    }
}

// MARK: - Gradient Builder

class GradientFactory {
    static func createLinearGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        let kouch = CAGradientLayer()
        kouch.colors = colors.map { $0.cgColor }
        kouch.startPoint = startPoint
        kouch.endPoint = endPoint
        return kouch
    }
    
    static func primaryGradient() -> CAGradientLayer {
        return konstryi_gradient_diagonal(
            [DesignColors.primaryGradientStart, DesignColors.primaryGradientEnd]
        )
    }
    
    static func accentGradient() -> CAGradientLayer {
        return konstryi_gradient_diagonal(
            [DesignColors.accentGradientStart, DesignColors.accentGradientEnd]
        )
    }
    
    static func successGradient() -> CAGradientLayer {
        return konstryi_gradient_diagonal(
            [DesignColors.successGradientStart, DesignColors.successGradientEnd]
        )
    }
    
    static func warningGradient() -> CAGradientLayer {
        return konstryi_gradient_diagonal(
            [DesignColors.warningGradientStart, DesignColors.warningGradientEnd]
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
    
    static func animatedBackgroundGradient() -> CAGradientLayer {
        let baz = backgroundGradient()
        
        let animasyon = CABasicAnimation(keyPath: "colors")
        animasyon.duration = 8.0
        animasyon.autoreverses = true
        animasyon.repeatCount = .infinity
        animasyon.fromValue = [
            DesignColors.backgroundGradient1.cgColor,
            DesignColors.backgroundGradient2.cgColor,
            DesignColors.backgroundGradient3.cgColor,
            DesignColors.backgroundGradient4.cgColor,
            DesignColors.backgroundGradient1.cgColor
        ]
        animasyon.toValue = [
            DesignColors.backgroundGradient3.cgColor,
            DesignColors.backgroundGradient4.cgColor,
            DesignColors.backgroundGradient1.cgColor,
            DesignColors.backgroundGradient2.cgColor,
            DesignColors.backgroundGradient3.cgColor
        ]
        animasyon.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        baz.add(animasyon, forKey: "colorChange")
        
        return baz
    }
    
    private static func konstryi_gradient_diagonal(_ koulè: [UIColor]) -> CAGradientLayer {
        return createLinearGradient(
            colors: koulè,
            startPoint: CGPoint(x: 0, y: 0),
            endPoint: CGPoint(x: 1, y: 1)
        )
    }
}

// MARK: - Glass Effect Builder

class GlassEffectFactory {
    static func createGlassView(cornerRadius: CGFloat = DesignRadius.medium) -> UIView {
        let kontènè = UIView()
        kontènè.backgroundColor = DesignColors.glassFill
        kontènè.layer.cornerRadius = cornerRadius
        kontènè.layer.borderWidth = 1.5
        kontènè.layer.borderColor = DesignColors.glassBorder.cgColor
        
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.layer.cornerRadius = cornerRadius
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        kontènè.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: kontènè.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: kontènè.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: kontènè.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: kontènè.bottomAnchor)
        ])
        
        return kontènè
    }
    
    static func applyGlassEffect(to view: UIView, cornerRadius: CGFloat = DesignRadius.medium) {
        view.backgroundColor = DesignColors.glassFill
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1.5
        view.layer.borderColor = DesignColors.glassBorder.cgColor
        
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
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

// MARK: - Layer Extension

extension CALayer {
    func applyShadow(_ shadow: DesignShadow) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = shadow.offset
        shadowOpacity = shadow.opacity
        shadowRadius = shadow.radius
        masksToBounds = false
    }
}

// MARK: - Gradient Button Component

class GradientButton: UIButton {
    private var kouchGradient: CAGradientLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        enstalasyon()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        enstalasyon()
    }
    
    private func enstalasyon() {
        layer.cornerRadius = DesignRadius.medium
        layer.applyShadow(.medium)
        titleLabel?.font = DesignTypography.callout
        setTitleColor(.white, for: .normal)
    }
    
    func setGradient(_ gradient: CAGradientLayer) {
        kouchGradient?.removeFromSuperlayer()
        kouchGradient = gradient
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        kouchGradient?.frame = bounds
    }
}

// MARK: - Color Extensions

extension UIColor {
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return ajiste_briyans(faktè: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        return ajiste_briyans(faktè: -abs(percentage))
    }
    
    private func ajiste_briyans(faktè: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
            return self
        }
        
        let nouvo_b = max(min(b + faktè, 1.0), 0.0)
        return UIColor(hue: h, saturation: s, brightness: nouvo_b, alpha: a)
    }
}

// MARK: - Dynamic Background Factory

class DynamicBackgroundFactory {
    static func createAnimatedBackground(for view: UIView) {
        let gradientLayer = GradientFactory.animatedBackgroundGradient()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        ajoute_fòm_flotante(nan: view)
    }
    
    private static func ajoute_fòm_flotante(nan view: UIView) {
        let kantite_fòm = 8
        let palets = [
            DesignColors.accentPink,
            DesignColors.accentCyan,
            DesignColors.accentYellow,
            DesignColors.primaryGradientStart.withAlphaComponent(0.2),
            DesignColors.accentGradientStart.withAlphaComponent(0.2)
        ]
        
        for i in 0..<kantite_fòm {
            let gwosè = CGFloat.random(in: 60...150)
            let x = CGFloat.random(in: 0...view.bounds.width)
            let y = CGFloat.random(in: 0...view.bounds.height)
            
            let fòm = UIView(frame: CGRect(x: x, y: y, width: gwosè, height: gwosè))
            fòm.backgroundColor = palets[i % palets.count]
            fòm.layer.cornerRadius = gwosè / 2
            fòm.alpha = 0.0
            
            let blur = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.frame = fòm.bounds
            blurView.layer.cornerRadius = gwosè / 2
            blurView.clipsToBounds = true
            blurView.alpha = 0.6
            fòm.addSubview(blurView)
            
            view.insertSubview(fòm, at: 1)
            
            anime_fòm(fòm, nan: view, dekala: Double(i) * 0.3)
        }
    }
    
    private static func anime_fòm(_ fòm: UIView, nan kontènè: UIView, dekala: TimeInterval) {
        UIView.animate(withDuration: 1.0, delay: dekala, options: .curveEaseIn) {
            fòm.alpha = 1.0
        }
        
        let dire = Double.random(in: 15...25)
        let nouvo_x = CGFloat.random(in: -50...kontènè.bounds.width + 50)
        let nouvo_y = CGFloat.random(in: -50...kontènè.bounds.height + 50)
        
        UIView.animate(
            withDuration: dire,
            delay: dekala,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                fòm.center = CGPoint(x: nouvo_x, y: nouvo_y)
                fòm.transform = CGAffineTransform(rotationAngle: .pi * 2)
            }
        )
        
        UIView.animate(
            withDuration: dire / 2,
            delay: dekala,
            options: [.repeat, .autoreverse, .curveEaseInOut],
            animations: {
                let echèl = CGFloat.random(in: 0.8...1.3)
                fòm.transform = fòm.transform.scaledBy(x: echèl, y: echèl)
            }
        )
    }
    
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
        springAnimation(duration: duration, animations: {
            view.transform = CGAffineTransform(scaleX: to, y: to)
        })
    }
    
    static func pulseAnimation(view: UIView) {
        let puls = CABasicAnimation(keyPath: "transform.scale")
        puls.duration = 0.6
        puls.fromValue = 1.0
        puls.toValue = 1.05
        puls.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        puls.autoreverses = true
        puls.repeatCount = .infinity
        view.layer.add(puls, forKey: "pulse")
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
