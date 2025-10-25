//
//  BoitDyalògPèsonalize.swift
//  GridMind
//
//  Custom Alert Dialog (BoitDyalòg = Dialog Box in Haitian Creole)
//

import UIKit

// MARK: - Dialog Data Model

struct KonfigiraskonDyalòg {
    let tikèt: String
    let mesaj: String
    let boutons: [KonfigiraskonBoutonDyalòg]

    struct KonfigiraskonBoutonDyalòg {
        let tèks: String
        let koulè: UIColor
        let aksyon: () -> Void
    }
}

// MARK: - Builder Pattern

class KonstryiktèDyalòg {
    private var nonTikèt: String = ""
    private var tèksMesaj: String = ""
    private var listeBouton: [KonfigiraskonDyalòg.KonfigiraskonBoutonDyalòg] = []

    func avèkTikèt(_ tikèt: String) -> Self {
        self.nonTikèt = tikèt
        return self
    }

    func avèkMesaj(_ mesaj: String) -> Self {
        self.tèksMesaj = mesaj
        return self
    }

    func ajouteBouton(tèks: String, koulè: UIColor, aksyon: @escaping () -> Void) -> Self {
        let konfig = KonfigiraskonDyalòg.KonfigiraskonBoutonDyalòg(
            tèks: tèks,
            koulè: koulè,
            aksyon: aksyon
        )
        listeBouton.append(konfig)
        return self
    }

    func konstryi() -> KonfigiraskonDyalòg {
        return KonfigiraskonDyalòg(
            tikèt: nonTikèt,
            mesaj: tèksMesaj,
            boutons: listeBouton
        )
    }
}

// MARK: - Component Factory Protocol

fileprivate protocol FactoryKonpozanDyalòg {
    func kreeKontènè() -> UIView
    func kreeTikèt() -> UILabel
    func kreeMesaj() -> UILabel
    func kreeStackBouton() -> UIStackView
}

// MARK: - Standard Factory Implementation

