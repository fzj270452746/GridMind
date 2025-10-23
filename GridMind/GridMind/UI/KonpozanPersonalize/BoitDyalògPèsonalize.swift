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
    let boutons: [KonfigiraskonBoutonDyalòg]

    struct KonfigiraskonBoutonDyalòg {
        let tèks: String
        let koulè: UIColor
        let aksyon: () -> Void
    }
}

// MARK: - Dialog Builder

class KonstryiktèDyalòg {
    private var tikèt: String = ""
    private var mesaj: String = ""
    private var boutons: [KonfigiraskonDyalòg.KonfigiraskonBoutonDyalòg] = []

    func avèkTikèt(_ tikèt: String) -> Self {
        self.tikèt = tikèt
        return self
    }

    func avèkMesaj(_ mesaj: String) -> Self {
        self.mesaj = mesaj
        return self
    }

    func ajouteBouton(tèks: String, koulè: UIColor, aksyon: @escaping () -> Void) -> Self {
        boutons.append(.init(tèks: tèks, koulè: koulè, aksyon: aksyon))
        return self
    }

    func konstryi() -> KonfigiraskonDyalòg {
        .init(tikèt: tikèt, mesaj: mesaj, boutons: boutons)
    }
}

// MARK: - View Factory for Dialog Components

fileprivate protocol FactoryKonpozanDyalòg {
    func kreeKontènè() -> UIView
    func kreeTikèt() -> UILabel
    func kreeMesaj() -> UILabel
    func kreeStackBouton() -> UIStackView
}

fileprivate struct FactoryStandardDyalòg: FactoryKonpozanDyalòg {
    func kreeKontènè() -> UIView {
        let vi = UIView()
        vi.backgroundColor = .white
        vi.layer.cornerRadius = 24
        vi.layer.shadowColor = UIColor.black.cgColor
        vi.layer.shadowOffset = CGSize(width: 0, height: 10)
        vi.layer.shadowOpacity = 0.3
        vi.layer.shadowRadius = 20
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }

    func kreeTikèt() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func kreeMesaj() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func kreeStackBouton() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}

// MARK: - Main Dialog View

class BoitDyalògPèsonalize: UIView {

    private let factory: FactoryKonpozanDyalòg = FactoryStandardDyalòg()
    private lazy var kontènèVi = factory.kreeKontènè()
    private lazy var tikèt = factory.kreeTikèt()
    private lazy var mesaj = factory.kreeMesaj()
    private lazy var boutonPila = factory.kreeStackBouton()
    private var aksyonBouton: [() -> Void] = []

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
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        alpha = 0

        addSubview(kontènèVi)
        kontènèVi.addSubview(tikèt)
        kontènèVi.addSubview(mesaj)
        kontènèVi.addSubview(boutonPila)

