//
//  KatyoCellView.swift
//  GridMind
//
//  Mahjong Tile Cell View
//

import UIKit

class KatyoCellView: UIView {

    // MARK: - Properties
    private let imajVi: UIImageView = {
        let imajVi = UIImageView()
        imajVi.contentMode = .scaleAspectFit
        imajVi.translatesAutoresizingMaskIntoConstraints = false
        return imajVi
    }()

    private let etikètNimewo: UILabel = {
        let etikèt = UILabel()
        etikèt.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        etikèt.textColor = .white
        etikèt.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 0.95)
        etikèt.textAlignment = .center
        etikèt.layer.cornerRadius = 16
        etikèt.clipsToBounds = true
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        etikèt.isHidden = true
        return etikèt
    }()

    private let efèVizyèl: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        vi.layer.cornerRadius = 12
        vi.translatesAutoresizingMaskIntoConstraints = false
        vi.isHidden = true
        return vi
    }()

    var katyo: MahjongKatyo?
    var estSeleksyone: Bool = false {
        didSet {
            mizeAjouEfèSeleksyon()
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        konfigireUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Configuration
    private func konfigireUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4

        addSubview(imajVi)
        addSubview(efèVizyèl)
        addSubview(etikètNimewo)

        NSLayoutConstraint.activate([
            imajVi.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            imajVi.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            imajVi.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imajVi.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            efèVizyèl.topAnchor.constraint(equalTo: topAnchor),
            efèVizyèl.leadingAnchor.constraint(equalTo: leadingAnchor),
            efèVizyèl.trailingAnchor.constraint(equalTo: trailingAnchor),
            efèVizyèl.bottomAnchor.constraint(equalTo: bottomAnchor),

            etikètNimewo.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            etikètNimewo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            etikètNimewo.widthAnchor.constraint(equalToConstant: 32),
            etikètNimewo.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    // MARK: - Configuration
    func konfigire(ak katyo: MahjongKatyo) {
        self.katyo = katyo
        imajVi.image = UIImage(named: katyo.nonImaj)
        etikètNimewo.isHidden = true
        efèVizyèl.isHidden = true
    }

    func aficheNimewo(_ nimewo: Int) {
        etikètNimewo.text = "\(nimewo)"
        etikètNimewo.isHidden = false

        etikètNimewo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.etikètNimewo.transform = .identity
        }
    }

    func kacheNimewo() {
        etikètNimewo.isHidden = true
    }

    private func mizeAjouEfèSeleksyon() {
        if estSeleksyone {
            efèVizyèl.isHidden = false
            layer.borderWidth = 3
            layer.borderColor = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0).cgColor
        } else {
            efèVizyèl.isHidden = true
            layer.borderWidth = 0
        }
    }

    // MARK: - Animations
    func animeEntransAk(_ reta: TimeInterval) {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3).rotated(by: .pi / 4)

        UIView.animate(withDuration: 0.5, delay: reta, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
    }

    func animeSeleksyon() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }

    func animeErè() {
        let animasyon = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animasyon.timingFunction = CAMediaTimingFunction(name: .linear)
        animasyon.duration = 0.5
        animasyon.values = [-12, 12, -8, 8, -4, 4, 0]
        layer.add(animasyon, forKey: "shake")

        UIView.animate(withDuration: 0.1, animations: {
            self.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.3)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = .white
            }
        }
    }
}
