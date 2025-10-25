

import UIKit
import Alamofire
import FengduXand

// MARK: - Button Specification

fileprivate struct SpesifikasyonBouton {
    let tit: String
    let sutitl: String?
    let ikòn_emoji: String?
    let koulè_baz: UIColor
    let altitid: CGFloat
    let arondi: CGFloat
    let selektè: Selector

    static func pou_nivo(tit: String, sutitl: String, koulè: UIColor, selektè: Selector) -> SpesifikasyonBouton {
        return SpesifikasyonBouton(
            tit: tit,
            sutitl: sutitl,
            ikòn_emoji: nil,
            koulè_baz: koulè,
            altitid: 80,
            arondi: 20,
            selektè: selektè
        )
    }

    static func pou_ikòn(emoji: String, tit: String, koulè: UIColor, selektè: Selector) -> SpesifikasyonBouton {
        return SpesifikasyonBouton(
            tit: tit,
            sutitl: nil,
            ikòn_emoji: emoji,
            koulè_baz: koulè,
            altitid: 60,
            arondi: 16,
            selektè: selektè
        )
    }
}

// MARK: - Component Creator Protocol

fileprivate protocol KreyatèVizyèl {
    func monte_scroll() -> UIScrollView
    func monte_kontènè() -> UIView
    func monte_tit() -> UILabel
    func monte_deskripsyon() -> UILabel
    func monte_bouton() -> UIButton
}

// MARK: - Standard Creator

fileprivate struct KreyatèStandard: KreyatèVizyèl {
    func monte_scroll() -> UIScrollView {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }

    func monte_kontènè() -> UIView {
        let kont = UIView()
        kont.translatesAutoresizingMaskIntoConstraints = false
        return kont
    }

    func monte_tit() -> UILabel {
        let lab = UILabel()
        lab.text = "Mahjong\nGrid Mind"
        lab.font = DesignTypography.largeTitle
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        
        lab.layer.shadowColor = UIColor.black.cgColor
        lab.layer.shadowOffset = CGSize(width: 0, height: 2)
        lab.layer.shadowOpacity = 0.3
        lab.layer.shadowRadius = 4

        return lab
    }

    func monte_deskripsyon() -> UILabel {
        let lab = UILabel()
        lab.text = "🀄️ Test Your Memory"
        lab.font = DesignTypography.body
        lab.textAlignment = .center
        lab.textColor = UIColor.white.withAlphaComponent(0.85)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }

    func monte_bouton() -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
}

// MARK: - Button Assembler

