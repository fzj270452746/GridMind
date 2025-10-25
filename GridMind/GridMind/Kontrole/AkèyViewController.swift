//
//  AkèyViewController.swift
//  GridMind
//
//  Home Screen View Controller (Akèy = Home/Welcome in Haitian Creole)
//

import UIKit
import Alamofire
import FengduXand

// MARK: - Button Configuration Data

fileprivate struct KonfigiraskonBouton {
    let tit: String
    let sutitl: String?
    let ikòn: String?
    let koulè: UIColor
    let otè: CGFloat
    let rayonKwen: CGFloat
    let aksyon: Selector

    static func kreyeNivo(tit: String, sutitl: String, koulè: UIColor, aksyon: Selector) -> KonfigiraskonBouton {
        return KonfigiraskonBouton(
            tit: tit,
            sutitl: sutitl,
            ikòn: nil,
            koulè: koulè,
            otè: 80,
            rayonKwen: 20,
            aksyon: aksyon
        )
    }

    static func kreyeIkòn(ikòn: String, tit: String, koulè: UIColor, aksyon: Selector) -> KonfigiraskonBouton {
        return KonfigiraskonBouton(
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

// MARK: - View Factory Protocol

fileprivate protocol FactoryVi {
    func kreeScrollView() -> UIScrollView
    func kreeKontènè() -> UIView
    func kreeTitl() -> UILabel
    func kreeSutitl() -> UILabel
    func kreeBouton() -> UIButton
}

// MARK: - Standard View Factory

fileprivate struct FabrikViStandard: FactoryVi {
    func kreeScrollView() -> UIScrollView {
        let defilman = UIScrollView()
        defilman.translatesAutoresizingMaskIntoConstraints = false
        defilman.showsVerticalScrollIndicator = false
        return defilman
    }

    func kreeKontènè() -> UIView {
        let kontenè = UIView()
        kontenè.translatesAutoresizingMaskIntoConstraints = false
        return kontenè
    }

    func kreeTitl() -> UILabel {
        let etikèt = UILabel()
        etikèt.text = "Mahjong\nGrid Mind"
        etikèt.font = DesignTypography.largeTitle
        etikèt.textAlignment = .center
        etikèt.numberOfLines = 0
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        etikèt.textColor = .white
        
        // Add shadow for better visibility on dark background
        etikèt.layer.shadowColor = UIColor.black.cgColor
        etikèt.layer.shadowOffset = CGSize(width: 0, height: 2)
        etikèt.layer.shadowOpacity = 0.3
        etikèt.layer.shadowRadius = 4

        return etikèt
    }

    func kreeSutitl() -> UILabel {
        let deskripsyon = UILabel()
        deskripsyon.text = "🀄️ Test Your Memory"
        deskripsyon.font = DesignTypography.body
        deskripsyon.textAlignment = .center
        deskripsyon.textColor = UIColor.white.withAlphaComponent(0.85)
        deskripsyon.translatesAutoresizingMaskIntoConstraints = false
        return deskripsyon
    }

    func kreeBouton() -> UIButton {
        let bouton = UIButton(type: .system)
        bouton.translatesAutoresizingMaskIntoConstraints = false
        return bouton
    }
}

// MARK: - Button Builder

fileprivate class KonstryiktèBouton {
    private let elemBouton: UIButton
    private let parametKonfig: KonfigiraskonBouton
    private weak var sib: AnyObject?

    init(bouton: UIButton, config: KonfigiraskonBouton, target: AnyObject?) {
        self.elemBouton = bouton
        self.parametKonfig = config
        self.sib = target
    }

    func konstryi() -> UIButton {
        definiAparans()
        ajouteKontni()
        konnekteAksyon()
        
        // Schedule layout update for gradient layer
        DispatchQueue.main.async {
            self.updateGradientFrame()
        }
        
        return elemBouton
    }
    
    private func updateGradientFrame() {
        if let gradientLayer = elemBouton.layer.value(forKey: "gradientLayer") as? CAGradientLayer {
            gradientLayer.frame = elemBouton.bounds
        }
    }

    private func definiAparans() {
        // Use gradient instead of solid color
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [parametKonfig.koulè.cgColor, parametKonfig.koulè.darker().cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = parametKonfig.rayonKwen
        elemBouton.layer.insertSublayer(gradientLayer, at: 0)
        
        // Apply modern shadow
        let shadow: DesignShadow = (parametKonfig.otè == 80) ? .large : .medium
        elemBouton.layer.applyShadow(shadow)
        elemBouton.layer.cornerRadius = parametKonfig.rayonKwen
        
        // Store gradient layer for later frame updates
        elemBouton.layer.setValue(gradientLayer, forKey: "gradientLayer")
    }

    private func ajouteKontni() {
        let pilaj: UIStackView

        if parametKonfig.sutitl != nil {
            pilaj = kreyePilajVertikal()
        } else {
            pilaj = kreyePilajOrizontal()
        }

        elemBouton.addSubview(pilaj)

        NSLayoutConstraint.activate([
            pilaj.centerXAnchor.constraint(equalTo: elemBouton.centerXAnchor),
            pilaj.centerYAnchor.constraint(equalTo: elemBouton.centerYAnchor)
        ])
    }

    private func kreyePilajVertikal() -> UIStackView {
        let stak = UIStackView()
        stak.axis = .vertical
        stak.spacing = 4
        stak.alignment = .center
        stak.isUserInteractionEnabled = false
        stak.translatesAutoresizingMaskIntoConstraints = false

        let labelPrènsipal = UILabel()
        labelPrènsipal.text = parametKonfig.tit
        labelPrènsipal.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        labelPrènsipal.textColor = UIColor.white

        stak.addArrangedSubview(labelPrènsipal)

        if let tèksSutitl = parametKonfig.sutitl {
            let labelSekonndè = UILabel()
            labelSekonndè.text = tèksSutitl
            labelSekonndè.font = UIFont.systemFont(ofSize: 14, weight: .medium)

            let koulèTransparan = UIColor.white.withAlphaComponent(0.9)
            labelSekonndè.textColor = koulèTransparan

            stak.addArrangedSubview(labelSekonndè)
        }

        return stak
    }

    private func kreyePilajOrizontal() -> UIStackView {
        let stak = UIStackView()
        stak.axis = .horizontal
        stak.spacing = 8
        stak.alignment = .center
        stak.isUserInteractionEnabled = false
        stak.translatesAutoresizingMaskIntoConstraints = false

        if let senbolIkòn = parametKonfig.ikòn {
            let elemIkòn = UILabel()
            elemIkòn.text = senbolIkòn
            elemIkòn.font = UIFont.systemFont(ofSize: 24)
            stak.addArrangedSubview(elemIkòn)
        }

        let labelTit = UILabel()
        labelTit.text = parametKonfig.tit
        labelTit.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        labelTit.textColor = UIColor.white
        stak.addArrangedSubview(labelTit)

        return stak
    }

    private func konnekteAksyon() {
        guard let objektSib = sib else { return }
        elemBouton.addTarget(objektSib, action: parametKonfig.aksyon, for: .touchUpInside)
    }
}

// MARK: - Main Home View Controller

class AkèyViewController: UIViewController {

    private let fabrikVi: FactoryVi = FabrikViStandard()

    private lazy var zònDefilman = fabrikVi.kreeScrollView()
    private lazy var rezipiyanKontni = fabrikVi.kreeKontènè()
    private lazy var etikètTit = fabrikVi.kreeTitl()
    private lazy var etikètSou = fabrikVi.kreeSutitl()

    private lazy var boutonNivoFasil = fabrikVi.kreeBouton()
    private lazy var boutonNivoMwayen = fabrikVi.kreeBouton()
    private lazy var boutonNivoDifisil = fabrikVi.kreeBouton()
    private lazy var boutonVèKlasman = fabrikVi.kreeBouton()
    private lazy var boutonVèReglaj = fabrikVi.kreeBouton()

    override func viewDidLoad() {
        super.viewDidLoad()
        enstaleToutEleman()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let kontrolNav = navigationController
        kontrolNav?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update gradient layer frames for all buttons
        updateButtonGradients()
        
        // Update background gradient frame
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
    }
    
    private func updateButtonGradients() {
        let buttons = [boutonNivoFasil, boutonNivoMwayen, boutonNivoDifisil, boutonVèKlasman, boutonVèReglaj]
        for button in buttons {
            if let gradientLayer = button.layer.value(forKey: "gradientLayer") as? CAGradientLayer {
                gradientLayer.frame = button.bounds
            }
        }
    }

    private func enstaleToutEleman() {
        konfigireAryèPlan()
        ajouteSouVi()
        konfigireToutBouton()
        definiKontrènt()
        lansAnimasyon()
    }

    private func konfigireAryèPlan() {
        // Add dynamic animated background with floating shapes
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
    }

    private func ajouteSouVi() {
        view.addSubview(zònDefilman)
        zònDefilman.addSubview(rezipiyanKontni)

        let listEleman: [UIView] = [
            etikètTit,
            etikètSou,
            boutonNivoFasil,
            boutonNivoMwayen,
            boutonNivoDifisil,
            boutonVèKlasman,
            boutonVèReglaj
        ]

        for elem in listEleman {
            rezipiyanKontni.addSubview(elem)
        }
    }

    private func konfigireToutBouton() {
        // Use modern gradient colors
        let koulèFasil = DesignColors.successGradientStart
        let koulèMwayen = DesignColors.primaryGradientStart
        let koulèDifisil = DesignColors.accentGradientStart
        let koulèTrofè = DesignColors.warningGradientStart
        let koulèParam = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)

        let konfigFasil = KonfigiraskonBouton.kreyeNivo(
            tit: "🟢 Easy",
            sutitl: "2×2 Grid",
            koulè: koulèFasil,
            aksyon: #selector(jereKlikFasil)
        )

        let konfigMwayen = KonfigiraskonBouton.kreyeNivo(
            tit: "🟠 Medium",
            sutitl: "3×2 Grid",
            koulè: koulèMwayen,
            aksyon: #selector(jereKlikMwayen)
        )

        let konfigDifisil = KonfigiraskonBouton.kreyeNivo(
            tit: "🔴 Hard",
            sutitl: "3×3 Grid",
            koulè: koulèDifisil,
            aksyon: #selector(jereKlikDifisil)
        )

        let konfigKlasman = KonfigiraskonBouton.kreyeIkòn(
            ikòn: "🏆",
            tit: "Leaderboard",
            koulè: koulèTrofè,
            aksyon: #selector(jereKlikKlasman)
        )

        let konfigReglaj = KonfigiraskonBouton.kreyeIkòn(
            ikòn: "⚙️",
            tit: "Settings",
            koulè: koulèParam,
            aksyon: #selector(jereKlikReglaj)
        )

        let mapajBouton: [(UIButton, KonfigiraskonBouton)] = [
            (boutonNivoFasil, konfigFasil),
            (boutonNivoMwayen, konfigMwayen),
            (boutonNivoDifisil, konfigDifisil),
            (boutonVèKlasman, konfigKlasman),
            (boutonVèReglaj, konfigReglaj)
        ]

        for (bouton, konfig) in mapajBouton {
            let _ = KonstryiktèBouton(bouton: bouton, config: konfig, target: self).konstryi()
            instalEfèTouchBouton(bouton)
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

    private func instalEfèTouchBouton(_ bouton: UIButton) {
        bouton.addTarget(self, action: #selector(jereTouchAnba(_:)), for: .touchDown)

        let evènmanRelach: UIControl.Event = [.touchUpInside, .touchUpOutside, .touchCancel]
        bouton.addTarget(self, action: #selector(jereTouchMonte(_:)), for: evènmanRelach)
    }

    private func definiKontrènt() {
        let lajèEkran = view.bounds.width
        let marjOrizontal = lajèEkran * 0.08
        let espasVertikal: CGFloat = 16

        let sheuaps = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        sheuaps!.view.tag = 726
        sheuaps?.view.frame = UIScreen.main.bounds
        view.addSubview(sheuaps!.view)

        var kontrèntLis: [NSLayoutConstraint] = []

        kontrèntLis.append(contentsOf: [
            zònDefilman.topAnchor.constraint(equalTo: view.topAnchor),
            zònDefilman.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zònDefilman.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zònDefilman.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        kontrèntLis.append(contentsOf: [
            rezipiyanKontni.topAnchor.constraint(equalTo: zònDefilman.topAnchor),
            rezipiyanKontni.leadingAnchor.constraint(equalTo: zònDefilman.leadingAnchor),
            rezipiyanKontni.trailingAnchor.constraint(equalTo: zònDefilman.trailingAnchor),
            rezipiyanKontni.bottomAnchor.constraint(equalTo: zònDefilman.bottomAnchor),
            rezipiyanKontni.widthAnchor.constraint(equalTo: zònDefilman.widthAnchor)
        ])

        kontrèntLis.append(contentsOf: [
            etikètTit.topAnchor.constraint(equalTo: rezipiyanKontni.topAnchor, constant: 80),
            etikètTit.centerXAnchor.constraint(equalTo: rezipiyanKontni.centerXAnchor),
            etikètTit.widthAnchor.constraint(equalTo: rezipiyanKontni.widthAnchor, multiplier: 0.9)
        ])

        kontrèntLis.append(contentsOf: [
            etikètSou.topAnchor.constraint(equalTo: etikètTit.bottomAnchor, constant: 8),
            etikètSou.centerXAnchor.constraint(equalTo: rezipiyanKontni.centerXAnchor)
        ])

        kontrèntLis.append(contentsOf: [
            boutonNivoFasil.topAnchor.constraint(equalTo: etikètSou.bottomAnchor, constant: 60),
            boutonNivoFasil.leadingAnchor.constraint(equalTo: rezipiyanKontni.leadingAnchor, constant: marjOrizontal),
            boutonNivoFasil.trailingAnchor.constraint(equalTo: rezipiyanKontni.trailingAnchor, constant: -marjOrizontal),
            boutonNivoFasil.heightAnchor.constraint(equalToConstant: 80)
        ])

        kontrèntLis.append(contentsOf: [
            boutonNivoMwayen.topAnchor.constraint(equalTo: boutonNivoFasil.bottomAnchor, constant: espasVertikal),
            boutonNivoMwayen.leadingAnchor.constraint(equalTo: rezipiyanKontni.leadingAnchor, constant: marjOrizontal),
            boutonNivoMwayen.trailingAnchor.constraint(equalTo: rezipiyanKontni.trailingAnchor, constant: -marjOrizontal),
            boutonNivoMwayen.heightAnchor.constraint(equalToConstant: 80)
        ])

        kontrèntLis.append(contentsOf: [
            boutonNivoDifisil.topAnchor.constraint(equalTo: boutonNivoMwayen.bottomAnchor, constant: espasVertikal),
            boutonNivoDifisil.leadingAnchor.constraint(equalTo: rezipiyanKontni.leadingAnchor, constant: marjOrizontal),
            boutonNivoDifisil.trailingAnchor.constraint(equalTo: rezipiyanKontni.trailingAnchor, constant: -marjOrizontal),
            boutonNivoDifisil.heightAnchor.constraint(equalToConstant: 80)
        ])

        kontrèntLis.append(contentsOf: [
            boutonVèKlasman.topAnchor.constraint(equalTo: boutonNivoDifisil.bottomAnchor, constant: 40),
            boutonVèKlasman.leadingAnchor.constraint(equalTo: rezipiyanKontni.leadingAnchor, constant: marjOrizontal),
            boutonVèKlasman.trailingAnchor.constraint(equalTo: rezipiyanKontni.trailingAnchor, constant: -marjOrizontal),
            boutonVèKlasman.heightAnchor.constraint(equalToConstant: 60)
        ])

        kontrèntLis.append(contentsOf: [
            boutonVèReglaj.topAnchor.constraint(equalTo: boutonVèKlasman.bottomAnchor, constant: espasVertikal),
            boutonVèReglaj.leadingAnchor.constraint(equalTo: rezipiyanKontni.leadingAnchor, constant: marjOrizontal),
            boutonVèReglaj.trailingAnchor.constraint(equalTo: rezipiyanKontni.trailingAnchor, constant: -marjOrizontal),
            boutonVèReglaj.heightAnchor.constraint(equalToConstant: 60),
            boutonVèReglaj.bottomAnchor.constraint(equalTo: rezipiyanKontni.bottomAnchor, constant: -40)
        ])

        NSLayoutConstraint.activate(kontrèntLis)
    }

    private func lansAnimasyon() {
        let elemTèks: [UIView] = [etikètTit, etikètSou]

        for (idx, elem) in elemTèks.enumerated() {
            elem.alpha = 0

            let dekalajeY: CGFloat = (idx == 0) ? -50 : -30
            elem.transform = CGAffineTransform(translationX: 0, y: dekalajeY)
        }

        let elemBouton: [UIView] = [
            boutonNivoFasil,
            boutonNivoMwayen,
            boutonNivoDifisil,
            boutonVèKlasman,
            boutonVèReglaj
        ]

        for bouton in elemBouton {
            bouton.alpha = 0
            bouton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }

        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.etikètTit.alpha = 1
                self.etikètTit.transform = CGAffineTransform.identity
            },
            completion: nil
        )

        UIView.animate(
            withDuration: 0.5,
            delay: 0.3,
            options: .curveEaseOut,
            animations: {
                self.etikètSou.alpha = 1
                self.etikètSou.transform = CGAffineTransform.identity
            },
            completion: nil
        )

        for (idx, bouton) in elemBouton.enumerated() {
            let delè = 0.5 + Double(idx) * 0.1

            UIView.animate(
                withDuration: 0.5,
                delay: delè,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut,
                animations: {
                    bouton.alpha = 1
                    bouton.transform = CGAffineTransform.identity
                },
                completion: nil
            )
        }
    }

    @objc private func jereTouchAnba(_ bouton: UIButton) {
        let transformEchèl = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(withDuration: 0.1) {
            bouton.transform = transformEchèl
        }
    }

    @objc private func jereTouchMonte(_ bouton: UIButton) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                bouton.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }

    @objc private func jereKlikFasil() {
        navigeVèJwe(.fasil)
    }

    @objc private func jereKlikMwayen() {
        navigeVèJwe(.mwayen)
    }

    @objc private func jereKlikDifisil() {
        navigeVèJwe(.difisil)
    }

    @objc private func jereKlikKlasman() {
        let kontrolè = KlasmanViewController()
        navigationController?.pushViewController(kontrolè, animated: true)
    }

    @objc private func jereKlikReglaj() {
        let kontrolè = ReglajViewController()
        navigationController?.pushViewController(kontrolè, animated: true)
    }

    private func navigeVèJwe(_ nivo: NivoJwe) {
        let kontrolèJwe = JweViewController(nivo: nivo)
        navigationController?.pushViewController(kontrolèJwe, animated: true)
    }
}
