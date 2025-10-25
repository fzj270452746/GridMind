//
//  KatyoCellView.swift
//  GridMind
//
//  Mahjong Tile Cell View
//

import UIKit

class KatyoCellView: UIView {

    // MARK: - Internal Components
    
    private lazy var zòn_imaj: UIImageView = {
        let imaj = UIImageView()
        imaj.contentMode = .scaleAspectFit
        imaj.translatesAutoresizingMaskIntoConstraints = false
        imaj.clipsToBounds = true
        return imaj
    }()

    private lazy var endikèt_nimewo: UILabel = {
        let etikèt = UILabel()
        etikèt.font = .systemFont(ofSize: 18, weight: .black)
        etikèt.textColor = UIColor.white
        etikèt.textAlignment = .center
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        etikèt.clipsToBounds = true
        etikèt.isHidden = true
        
        etikèt.backgroundColor = DesignColors.successGradientStart
        etikèt.layer.cornerRadius = 14
        etikèt.layer.applyShadow(.small)

        return etikèt
    }()

    private lazy var kouch_seleksyon: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.layer.cornerRadius = 12
        overlay.clipsToBounds = true
        overlay.isHidden = true

        let koulè_overlay = UIColor.white.withAlphaComponent(0.3)
        overlay.backgroundColor = koulè_overlay

        return overlay
    }()

    // MARK: - State

    var katyo: MahjongKatyo?

    var estSeleksyone: Bool = false {
        didSet {
            aplike_chanjman_vizuèl()
        }
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        konfigirasyon_inisyal()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func konfigirasyon_inisyal() {
        prepare_aparans()
        monte_kompozan()
        prepare_kontrènt()
    }

    private func prepare_aparans() {
        backgroundColor = UIColor(white: 1.0, alpha: 0.98)
        layer.cornerRadius = DesignRadius.medium
        layer.applyShadow(.medium)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        layer.masksToBounds = false
        layer.shouldRasterize = false
    }

    private func monte_kompozan() {
        addSubview(zòn_imaj)
        addSubview(kouch_seleksyon)
        addSubview(endikèt_nimewo)
    }

    private func prepare_kontrènt() {
        let marge_jeneral: CGFloat = 8
        let marge_piti: CGFloat = 4
        let tay_bad: CGFloat = 32

        NSLayoutConstraint.activate([
            zòn_imaj.topAnchor.constraint(equalTo: topAnchor, constant: marge_jeneral),
            zòn_imaj.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -marge_jeneral),
            zòn_imaj.leadingAnchor.constraint(equalTo: leadingAnchor, constant: marge_jeneral),
            zòn_imaj.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -marge_jeneral)
        ])

        NSLayoutConstraint.activate([
            kouch_seleksyon.topAnchor.constraint(equalTo: topAnchor),
            kouch_seleksyon.bottomAnchor.constraint(equalTo: bottomAnchor),
            kouch_seleksyon.leadingAnchor.constraint(equalTo: leadingAnchor),
            kouch_seleksyon.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            endikèt_nimewo.topAnchor.constraint(equalTo: topAnchor, constant: marge_piti),
            endikèt_nimewo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -marge_piti),
            endikèt_nimewo.widthAnchor.constraint(equalToConstant: tay_bad),
            endikèt_nimewo.heightAnchor.constraint(equalToConstant: tay_bad)
        ])
    }

    // MARK: - Public API

    func konfigire(ak katyo: MahjongKatyo) {
        self.katyo = katyo

        let non_ressource = katyo.nonImaj
        zòn_imaj.image = UIImage(named: non_ressource)

        endikèt_nimewo.isHidden = true
        kouch_seleksyon.isHidden = true
    }

    func aficheNimewo(_ nimewo: Int) {
        endikèt_nimewo.text = String(nimewo)
        endikèt_nimewo.isHidden = false

        let transformasyon_inisyal = CGAffineTransform(scaleX: 0.1, y: 0.1)
        endikèt_nimewo.transform = transformasyon_inisyal
        endikèt_nimewo.alpha = 0

        AnimationUtilities.springAnimation(duration: 0.5, damping: 0.5, velocity: 1.0, animations: {
            self.endikèt_nimewo.transform = CGAffineTransform.identity
            self.endikèt_nimewo.alpha = 1
        })
        
        AnimationUtilities.pulseAnimation(view: endikèt_nimewo)
    }

    func kacheNimewo() {
        endikèt_nimewo.isHidden = true
    }

    // MARK: - Selection Visual Update

    private func aplike_chanjman_vizuèl() {
        let koulè_bòdè = UIColor(
            red: 51.0/255.0,
            green: 127.0/255.0,
            blue: 204.0/255.0,
            alpha: 1.0
        )

        if estSeleksyone {
            kouch_seleksyon.isHidden = false
            layer.borderWidth = 3
            layer.borderColor = koulè_bòdè.cgColor
        } else {
            kouch_seleksyon.isHidden = true
            layer.borderWidth = 0
            layer.borderColor = nil
        }
    }

    // MARK: - Animations

    func animeEntransAk(_ dekala: TimeInterval) {
        alpha = 0
        
        layer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(
            withDuration: 0.6,
            delay: dekala,
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
        let echèl_ogmante = CGAffineTransform(scaleX: 1.15, y: 1.15)
        let rotasyon = CATransform3DMakeRotation(.pi / 16, 0, 1, 0)
        
        AnimationUtilities.springAnimation(duration: 0.3, damping: 0.6, velocity: 0.8, animations: {
            self.transform = echèl_ogmante
            self.layer.transform = rotasyon
        }) { _ in
            AnimationUtilities.springAnimation(duration: 0.3, damping: 0.7, animations: {
                self.transform = .identity
                self.layer.transform = CATransform3DIdentity
            })
        }
        
        ajoute_lèm()
    }
    
    private func ajoute_lèm() {
        let kouch_lèm = CALayer()
        kouch_lèm.frame = bounds
        kouch_lèm.cornerRadius = layer.cornerRadius
        kouch_lèm.backgroundColor = DesignColors.successGradientStart.cgColor
        kouch_lèm.opacity = 0
        
        layer.insertSublayer(kouch_lèm, at: 0)
        
        let animasyon_lèm = CABasicAnimation(keyPath: "opacity")
        animasyon_lèm.fromValue = 0.6
        animasyon_lèm.toValue = 0
        animasyon_lèm.duration = 0.5
        animasyon_lèm.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        kouch_lèm.add(animasyon_lèm, forKey: "glow")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            kouch_lèm.removeFromSuperlayer()
        }
    }

    func animeErè() {
        let animasyon_sekous = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animasyon_sekous.timingFunction = CAMediaTimingFunction(name: .linear)
        animasyon_sekous.duration = 0.5

        let valè_dekala: [CGFloat] = [-12, 12, -8, 8, -4, 4, 0]
        animasyon_sekous.values = valè_dekala

        layer.add(animasyon_sekous, forKey: "shake")

        let koulè_erè = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.3)
        let koulè_orijinal = UIColor(white: 1.0, alpha: 1.0)

        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.backgroundColor = koulè_erè
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.backgroundColor = koulè_orijinal
                }
            }
        )
    }
}