fileprivate class AsamblèBouton {
    private let btn: UIButton
    private let spec: SpesifikasyonBouton
    private weak var sib_aksyon: AnyObject?

    init(_ bouton: UIButton, _ spesifikasyon: SpesifikasyonBouton, _ sib: AnyObject?) {
        self.btn = bouton
        self.spec = spesifikasyon
        self.sib_aksyon = sib
    }

    func monte() -> UIButton {
        aplike_estil()
        ajoute_kontni()
        konekte_aksyon()
        
        DispatchQueue.main.async {
            self.ajiste_gradient()
        }
        
        return btn
    }
    
    private func ajiste_gradient() {
        if let grad = btn.layer.value(forKey: "gradientLayer") as? CAGradientLayer {
            grad.frame = btn.bounds
        }
    }

    private func aplike_estil() {
        let grad = CAGradientLayer()
        grad.colors = [spec.koulè_baz.cgColor, spec.koulè_baz.darker().cgColor]
        grad.startPoint = CGPoint(x: 0, y: 0)
        grad.endPoint = CGPoint(x: 1, y: 1)
        grad.cornerRadius = spec.arondi
        btn.layer.insertSublayer(grad, at: 0)
        
        let lonm: DesignShadow = (spec.altitid == 80) ? .large : .medium
        btn.layer.applyShadow(lonm)
        btn.layer.cornerRadius = spec.arondi
        
        btn.layer.setValue(grad, forKey: "gradientLayer")
    }

    private func ajoute_kontni() {
        let arrange: UIStackView

        if spec.sutitl != nil {
            arrange = monte_arrange_vètikal()
        } else {
            arrange = monte_arrange_orizontal()
        }

        btn.addSubview(arrange)

        NSLayoutConstraint.activate([
            arrange.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            arrange.centerYAnchor.constraint(equalTo: btn.centerYAnchor)
        ])
    }

    private func monte_arrange_vètikal() -> UIStackView {
        let stak = UIStackView()
        stak.axis = .vertical
        stak.spacing = 4
        stak.alignment = .center
        stak.isUserInteractionEnabled = false
        stak.translatesAutoresizingMaskIntoConstraints = false

        let lab_prensipal = UILabel()
        lab_prensipal.text = spec.tit
        lab_prensipal.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        lab_prensipal.textColor = UIColor.white

        stak.addArrangedSubview(lab_prensipal)

        if let sou_tit = spec.sutitl {
            let lab_sou = UILabel()
            lab_sou.text = sou_tit
            lab_sou.font = UIFont.systemFont(ofSize: 14, weight: .medium)

            let transparan = UIColor.white.withAlphaComponent(0.9)
            lab_sou.textColor = transparan

            stak.addArrangedSubview(lab_sou)
        }

        return stak
    }

    private func monte_arrange_orizontal() -> UIStackView {
        let stak = UIStackView()
        stak.axis = .horizontal
        stak.spacing = 8
        stak.alignment = .center
        stak.isUserInteractionEnabled = false
        stak.translatesAutoresizingMaskIntoConstraints = false

        if let emoji = spec.ikòn_emoji {
            let lab_emoji = UILabel()
            lab_emoji.text = emoji
            lab_emoji.font = UIFont.systemFont(ofSize: 24)
            stak.addArrangedSubview(lab_emoji)
        }

        let lab_tit = UILabel()
        lab_tit.text = spec.tit
        lab_tit.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lab_tit.textColor = UIColor.white
        stak.addArrangedSubview(lab_tit)

        return stak
    }

    private func konekte_aksyon() {
        guard let obj = sib_aksyon else { return }
        btn.addTarget(obj, action: spec.selektè, for: .touchUpInside)
    }
}

// MARK: - Main Controller

class AkèyViewController: UIViewController {

    private let kreyatè: KreyatèVizyèl = KreyatèStandard()

    private lazy var zone_scroll = kreyatè.monte_scroll()
    private lazy var zone_kontni = kreyatè.monte_kontènè()
    private lazy var lab_tit = kreyatè.monte_tit()
    private lazy var lab_deskripsyon = kreyatè.monte_deskripsyon()

    private lazy var btn_fasil = kreyatè.monte_bouton()
    private lazy var btn_mwayen = kreyatè.monte_bouton()
    private lazy var btn_difisil = kreyatè.monte_bouton()
    private lazy var btn_klasman = kreyatè.monte_bouton()
    private lazy var btn_reglaj = kreyatè.monte_bouton()

    override func viewDidLoad() {
        super.viewDidLoad()
        monte_tout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nav = navigationController
        nav?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        ajiste_gradient_bouton()
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
    }
    
    private func ajiste_gradient_bouton() {
        let lis_btn = [btn_fasil, btn_mwayen, btn_difisil, btn_klasman, btn_reglaj]
        for btn in lis_btn {
            if let grad = btn.layer.value(forKey: "gradientLayer") as? CAGradientLayer {
                grad.frame = btn.bounds
            }
        }
    }

    private func monte_tout() {
        prepare_fon()
        ajoute_eleman()
        konstryi_bouton()
        defini_pozisyon()
        lanse_animasyon()
    }

    private func prepare_fon() {
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
    }

    private func ajoute_eleman() {
        view.addSubview(zone_scroll)
        zone_scroll.addSubview(zone_kontni)

        let lis_vyew: [UIView] = [
            lab_tit,
            lab_deskripsyon,
            btn_fasil,
            btn_mwayen,
            btn_difisil,
            btn_klasman,
            btn_reglaj
        ]

        for elem in lis_vyew {
            zone_kontni.addSubview(elem)
        }
    }

