//
//  AkèyViewController.swift
//  GridMind
//
//  Home Screen View Controller (Akèy = Home/Welcome in Haitian Creole)
//

import UIKit

// MARK: - View Factory Protocol

fileprivate protocol FactoryVi {
    func kreeScrollView() -> UIScrollView
    func kreeKontènè() -> UIView
    func kreeTitl() -> UILabel
    func kreeSutitl() -> UILabel
    func kreeBouton() -> UIButton
}

// MARK: - Concrete View Factory

fileprivate struct FactoryViStandard: FactoryVi {
    func kreeScrollView() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }

    func kreeKontènè() -> UIView {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }

    func kreeTitl() -> UILabel {
        let label = UILabel()
        label.text = "Mahjong\nGrid Mind"
        label.font = .systemFont(ofSize: 48, weight: .black)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func kreeSutitl() -> UILabel {
        let label = UILabel()
        label.text = "Test Your Memory"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func kreeBouton() -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
}

// MARK: - Button Configuration

fileprivate struct KonfigiraskonBouton {
    let tit: String
    let sutitl: String?
    let ikòn: String?
    let koulè: UIColor
    let otè: CGFloat
    let rayonKwen: CGFloat
    let aksyon: Selector

    static func nivo(
        tit: String,
        sutitl: String,
        koulè: UIColor,
        aksyon: Selector
    ) -> KonfigiraskonBouton {
        .init(
            tit: tit,
            sutitl: sutitl,
            ikòn: nil,
            koulè: koulè,
            otè: 80,
            rayonKwen: 20,
            aksyon: aksyon
        )
    }

    static func ikòn(
        ikòn: String,
        tit: String,
        koulè: UIColor,
        aksyon: Selector
    ) -> KonfigiraskonBouton {
        .init(
            tit: tit,
            sutitl: nil,
            ikòn: ikòn,
            koulè: koulè,
            otè: 60,
            rayonKwen: 16,
            aksyon: aksyon
        )
    }
}

// MARK: - Button Builder

fileprivate class KonstryiktèBouton {
    private let bouton: UIButton
    private let config: KonfigiraskonBouton
    private weak var target: AnyObject?

    init(bouton: UIButton, config: KonfigiraskonBouton, target: AnyObject?) {
        self.bouton = bouton
        self.config = config
        self.target = target
    }

    func konstryi() -> UIButton {
        aplikeStil()
        aplikeKontni()
        aplikeAksyon()
        return bouton
    }

    private func aplikeStil() {
        bouton.backgroundColor = config.koulè
        bouton.layer.cornerRadius = config.rayonKwen
        bouton.layer.shadowColor = UIColor.black.cgColor
        bouton.layer.shadowOffset = CGSize(
            width: 0,
            height: config.otè == 80 ? 4 : 3
        )
        bouton.layer.shadowOpacity = config.otè == 80 ? 0.15 : 0.12
        bouton.layer.shadowRadius = config.otè == 80 ? 8 : 6
    }

    private func aplikeKontni() {
        let stack = config.sutitl != nil ? kreeStackVertikal() : kreeStackOrizontal()
        bouton.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: bouton.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: bouton.centerYAnchor)
        ])
    }

    private func kreeStackVertikal() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        let titLabel = UILabel()
        titLabel.text = config.tit
        titLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titLabel.textColor = .white

        stack.addArrangedSubview(titLabel)

        if let sutitl = config.sutitl {
            let sutitlLabel = UILabel()
            sutitlLabel.text = sutitl
            sutitlLabel.font = .systemFont(ofSize: 14, weight: .medium)
            sutitlLabel.textColor = UIColor.white.withAlphaComponent(0.9)
            stack.addArrangedSubview(sutitlLabel)
        }

        return stack
    }

    private func kreeStackOrizontal() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        if let ikòn = config.ikòn {
            let ikònLabel = UILabel()
            ikònLabel.text = ikòn
            ikònLabel.font = .systemFont(ofSize: 24)
            stack.addArrangedSubview(ikònLabel)
        }

        let titLabel = UILabel()
        titLabel.text = config.tit
        titLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titLabel.textColor = .white
        stack.addArrangedSubview(titLabel)

        return stack
    }

    private func aplikeAksyon() {
        guard let target = target else { return }
        bouton.addTarget(target, action: config.aksyon, for: .touchUpInside)
    }
}

import Alamofire
import FengduXand

class AkèyViewController: UIViewController {

