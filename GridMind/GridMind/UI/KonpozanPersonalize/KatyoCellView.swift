//
//  KatyoCellView.swift
//  GridMind
//
//  Mahjong Tile Cell View
//

import UIKit

class KatyoCellView: UIView {

    // MARK: - Subviews

    private lazy var kontenèImaj: UIImageView = {
        let vueImaj = UIImageView()
        vueImaj.contentMode = .scaleAspectFit
        vueImaj.translatesAutoresizingMaskIntoConstraints = false
        vueImaj.clipsToBounds = true
        return vueImaj
    }()

    private lazy var badNimewo: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.isHidden = true
        
        // Modern gradient background
        label.backgroundColor = DesignColors.successGradientStart
        label.layer.cornerRadius = 14
        label.layer.applyShadow(.small)

        return label
    }()

    private lazy var kouchVizyèl: UIView = {
        let masque = UIView()
        masque.translatesAutoresizingMaskIntoConstraints = false
        masque.layer.cornerRadius = 12
        masque.clipsToBounds = true
        masque.isHidden = true

        let koulèMasque = UIColor.white.withAlphaComponent(0.3)
        masque.backgroundColor = koulèMasque

        return masque
    }()

    // MARK: - State Properties

    var katyo: MahjongKatyo?

    var estSeleksyone: Bool = false {
        didSet {
            aplikeChanjmanSeleksyon()
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        enstalasyon()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func enstalasyon() {
        definiAparans()
        ajouteSouVi()
        definiKontrènt()
    }

    private func definiAparans() {
        // Modern glass card effect
        backgroundColor = UIColor(white: 1.0, alpha: 0.98)
        layer.cornerRadius = DesignRadius.medium
        layer.applyShadow(.medium)
        
        // Add subtle border
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        // Enable 3D transforms
        layer.masksToBounds = false
        layer.shouldRasterize = false
    }

    private func ajouteSouVi() {
        addSubview(kontenèImaj)
        addSubview(kouchVizyèl)
        addSubview(badNimewo)
    }

    private func definiKontrènt() {
        let espas: CGFloat = 8
        let petitEspas: CGFloat = 4
        let tay: CGFloat = 32

        NSLayoutConstraint.activate([
            kontenèImaj.topAnchor.constraint(equalTo: topAnchor, constant: espas),
            kontenèImaj.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -espas),
            kontenèImaj.leadingAnchor.constraint(equalTo: leadingAnchor, constant: espas),
            kontenèImaj.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -espas)
        ])

        NSLayoutConstraint.activate([
            kouchVizyèl.topAnchor.constraint(equalTo: topAnchor),
            kouchVizyèl.bottomAnchor.constraint(equalTo: bottomAnchor),
            kouchVizyèl.leadingAnchor.constraint(equalTo: leadingAnchor),
            kouchVizyèl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            badNimewo.topAnchor.constraint(equalTo: topAnchor, constant: petitEspas),
            badNimewo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -petitEspas),
            badNimewo.widthAnchor.constraint(equalToConstant: tay),
            badNimewo.heightAnchor.constraint(equalToConstant: tay)
        ])
    }

    // MARK: - Public Configuration

    func konfigire(ak katyo: MahjongKatyo) {
        self.katyo = katyo

        let nonRessource = katyo.nonImaj
        kontenèImaj.image = UIImage(named: nonRessource)

        badNimewo.isHidden = true
        kouchVizyèl.isHidden = true
    }

    func aficheNimewo(_ nimewo: Int) {
        badNimewo.text = String(nimewo)
        badNimewo.isHidden = false

        let transfòmInisyal = CGAffineTransform(scaleX: 0.1, y: 0.1)
        badNimewo.transform = transfòmInisyal
        badNimewo.alpha = 0

        AnimationUtilities.springAnimation(duration: 0.5, damping: 0.5, velocity: 1.0, animations: {
            self.badNimewo.transform = CGAffineTransform.identity
            self.badNimewo.alpha = 1
        })
        
        // Add pulse effect
        AnimationUtilities.pulseAnimation(view: badNimewo)
    }

    func kacheNimewo() {
        badNimewo.isHidden = true
    }

    // MARK: - Selection State Update

    private func aplikeChanjmanSeleksyon() {
        let koulèFwontyè = UIColor(
            red: 51.0/255.0,
            green: 127.0/255.0,
            blue: 204.0/255.0,
            alpha: 1.0
        )

        if estSeleksyone {
            kouchVizyèl.isHidden = false
            layer.borderWidth = 3
            layer.borderColor = koulèFwontyè.cgColor
        } else {
            kouchVizyèl.isHidden = true
            layer.borderWidth = 0
            layer.borderColor = nil
        }
    }

    // MARK: - Animation Methods

    func animeEntransAk(_ reta: TimeInterval) {
        alpha = 0
        
        // 3D flip animation
        layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(
            withDuration: 0.6,
            delay: reta,
            usingSpringWithDamping: 0.65,
            initialSpringVelocity: 0.8,
            options: [.curveEaseOut, .allowUserInteraction],
            animations: {
                self.alpha = 1
                self.layer.transform = CATransform3DIdentity
                self.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }

    func animeSeleksyon() {
        // 3D bounce with perspective
        let scaleUp = CGAffineTransform(scaleX: 1.15, y: 1.15)
        let rotationTransform = CATransform3DMakeRotation(.pi / 16, 0, 1, 0)
        
        AnimationUtilities.springAnimation(duration: 0.3, damping: 0.6, velocity: 0.8, animations: {
            self.transform = scaleUp
            self.layer.transform = rotationTransform
        }) { _ in
            AnimationUtilities.springAnimation(duration: 0.3, damping: 0.7, animations: {
                self.transform = .identity
                self.layer.transform = CATransform3DIdentity
            })
        }
        
        // Add glow effect
        addGlowEffect()
    }
    
    private func addGlowEffect() {
        let glowLayer = CALayer()
        glowLayer.frame = bounds
        glowLayer.cornerRadius = layer.cornerRadius
        glowLayer.backgroundColor = DesignColors.successGradientStart.cgColor
        glowLayer.opacity = 0
        
        layer.insertSublayer(glowLayer, at: 0)
        
        let glowAnimation = CABasicAnimation(keyPath: "opacity")
        glowAnimation.fromValue = 0.6
        glowAnimation.toValue = 0
        glowAnimation.duration = 0.5
        glowAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        glowLayer.add(glowAnimation, forKey: "glow")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            glowLayer.removeFromSuperlayer()
        }
    }

    func animeErè() {
        let animKeyframe = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animKeyframe.timingFunction = CAMediaTimingFunction(name: .linear)
        animKeyframe.duration = 0.5

        let valèWotasyon: [CGFloat] = [-12, 12, -8, 8, -4, 4, 0]
        animKeyframe.values = valèWotasyon

        layer.add(animKeyframe, forKey: "shake")

        let koulèErè = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.3)
        let koulèNòmal = UIColor(white: 1.0, alpha: 1.0)

        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.backgroundColor = koulèErè
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.backgroundColor = koulèNòmal
                }
            }
        )
    }
}