        NSLayoutConstraint.activate([
            kontènèVi.centerXAnchor.constraint(equalTo: centerXAnchor),
            kontènèVi.centerYAnchor.constraint(equalTo: centerYAnchor),
            kontènèVi.widthAnchor.constraint(equalToConstant: 300),
            kontènèVi.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),

            tikèt.topAnchor.constraint(equalTo: kontènèVi.topAnchor, constant: 30),
            tikèt.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: 20),
            tikèt.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -20),

            mesaj.topAnchor.constraint(equalTo: tikèt.bottomAnchor, constant: 16),
            mesaj.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: 20),
            mesaj.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -20),

            boutonPila.topAnchor.constraint(equalTo: mesaj.bottomAnchor, constant: 30),
            boutonPila.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: 20),
            boutonPila.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -20),
            boutonPila.bottomAnchor.constraint(equalTo: kontènèVi.bottomAnchor, constant: -20),
            boutonPila.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func konfigure(tikèt: String, mesaj: String, bouton: [(tèks: String, koulè: UIColor, aksyon: () -> Void)]) {
        let konfig = KonfigiraskonDyalòg(
            tikèt: tikèt,
            mesaj: mesaj,
            boutons: bouton.map { .init(tèks: $0.tèks, koulè: $0.koulè, aksyon: $0.aksyon) }
        )
        aplikeKonfigirasyon(konfig)
    }

    private func aplikeKonfigirasyon(_ konfig: KonfigiraskonDyalòg) {
        tikèt.text = konfig.tikèt
        mesaj.text = konfig.mesaj
        boutonPila.arrangedSubviews.forEach { $0.removeFromSuperview() }
        aksyonBouton = konfig.boutons.map { $0.aksyon }

        konfig.boutons.enumerated().forEach { idx, btnKonfig in
            let btn = kreyeBouton(avèk: btnKonfig, tag: idx)
            boutonPila.addArrangedSubview(btn)
        }
    }

    private func kreyeBouton(
        avèk konfig: KonfigiraskonDyalòg.KonfigiraskonBoutonDyalòg,
        tag: Int
    ) -> UIButton {
        let btn = UIButton(type: .system)
        let aksyons: [(Selector, UIControl.Event)] = [
            (#selector(boutonTape(_:)), .touchUpInside),
            (#selector(boutonPreseAnba(_:)), .touchDown),
            (#selector(boutonLage(_:)), [.touchUpInside, .touchUpOutside])
        ]

        btn.setTitle(konfig.tèks, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        btn.backgroundColor = konfig.koulè
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        btn.tag = tag

        aksyons.forEach { btn.addTarget(self, action: $0.0, for: $0.1) }

        return btn
    }

    // MARK: - Actions
    @objc private func boutonTape(_ bouton: UIButton) {
        if bouton.tag < aksyonBouton.count {
            aksyonBouton[bouton.tag]()
        }
        kache()
    }

    @objc private func boutonPreseAnba(_ bouton: UIButton) {
        UIView.animate(withDuration: 0.1) {
            bouton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func boutonLage(_ bouton: UIButton) {
        UIView.animate(withDuration: 0.1) {
            bouton.transform = .identity
        }
    }

    // MARK: - Show/Hide
    func afiche(nan vi: UIView) {
        vi.addSubview(self)
        self.frame = vi.bounds

        kontènèVi.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.kontènèVi.transform = .identity
        }
    }

    func kache() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.kontènèVi.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - Convenience Factory Methods

extension BoitDyalògPèsonalize {
    static func aficheSiyès(
        nan vi: UIView,
        mesaj: String,
        pwen: Int? = nil,
        akerebouton: @escaping () -> Void
    ) {
        let mesajKonplè = pwen.map { mesaj + "\n\n🎉 +\($0) points" } ?? mesaj
        let konfig = KonstryiktèDyalòg()
            .avèkTikèt("🎊 Success!")
            .avèkMesaj(mesajKonplè)
            .ajouteBouton(
                tèks: "Continue",
                koulè: .init(red: 0.2, green: 0.7, blue: 0.5, alpha: 1.0),
                aksyon: akerebouton
            )
            .konstryi()

        let dyalòg = kreyeEAfiche(konfig: konfig, nan: vi)
        _ = dyalòg
    }

    static func aficheEchèk(
        nan vi: UIView,
        mesaj: String,
        reeseyeAksyon: @escaping () -> Void
    ) {
        let konfig = KonstryiktèDyalòg()
            .avèkTikèt("😔 Game Over")
            .avèkMesaj(mesaj)
            .ajouteBouton(
                tèks: "Try Again",
                koulè: .init(red: 0.9, green: 0.4, blue: 0.4, alpha: 1.0),
                aksyon: reeseyeAksyon
            )
            .konstryi()

        let dyalòg = kreyeEAfiche(konfig: konfig, nan: vi)
        _ = dyalòg
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
            .ajouteBouton(tèks: "Cancel", koulè: .lightGray, aksyon: anileAksyon)
            .ajouteBouton(
                tèks: "Confirm",
                koulè: .init(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0),
                aksyon: konfimeAksyon
            )
            .konstryi()

        let dyalòg = kreyeEAfiche(konfig: konfig, nan: vi)
        _ = dyalòg
    }

    private static func kreyeEAfiche(
        konfig: KonfigiraskonDyalòg,
        nan vi: UIView
    ) -> BoitDyalògPèsonalize {
        let dyalòg = BoitDyalògPèsonalize()
        dyalòg.aplikeKonfigirasyon(konfig)
        dyalòg.afiche(nan: vi)
        return dyalòg
    }
}