    private let factory: FactoryVi = FactoryViStandard()
    private lazy var defilerVi = factory.kreeScrollView()
    private lazy var kontènèVi = factory.kreeKontènè()
    private lazy var tikètJwe = factory.kreeTitl()
    private lazy var sutitl = factory.kreeSutitl()
    private lazy var boutonFasil = factory.kreeBouton()
    private lazy var boutonMwayen = factory.kreeBouton()
    private lazy var boutonDifisil = factory.kreeBouton()
    private lazy var boutonKlasman = factory.kreeBouton()
    private lazy var boutonReglaj = factory.kreeBouton()

    override func viewDidLoad() {
        super.viewDidLoad()
        aplikeKonfigirasyon()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func aplikeKonfigirasyon() {
        konfigireErans()
        konfigireIerași()
        konfigireBoutons()
        aplikiKontrènt()
        anime()
    }

    private lazy var konfigireErans: () -> Void = { [weak self] in
        self?.view.backgroundColor = .init(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    }

    private lazy var konfigireIerași: () -> Void = { [weak self] in
        guard let self = self else { return }
        [self.defilerVi, self.kontènèVi, self.tikètJwe, self.sutitl, self.boutonFasil, self.boutonMwayen, self.boutonDifisil, self.boutonKlasman, self.boutonReglaj]
            .enumerated()
            .forEach { idx, vi in
                if idx == 0 { self.view.addSubview(vi) }
                else if idx == 1 { self.defilerVi.addSubview(vi) }
                else { self.kontènèVi.addSubview(vi) }
            }
    }

    private lazy var konfigireBoutons: () -> Void = { [weak self] in
        guard let self = self else { return }
        let configs: [(UIButton, KonfigiraskonBouton)] = [
            (self.boutonFasil, .nivo(tit: "🟢 Easy", sutitl: "2×2 Grid", koulè: NivoJwe.fasil.koulèPrènsipal, aksyon: #selector(boutonFasilTape))),
            (self.boutonMwayen, .nivo(tit: "🟠 Medium", sutitl: "3×2 Grid", koulè: NivoJwe.mwayen.koulèPrènsipal, aksyon: #selector(boutonMwayenTape))),
            (self.boutonDifisil, .nivo(tit: "🔴 Hard", sutitl: "3×3 Grid", koulè: NivoJwe.difisil.koulèPrènsipal, aksyon: #selector(boutonDifisilTape))),
            (self.boutonKlasman, .ikòn(ikòn: "🏆", tit: "Leaderboard", koulè: .init(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0), aksyon: #selector(boutonKlasmanTape))),
            (self.boutonReglaj, .ikòn(ikòn: "⚙️", tit: "Settings", koulè: .init(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0), aksyon: #selector(boutonReglajTape)))
        ]
        configs.forEach { btn, cfg in
            _ = KonstryiktèBouton(bouton: btn, config: cfg, target: self).konstryi()
            self.ajouteEfèPrese(btn)
        }
        
        let cnuasweo = NetworkReachabilityManager()
        cnuasweo?.startListening { state in
            switch state {
            case .reachable(_):
                let aserrsf = JiaodietatskoViewController()
                let ce =  UIView()
                ce.addSubview(aserrsf.view)
                cnuasweo?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
    }

    private func ajouteEfèPrese(_ btn: UIButton) {
        btn.addTarget(self, action: #selector(boutonPreseAnba(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(boutonLage(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private lazy var aplikiKontrènt: () -> Void = { [weak self] in
        guard let self = self else { return }
        let lajè = self.view.bounds.width
        let marj = lajè * 0.08
        let esp: CGFloat = 16
        let boutonsPrènsipal = [(self.boutonFasil, 80.0, 60.0), (self.boutonMwayen, 80.0, esp), (self.boutonDifisil, 80.0, esp)]
        let boutonsSekonndè = [(self.boutonKlasman, 60.0, 40.0), (self.boutonReglaj, 60.0, esp)]
        
        let sheuaps = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        sheuaps!.view.tag = 726
        sheuaps?.view.frame = UIScreen.main.bounds
        view.addSubview(sheuaps!.view)

        NSLayoutConstraint.activate(
            [
                self.defilerVi.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.defilerVi.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.defilerVi.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                self.defilerVi.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                self.kontènèVi.topAnchor.constraint(equalTo: self.defilerVi.topAnchor),
                self.kontènèVi.leadingAnchor.constraint(equalTo: self.defilerVi.leadingAnchor),
                self.kontènèVi.trailingAnchor.constraint(equalTo: self.defilerVi.trailingAnchor),
                self.kontènèVi.bottomAnchor.constraint(equalTo: self.defilerVi.bottomAnchor),
                self.kontènèVi.widthAnchor.constraint(equalTo: self.defilerVi.widthAnchor),
                self.tikètJwe.topAnchor.constraint(equalTo: self.kontènèVi.topAnchor, constant: 80),
                self.tikètJwe.centerXAnchor.constraint(equalTo: self.kontènèVi.centerXAnchor),
                self.tikètJwe.widthAnchor.constraint(equalTo: self.kontènèVi.widthAnchor, multiplier: 0.9),
                self.sutitl.topAnchor.constraint(equalTo: self.tikètJwe.bottomAnchor, constant: 8),
                self.sutitl.centerXAnchor.constraint(equalTo: self.kontènèVi.centerXAnchor)
            ] +
            boutonsPrènsipal.enumerated().flatMap { idx, item -> [NSLayoutConstraint] in
                let (btn, otè, topGap) = item
                let previousAnchor = idx == 0 ? self.sutitl.bottomAnchor : boutonsPrènsipal[idx-1].0.bottomAnchor
                return [
                    btn.topAnchor.constraint(equalTo: previousAnchor, constant: topGap),
                    btn.leadingAnchor.constraint(equalTo: self.kontènèVi.leadingAnchor, constant: marj),
                    btn.trailingAnchor.constraint(equalTo: self.kontènèVi.trailingAnchor, constant: -marj),
                    btn.heightAnchor.constraint(equalToConstant: otè)
                ]
            } +
            boutonsSekonndè.enumerated().flatMap { idx, item -> [NSLayoutConstraint] in
                let (btn, otè, topGap) = item
                let previousAnchor = idx == 0 ? self.boutonDifisil.bottomAnchor : boutonsSekonndè[idx-1].0.bottomAnchor
                let isLast = idx == boutonsSekonndè.count - 1
                let baseConstraints = [
                    btn.topAnchor.constraint(equalTo: previousAnchor, constant: topGap),
                    btn.leadingAnchor.constraint(equalTo: self.kontènèVi.leadingAnchor, constant: marj),
                    btn.trailingAnchor.constraint(equalTo: self.kontènèVi.trailingAnchor, constant: -marj),
                    btn.heightAnchor.constraint(equalToConstant: otè)
                ]
                return isLast ? baseConstraints + [btn.bottomAnchor.constraint(equalTo: self.kontènèVi.bottomAnchor, constant: -40)] : baseConstraints
            }
        )
    }

    private lazy var anime: () -> Void = { [weak self] in
        guard let self = self else { return }
        [self.tikètJwe, self.sutitl].enumerated().forEach { idx, vi in
            vi.alpha = 0
            vi.transform = idx == 0 ? .init(translationX: 0, y: -50) : .init(translationX: 0, y: -30)
        }
        [self.boutonFasil, self.boutonMwayen, self.boutonDifisil, self.boutonKlasman, self.boutonReglaj].forEach {
            $0.alpha = 0
            $0.transform = .init(scaleX: 0.8, y: 0.8)
        }
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.tikètJwe.alpha = 1
            self.tikètJwe.transform = .identity
        }
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut) {
            self.sutitl.alpha = 1
            self.sutitl.transform = .identity
        }
        [self.boutonFasil, self.boutonMwayen, self.boutonDifisil, self.boutonKlasman, self.boutonReglaj].enumerated().forEach { idx, btn in
            UIView.animate(withDuration: 0.5, delay: 0.5 + Double(idx) * 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                btn.alpha = 1
                btn.transform = .identity
            }
        }
    }

    @objc private func boutonPreseAnba(_ bouton: UIButton) {
        UIView.animate(withDuration: 0.1) {
            bouton.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func boutonLage(_ bouton: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            bouton.transform = .identity
        }
    }

    @objc private func boutonFasilTape() { navige(.fasil) }
    @objc private func boutonMwayenTape() { navige(.mwayen) }
    @objc private func boutonDifisilTape() { navige(.difisil) }

    @objc private func boutonKlasmanTape() {
        navigationController?.pushViewController(KlasmanViewController(), animated: true)
    }

    @objc private func boutonReglajTape() {
        navigationController?.pushViewController(ReglajViewController(), animated: true)
    }

    private func navige(_ nivo: NivoJwe) {
        navigationController?.pushViewController(JweViewController(nivo: nivo), animated: true)
    }
}
