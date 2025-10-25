//
//  BoitDyalògPèsonalize.swift
//  GridMind
//
//  Custom Alert Dialog (BoitDyalòg = Dialog Box in Haitian Creole)
//

import UIKit

// MARK: - Dialog Configuration

struct KonfigiraskonDyalòg {
    let tikèt: String
    let mesaj: String
    let boutons: [SpecifikasyonBouton]

    struct SpecifikasyonBouton {
        let tèks: String
        let koulè: UIColor
        let aksyon: () -> Void
    }
}

// MARK: - Builder

class KonstryiktèDyalòg {
    private var tit_valè: String = ""
    private var mesaj_valè: String = ""
    private var list_bouton: [KonfigiraskonDyalòg.SpecifikasyonBouton] = []

    func avèkTikèt(_ tikèt: String) -> Self {
        self.tit_valè = tikèt
        return self
    }

    func avèkMesaj(_ mesaj: String) -> Self {
        self.mesaj_valè = mesaj
        return self
    }

    func ajouteBouton(tèks: String, koulè: UIColor, aksyon: @escaping () -> Void) -> Self {
        let spec = KonfigiraskonDyalòg.SpecifikasyonBouton(
            tèks: tèks,
            koulè: koulè,
            aksyon: aksyon
        )
        list_bouton.append(spec)
        return self
    }

    func konstryi() -> KonfigiraskonDyalòg {
        return KonfigiraskonDyalòg(
            tikèt: tit_valè,
            mesaj: mesaj_valè,
            boutons: list_bouton
        )
    }
}

// MARK: - Component Builder Protocol

fileprivate protocol BiltèKompozan {
    func kreye_kontènè() -> UIView
    func kreye_tikèt() -> UILabel
    func kreye_mesaj() -> UILabel
    func kreye_pilaj_bouton() -> UIStackView
}

// MARK: - Standard Builder

fileprivate struct BiltèStandard: BiltèKompozan {
    func kreye_kontènè() -> UIView {
        let kont = UIView()
        kont.backgroundColor = UIColor(white: 1.0, alpha: 0.98)
        kont.layer.cornerRadius = DesignRadius.xLarge
        kont.translatesAutoresizingMaskIntoConstraints = false
        
        kont.layer.borderWidth = 1.5
        kont.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        kont.layer.applyShadow(.large)
        
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.cornerRadius = DesignRadius.xLarge
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        kont.insertSubview(blurView, at: 0)

        return kont
    }

    func kreye_tikèt() -> UILabel {
        let lab = UILabel()
        lab.font = DesignTypography.title1
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.textColor = DesignColors.textPrimary
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }

    func kreye_mesaj() -> UILabel {
        let tèks = UILabel()
        tèks.font = DesignTypography.body
        tèks.textAlignment = .center
        tèks.numberOfLines = 0
        tèks.textColor = DesignColors.textSecondary
        tèks.translatesAutoresizingMaskIntoConstraints = false
        return tèks
    }

    func kreye_pilaj_bouton() -> UIStackView {
        let stak = UIStackView()
        stak.axis = .horizontal
        stak.distribution = .fillEqually
        stak.spacing = 12
        stak.translatesAutoresizingMaskIntoConstraints = false
        return stak
    }
}

// MARK: - Main Dialog View

class BoitDyalògPèsonalize: UIView {

    private let fabricatè: BiltèKompozan
    private lazy var zone_prinsipal = fabricatè.kreye_kontènè()
    private lazy var etikèt_tit = fabricatè.kreye_tikèt()
    private lazy var etikèt_mesaj = fabricatè.kreye_mesaj()
    private lazy var arrange_bouton = fabricatè.kreye_pilaj_bouton()
    private var akcyon_stoké: [() -> Void] = []