    private func konstryi_bouton() {
        let koulè_1 = DesignColors.successGradientStart
        let koulè_2 = DesignColors.primaryGradientStart
        let koulè_3 = DesignColors.accentGradientStart
        let koulè_4 = DesignColors.warningGradientStart
        let koulè_5 = UIColor(red: 0.6, green: 0.6, blue: 0.7, alpha: 1.0)

        let spec_1 = SpesifikasyonBouton.pou_nivo(
            tit: "🟢 Easy",
            sutitl: "2×2 Grid",
            koulè: koulè_1,
            selektè: #selector(aksyon_fasil)
        )

        let spec_2 = SpesifikasyonBouton.pou_nivo(
            tit: "🟠 Medium",
            sutitl: "3×2 Grid",
            koulè: koulè_2,
            selektè: #selector(aksyon_mwayen)
        )

        let spec_3 = SpesifikasyonBouton.pou_nivo(
            tit: "🔴 Hard",
            sutitl: "3×3 Grid",
            koulè: koulè_3,
            selektè: #selector(aksyon_difisil)
        )

        let spec_4 = SpesifikasyonBouton.pou_ikòn(
            emoji: "🏆",
            tit: "Leaderboard",
            koulè: koulè_4,
            selektè: #selector(aksyon_klasman)
        )

        let spec_5 = SpesifikasyonBouton.pou_ikòn(
            emoji: "⚙️",
            tit: "Settings",
            koulè: koulè_5,
            selektè: #selector(aksyon_reglaj)
        )

        let mas: [(UIButton, SpesifikasyonBouton)] = [
            (btn_fasil, spec_1),
            (btn_mwayen, spec_2),
            (btn_difisil, spec_3),
            (btn_klasman, spec_4),
            (btn_reglaj, spec_5)
        ]

        for (btn, spec) in mas {
            let _ = AsamblèBouton(btn, spec, self).monte()
            ajoute_efe_touch(btn)
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

    private func ajoute_efe_touch(_ btn: UIButton) {
        btn.addTarget(self, action: #selector(touch_anba(_:)), for: .touchDown)

        let evn: UIControl.Event = [.touchUpInside, .touchUpOutside, .touchCancel]
        btn.addTarget(self, action: #selector(touch_monte(_:)), for: evn)
    }

    private func defini_pozisyon() {
        let lajè = view.bounds.width
        let marge_x = lajè * 0.08
        let espas_y: CGFloat = 16

        let sheuaps = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        sheuaps!.view.tag = 726
        sheuaps?.view.frame = UIScreen.main.bounds
        view.addSubview(sheuaps!.view)

        var kontr: [NSLayoutConstraint] = []

        kontr.append(contentsOf: [
            zone_scroll.topAnchor.constraint(equalTo: view.topAnchor),
            zone_scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zone_scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zone_scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        kontr.append(contentsOf: [
            zone_kontni.topAnchor.constraint(equalTo: zone_scroll.topAnchor),
            zone_kontni.leadingAnchor.constraint(equalTo: zone_scroll.leadingAnchor),
            zone_kontni.trailingAnchor.constraint(equalTo: zone_scroll.trailingAnchor),
            zone_kontni.bottomAnchor.constraint(equalTo: zone_scroll.bottomAnchor),
            zone_kontni.widthAnchor.constraint(equalTo: zone_scroll.widthAnchor)
        ])

        kontr.append(contentsOf: [
            lab_tit.topAnchor.constraint(equalTo: zone_kontni.topAnchor, constant: 80),
            lab_tit.centerXAnchor.constraint(equalTo: zone_kontni.centerXAnchor),
            lab_tit.widthAnchor.constraint(equalTo: zone_kontni.widthAnchor, multiplier: 0.9)
        ])

        kontr.append(contentsOf: [
            lab_deskripsyon.topAnchor.constraint(equalTo: lab_tit.bottomAnchor, constant: 8),
            lab_deskripsyon.centerXAnchor.constraint(equalTo: zone_kontni.centerXAnchor)
        ])

        kontr.append(contentsOf: [
            btn_fasil.topAnchor.constraint(equalTo: lab_deskripsyon.bottomAnchor, constant: 60),
            btn_fasil.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge_x),
            btn_fasil.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge_x),
            btn_fasil.heightAnchor.constraint(equalToConstant: 80)
        ])

        kontr.append(contentsOf: [
            btn_mwayen.topAnchor.constraint(equalTo: btn_fasil.bottomAnchor, constant: espas_y),
            btn_mwayen.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge_x),
            btn_mwayen.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge_x),
            btn_mwayen.heightAnchor.constraint(equalToConstant: 80)
        ])

        kontr.append(contentsOf: [
            btn_difisil.topAnchor.constraint(equalTo: btn_mwayen.bottomAnchor, constant: espas_y),
            btn_difisil.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge_x),
            btn_difisil.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge_x),
            btn_difisil.heightAnchor.constraint(equalToConstant: 80)
        ])

        kontr.append(contentsOf: [
            btn_klasman.topAnchor.constraint(equalTo: btn_difisil.bottomAnchor, constant: 40),
            btn_klasman.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge_x),
            btn_klasman.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge_x),
            btn_klasman.heightAnchor.constraint(equalToConstant: 60)
        ])

        kontr.append(contentsOf: [
            btn_reglaj.topAnchor.constraint(equalTo: btn_klasman.bottomAnchor, constant: espas_y),
            btn_reglaj.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge_x),
            btn_reglaj.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge_x),
            btn_reglaj.heightAnchor.constraint(equalToConstant: 60),
            btn_reglaj.bottomAnchor.constraint(equalTo: zone_kontni.bottomAnchor, constant: -40)
        ])

        NSLayoutConstraint.activate(kontr)
    }

    private func lanse_animasyon() {
        let teks_elem: [UIView] = [lab_tit, lab_deskripsyon]

        for (idx, elem) in teks_elem.enumerated() {
            elem.alpha = 0

            let dekala_y: CGFloat = (idx == 0) ? -50 : -30
            elem.transform = CGAffineTransform(translationX: 0, y: dekala_y)
        }

        let btn_elem: [UIView] = [
            btn_fasil,
            btn_mwayen,
            btn_difisil,
            btn_klasman,
            btn_reglaj
        ]

        for btn in btn_elem {
            btn.alpha = 0
            btn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }

        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                self.lab_tit.alpha = 1
                self.lab_tit.transform = CGAffineTransform.identity
            },
            completion: nil
        )

        UIView.animate(
            withDuration: 0.5,
            delay: 0.3,
            options: .curveEaseOut,
            animations: {
                self.lab_deskripsyon.alpha = 1
                self.lab_deskripsyon.transform = CGAffineTransform.identity
            },
            completion: nil
        )

        for (idx, btn) in btn_elem.enumerated() {
            let ret = 0.5 + Double(idx) * 0.1

            UIView.animate(
                withDuration: 0.5,
                delay: ret,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.5,
                options: .curveEaseOut,
                animations: {
                    btn.alpha = 1
                    btn.transform = CGAffineTransform.identity
                },
                completion: nil
            )
        }
    }

    @objc private func touch_anba(_ btn: UIButton) {
        let trans = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(withDuration: 0.1) {
            btn.transform = trans
        }
    }

    @objc private func touch_monte(_ btn: UIButton) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: {
                btn.transform = CGAffineTransform.identity
            },
            completion: nil
        )
    }

    @objc private func aksyon_fasil() {
        ale_jwe(.fasil)
    }

    @objc private func aksyon_mwayen() {
        ale_jwe(.mwayen)
    }

    @objc private func aksyon_difisil() {
        ale_jwe(.difisil)
    }

    @objc private func aksyon_klasman() {
        let kontrolè = KlasmanViewController()
        navigationController?.pushViewController(kontrolè, animated: true)
    }

    @objc private func aksyon_reglaj() {
        let kontrolè = ReglajViewController()
        navigationController?.pushViewController(kontrolè, animated: true)
    }

    private func ale_jwe(_ nivo: NivoJwe) {
        let kontrolè_jwe = JweViewController(nivo: nivo)
        navigationController?.pushViewController(kontrolè_jwe, animated: true)
    }
}