fileprivate struct ImplemantasyonFactoryStandard: FactoryKonpozanDyalòg {
    func kreeKontènè() -> UIView {
        let kontenèPrènsipal = UIView()
        kontenèPrènsipal.backgroundColor = UIColor(white: 1.0, alpha: 0.98)
        kontenèPrènsipal.layer.cornerRadius = DesignRadius.xLarge
        kontenèPrènsipal.translatesAutoresizingMaskIntoConstraints = false
        
        // Modern glass effect with border
        kontenèPrènsipal.layer.borderWidth = 1.5
        kontenèPrènsipal.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        kontenèPrènsipal.layer.applyShadow(.large)
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = DesignRadius.xLarge
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        kontenèPrènsipal.insertSubview(blurView, at: 0)

        return kontenèPrènsipal
    }

    func kreeTikèt() -> UILabel {
        let label = UILabel()
        label.font = DesignTypography.title1
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = DesignColors.textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func kreeMesaj() -> UILabel {
        let tèks = UILabel()
        tèks.font = DesignTypography.body
        tèks.textAlignment = .center
        tèks.numberOfLines = 0
        tèks.textColor = DesignColors.textSecondary
        tèks.translatesAutoresizingMaskIntoConstraints = false
        return tèks
    }

    func kreeStackBouton() -> UIStackView {
        let pilaj = UIStackView()
        pilaj.axis = .horizontal
        pilaj.distribution = .fillEqually
        pilaj.spacing = 12
        pilaj.translatesAutoresizingMaskIntoConstraints = false
        return pilaj
    }
}

// MARK: - Custom Dialog View

class BoitDyalògPèsonalize: UIView {

    private let fabrikKompozan: FactoryKonpozanDyalòg
    private lazy var vizyelKontenè = fabrikKompozan.kreeKontènè()
    private lazy var labelTikèt = fabrikKompozan.kreeTikèt()
    private lazy var labelMesaj = fabrikKompozan.kreeMesaj()
    private lazy var stakBouton = fabrikKompozan.kreeStackBouton()
    private var reponsBouton: [() -> Void] = []

    override init(frame: CGRect) {
        self.fabrikKompozan = ImplemantasyonFactoryStandard()
        super.init(frame: frame)
        preparUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func preparUI() {
        let koulèFon = UIColor.black.withAlphaComponent(0.5)
        backgroundColor = koulèFon
        alpha = 0

        addSubview(vizyelKontenè)
        
        // Update blur view constraints if present
        if let blurView = vizyelKontenè.subviews.first as? UIVisualEffectView {
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: vizyelKontenè.topAnchor),
                blurView.leadingAnchor.constraint(equalTo: vizyelKontenè.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: vizyelKontenè.trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: vizyelKontenè.bottomAnchor)
            ])
        }
        
        vizyelKontenè.addSubview(labelTikèt)
        vizyelKontenè.addSubview(labelMesaj)
        vizyelKontenè.addSubview(stakBouton)

        let kontrèntKontenè = [
            vizyelKontenè.centerXAnchor.constraint(equalTo: centerXAnchor),
            vizyelKontenè.centerYAnchor.constraint(equalTo: centerYAnchor),
            vizyelKontenè.widthAnchor.constraint(equalToConstant: 300),
            vizyelKontenè.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ]

        let kontrèntTikèt = [
            labelTikèt.topAnchor.constraint(equalTo: vizyelKontenè.topAnchor, constant: 30),
            labelTikèt.leadingAnchor.constraint(equalTo: vizyelKontenè.leadingAnchor, constant: 20),
            labelTikèt.trailingAnchor.constraint(equalTo: vizyelKontenè.trailingAnchor, constant: -20)
        ]

        let kontrèntMesaj = [
            labelMesaj.topAnchor.constraint(equalTo: labelTikèt.bottomAnchor, constant: 16),
            labelMesaj.leadingAnchor.constraint(equalTo: vizyelKontenè.leadingAnchor, constant: 20),
            labelMesaj.trailingAnchor.constraint(equalTo: vizyelKontenè.trailingAnchor, constant: -20)
        ]

        let kontrèntBouton = [
            stakBouton.topAnchor.constraint(equalTo: labelMesaj.bottomAnchor, constant: 30),
            stakBouton.leadingAnchor.constraint(equalTo: vizyelKontenè.leadingAnchor, constant: 20),
            stakBouton.trailingAnchor.constraint(equalTo: vizyelKontenè.trailingAnchor, constant: -20),
            stakBouton.bottomAnchor.constraint(equalTo: vizyelKontenè.bottomAnchor, constant: -20),
            stakBouton.heightAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(kontrèntKontenè + kontrèntTikèt + kontrèntMesaj + kontrèntBouton)
    }

    func konfigure(tikèt: String, mesaj: String, bouton: [(tèks: String, koulè: UIColor, aksyon: () -> Void)]) {
        let listKonfig = bouton.map { elem in
            KonfigiraskonDyalòg.KonfigiraskonBoutonDyalòg(
                tèks: elem.tèks,
                koulè: elem.koulè,
                aksyon: elem.aksyon
            )
        }

        let konfigTotal = KonfigiraskonDyalòg(
            tikèt: tikèt,
            mesaj: mesaj,
            boutons: listKonfig
        )

        aplikeKonfigirasyon(konfigTotal)
    }

    private func aplikeKonfigirasyon(_ konfig: KonfigiraskonDyalòg) {
        labelTikèt.text = konfig.tikèt
        labelMesaj.text = konfig.mesaj

        stakBouton.arrangedSubviews.forEach { $0.removeFromSuperview() }
        reponsBouton = konfig.boutons.map { $0.aksyon }

        for (idx, konfiBouton) in konfig.boutons.enumerated() {
            let btn = konstruBouton(avèk: konfiBouton, tag: idx)
            stakBouton.addArrangedSubview(btn)
        }
    }

    private func konstruBouton(avèk konfig: KonfigiraskonDyalòg.KonfigiraskonBoutonDyalòg, tag: Int) -> UIButton {
        let bouton = GradientButton()
        
        bouton.setTitle(konfig.tèks, for: .normal)
        bouton.tag = tag
        
        // Create gradient based on color
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [konfig.koulè.cgColor, konfig.koulè.darker().cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        bouton.setGradient(gradientLayer)

        bouton.addTarget(self, action: #selector(jereKlikBouton(_:)), for: .touchUpInside)
        bouton.addTarget(self, action: #selector(jerePresBouton(_:)), for: .touchDown)
        bouton.addTarget(self, action: #selector(jereRelasBouton(_:)), for: [.touchUpInside, .touchUpOutside])

        return bouton
    }

    @objc private func jereKlikBouton(_ bouton: UIButton) {
        let tagBouton = bouton.tag
        if tagBouton >= 0 && tagBouton < reponsBouton.count {
            reponsBouton[tagBouton]()
        }
        kache()
    }

    @objc private func jerePresBouton(_ bouton: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.1, animations: {
            bouton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    @objc private func jereRelasBouton(_ bouton: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.2, damping: 0.7, animations: {
            bouton.transform = CGAffineTransform.identity
        })
    }

    func afiche(nan vi: UIView) {
        vi.addSubview(self)
        self.frame = vi.bounds

        let transformInisyal = CGAffineTransform(scaleX: 0.7, y: 0.7)
        vizyelKontenè.transform = transformInisyal
        vizyelKontenè.alpha = 0

        AnimationUtilities.springAnimation(
            duration: 0.5,
            damping: 0.65,
            velocity: 0.8,
            animations: {
                self.alpha = 1
                self.vizyelKontenè.alpha = 1
                self.vizyelKontenè.transform = CGAffineTransform.identity
            }
        )
    }

    func kache() {
        let transformFinal = CGAffineTransform(scaleX: 0.7, y: 0.7)

        AnimationUtilities.springAnimation(
            duration: 0.3,
            damping: 0.8,
            animations: {
                self.alpha = 0
                self.vizyelKontenè.alpha = 0
                self.vizyelKontenè.transform = transformFinal
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}

// MARK: - Factory Helper Methods

extension BoitDyalògPèsonalize {
    static func aficheSiyès(nan vi: UIView, mesaj: String, pwen: Int? = nil, akerebouton: @escaping () -> Void) {
        var mesajFinal = mesaj
        if let skorPwen = pwen {
            mesajFinal = "\(mesaj)\n\n🎉 +\(skorPwen) points"
        }

        let konfig = KonstryiktèDyalòg()
            .avèkTikèt("🎊 Success!")
            .avèkMesaj(mesajFinal)
            .ajouteBouton(
                tèks: "Continue",
                koulè: DesignColors.successGradientStart,
                aksyon: akerebouton
            )
            .konstryi()

        kreyeEAficheAvèkKonfig(konfig, nan: vi)
    }

    static func aficheEchèk(nan vi: UIView, mesaj: String, reeseyeAksyon: @escaping () -> Void) {
        let konfig = KonstryiktèDyalòg()
            .avèkTikèt("😔 Game Over")
            .avèkMesaj(mesaj)
            .ajouteBouton(
                tèks: "Try Again",
                koulè: DesignColors.accentGradientStart,
                aksyon: reeseyeAksyon
            )
            .konstryi()

        kreyeEAficheAvèkKonfig(konfig, nan: vi)
    }

    static func aficheKonfimmasyon(
        nan vi: UIView,
        tikèt: String,
        mesaj: String,
        konfimeAksyon: @escaping () -> Void,
        anileAksyon: @escaping () -> Void
    ) {
        let konfig = KonstryiktèDyalòg()
            .avèkTikèt(tikèt)
            .avèkMesaj(mesaj)
            .ajouteBouton(
                tèks: "Cancel",
                koulè: UIColor.lightGray,
                aksyon: anileAksyon
            )
            .ajouteBouton(
                tèks: "Confirm",
                koulè: DesignColors.primaryGradientStart,
                aksyon: konfimeAksyon
            )
            .konstryi()

        kreyeEAficheAvèkKonfig(konfig, nan: vi)
    }

    private static func kreyeEAficheAvèkKonfig(_ konfig: KonfigiraskonDyalòg, nan vi: UIView) {
        let dyalòg = BoitDyalògPèsonalize()
        dyalòg.aplikeKonfigirasyon(konfig)
        dyalòg.afiche(nan: vi)
    }
}