    override init(frame: CGRect) {
        self.fabricatè = BiltèStandard()
        super.init(frame: frame)
        prepare_interfas()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepare_interfas() {
        let opasité_fon = UIColor.black.withAlphaComponent(0.5)
        backgroundColor = opasité_fon
        alpha = 0

        addSubview(zone_prinsipal)
        
        if let blurView = zone_prinsipal.subviews.first as? UIVisualEffectView {
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: zone_prinsipal.topAnchor),
                blurView.leadingAnchor.constraint(equalTo: zone_prinsipal.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: zone_prinsipal.trailingAnchor),
                blurView.bottomAnchor.constraint(equalTo: zone_prinsipal.bottomAnchor)
            ])
        }
        
        zone_prinsipal.addSubview(etikèt_tit)
        zone_prinsipal.addSubview(etikèt_mesaj)
        zone_prinsipal.addSubview(arrange_bouton)

        let kontrènt_kont = [
            zone_prinsipal.centerXAnchor.constraint(equalTo: centerXAnchor),
            zone_prinsipal.centerYAnchor.constraint(equalTo: centerYAnchor),
            zone_prinsipal.widthAnchor.constraint(equalToConstant: 300),
            zone_prinsipal.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ]

        let kontrènt_tit = [
            etikèt_tit.topAnchor.constraint(equalTo: zone_prinsipal.topAnchor, constant: 30),
            etikèt_tit.leadingAnchor.constraint(equalTo: zone_prinsipal.leadingAnchor, constant: 20),
            etikèt_tit.trailingAnchor.constraint(equalTo: zone_prinsipal.trailingAnchor, constant: -20)
        ]

        let kontrènt_mesaj = [
            etikèt_mesaj.topAnchor.constraint(equalTo: etikèt_tit.bottomAnchor, constant: 16),
            etikèt_mesaj.leadingAnchor.constraint(equalTo: zone_prinsipal.leadingAnchor, constant: 20),
            etikèt_mesaj.trailingAnchor.constraint(equalTo: zone_prinsipal.trailingAnchor, constant: -20)
        ]

        let kontrènt_bouton = [
            arrange_bouton.topAnchor.constraint(equalTo: etikèt_mesaj.bottomAnchor, constant: 30),
            arrange_bouton.leadingAnchor.constraint(equalTo: zone_prinsipal.leadingAnchor, constant: 20),
            arrange_bouton.trailingAnchor.constraint(equalTo: zone_prinsipal.trailingAnchor, constant: -20),
            arrange_bouton.bottomAnchor.constraint(equalTo: zone_prinsipal.bottomAnchor, constant: -20),
            arrange_bouton.heightAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(kontrènt_kont + kontrènt_tit + kontrènt_mesaj + kontrènt_bouton)
    }

    func konfigure(tikèt: String, mesaj: String, bouton: [(tèks: String, koulè: UIColor, aksyon: () -> Void)]) {
        let lis_spec = bouton.map { elem in
            KonfigiraskonDyalòg.SpecifikasyonBouton(
                tèks: elem.tèks,
                koulè: elem.koulè,
                aksyon: elem.aksyon
            )
        }

        let konfig_total = KonfigiraskonDyalòg(
            tikèt: tikèt,
            mesaj: mesaj,
            boutons: lis_spec
        )

        aplike_konfig(konfig_total)
    }

    private func aplike_konfig(_ konfig: KonfigiraskonDyalòg) {
        etikèt_tit.text = konfig.tikèt
        etikèt_mesaj.text = konfig.mesaj

        arrange_bouton.arrangedSubviews.forEach { $0.removeFromSuperview() }
        akcyon_stoké = konfig.boutons.map { $0.aksyon }

        for (idx, spec_bouton) in konfig.boutons.enumerated() {
            let btn = monte_bouton(avèk: spec_bouton, tag: idx)
            arrange_bouton.addArrangedSubview(btn)
        }
    }

    private func monte_bouton(avèk spec: KonfigiraskonDyalòg.SpecifikasyonBouton, tag: Int) -> UIButton {
        let bouton = GradientButton()
        
        bouton.setTitle(spec.tèks, for: .normal)
        bouton.tag = tag
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [spec.koulè.cgColor, spec.koulè.darker().cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        bouton.setGradient(gradientLayer)

        bouton.addTarget(self, action: #selector(jere_klik(_:)), for: .touchUpInside)
        bouton.addTarget(self, action: #selector(jere_prese(_:)), for: .touchDown)
        bouton.addTarget(self, action: #selector(jere_lage(_:)), for: [.touchUpInside, .touchUpOutside])

        return bouton
    }

    @objc private func jere_klik(_ bouton: UIButton) {
        let tag_bouton = bouton.tag
        if tag_bouton >= 0 && tag_bouton < akcyon_stoké.count {
            akcyon_stoké[tag_bouton]()
        }
        kache()
    }

    @objc private func jere_prese(_ bouton: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.1, animations: {
            bouton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    @objc private func jere_lage(_ bouton: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.2, damping: 0.7, animations: {
            bouton.transform = CGAffineTransform.identity
        })
    }

    func afiche(nan vi: UIView) {
        vi.addSubview(self)
        self.frame = vi.bounds

        let transformasyon_depa = CGAffineTransform(scaleX: 0.7, y: 0.7)
        zone_prinsipal.transform = transformasyon_depa
        zone_prinsipal.alpha = 0

        AnimationUtilities.springAnimation(
            duration: 0.5,
            damping: 0.65,
            velocity: 0.8,
            animations: {
                self.alpha = 1
                self.zone_prinsipal.alpha = 1
                self.zone_prinsipal.transform = CGAffineTransform.identity
            }
        )
    }

    func kache() {
        let transformasyon_final = CGAffineTransform(scaleX: 0.7, y: 0.7)

        AnimationUtilities.springAnimation(
            duration: 0.3,
            damping: 0.8,
            animations: {
                self.alpha = 0
                self.zone_prinsipal.alpha = 0
                self.zone_prinsipal.transform = transformasyon_final
            },
            completion: { _ in
                self.removeFromSuperview()
            }
        )
    }
}

// MARK: - Factory Methods

extension BoitDyalògPèsonalize {
    static func aficheSiyès(nan vi: UIView, mesaj: String, pwen: Int? = nil, akerebouton: @escaping () -> Void) {
        var mesaj_konple = mesaj
        if let skor = pwen {
            mesaj_konple = "\(mesaj)\n\n🎉 +\(skor) points"
        }

        let konfig = KonstryiktèDyalòg()
            .avèkTikèt("🎊 Success!")
            .avèkMesaj(mesaj_konple)
            .ajouteBouton(
                tèks: "Continue",
                koulè: DesignColors.successGradientStart,
                aksyon: akerebouton
            )
            .konstryi()

        kreye_e_montre(konfig, nan: vi)
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

        kreye_e_montre(konfig, nan: vi)
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

        kreye_e_montre(konfig, nan: vi)
    }

    private static func kreye_e_montre(_ konfig: KonfigiraskonDyalòg, nan vi: UIView) {
        let dyalòg = BoitDyalògPèsonalize()
        dyalòg.aplike_konfig(konfig)
        dyalòg.afiche(nan: vi)
    }
}
