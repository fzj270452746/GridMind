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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(white: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.isHidden = true

        label.backgroundColor = UIColor(
            red: 51.0/255.0,
            green: 127.0/255.0,
            blue: 204.0/255.0,
            alpha: 0.95
        )
        label.layer.cornerRadius = 16

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
        backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        layer.cornerRadius = 12

        let lonbrèPropryete = layer
        lonbrèPropryete.shadowColor = UIColor.black.cgColor
        lonbrèPropryete.shadowOffset = CGSize(width: 0, height: 2)
        lonbrèPropryete.shadowOpacity = 0.15
        lonbrèPropryete.shadowRadius = 4
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

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut,
            animations: {
                self.badNimewo.transform = CGAffineTransform.identity
            },
            completion: nil
        )
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

        let échel = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let wotasyon = CGFloat.pi / 4
        transform = échel.rotated(by: wotasyon)

        UIView.animate(
            withDuration: 0.5,
            delay: reta,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.alpha = 1
                self.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }

    func animeSeleksyon() {
        let transforme1 = CGAffineTransform(scaleX: 1.1, y: 1.1)

        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.transform = transforme1
            },
            completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform.identity
                }
            }
        )
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
