//
//  JweViewController.swift
//  GridMind
//
//  Game View Controller (Jwe = Play/Game in Haitian Creole)
//

import UIKit

class JweViewController: UIViewController {

    // MARK: - Properties
    private let nivo: NivoJwe
    private var lis_katyo: [MahjongKatyo] = []
    private var sekans_orijinal: [MahjongKatyo] = []
    private var sekans_chwa: [MahjongKatyo] = []
    private var endèks_aktyèl: Int = 0

    private var eta_aktyèl: EtatJwe = .afichaj {
        didSet {
            mete_ajou_pou_eta()
        }
    }

    private var timatè: Timer?
    private var tan_ki_rete: Int = 10

    // UI Components
    private let bann_anwo: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        vi.layer.applyShadow(.medium)
        vi.translatesAutoresizingMaskIntoConstraints = false
        
        let blur = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.isUserInteractionEnabled = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        vi.insertSubview(blurView, at: 0)
        
        return vi
    }()

    private let btn_retounen: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("← Back", for: .normal)
        btn.titleLabel?.font = DesignTypography.callout
        btn.setTitleColor(DesignColors.primaryGradientStart, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let lab_nivo: UILabel = {
        let lab = UILabel()
        lab.font = DesignTypography.title3
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private let lab_pwen: UILabel = {
        let lab = UILabel()
        lab.font = DesignTypography.body
        lab.textColor = DesignColors.textSecondary
        lab.text = "Score: 0"
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private let lab_tan: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 64, weight: .black)
        lab.textAlignment = .center
        lab.textColor = DesignColors.primaryGradientStart
        lab.translatesAutoresizingMaskIntoConstraints = false
        
        lab.layer.shadowColor = UIColor.black.cgColor
        lab.layer.shadowOffset = CGSize(width: 0, height: 2)
        lab.layer.shadowOpacity = 0.15
        lab.layer.shadowRadius = 4
        
        return lab
    }()

    private let lab_enstriksyon: UILabel = {
        let lab = UILabel()
        lab.font = DesignTypography.body
        lab.textAlignment = .center
        lab.numberOfLines = 0
        lab.textColor = DesignColors.textSecondary
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private let zone_grid: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()

    private var lis_selil: [KatyoCellView] = []

    private var total_pwen: Int = 0 {
        didSet {
            lab_pwen.text = "Score: \(total_pwen)"
        }
    }

    // MARK: - Game States
    enum EtatJwe {
        case afichaj
        case kontè
        case melanje
        case jwe
        case rezilta
    }

    // MARK: - Initialization
    init(nivo: NivoJwe) {
        self.nivo = nivo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare_ui()
        chaje_pwen()
        komanse_jwe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timatè?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
        
        if let blurView = bann_anwo.subviews.first as? UIVisualEffectView {
            blurView.frame = bann_anwo.bounds
        }
    }

    // MARK: - UI Setup
    private func prepare_ui() {
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(bann_anwo)
        bann_anwo.addSubview(btn_retounen)
        bann_anwo.addSubview(lab_nivo)
        bann_anwo.addSubview(lab_pwen)

        view.addSubview(lab_tan)
        view.addSubview(lab_enstriksyon)
        view.addSubview(zone_grid)

        lab_nivo.text = nivo.nonAfiche
        lab_nivo.textColor = nivo.koulèPrènsipal

        btn_retounen.addTarget(self, action: #selector(ale_retounen), for: .touchUpInside)

        monte_kontrènt()
        monte_grid()
    }

    private func monte_kontrènt() {
        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            bann_anwo.topAnchor.constraint(equalTo: view.topAnchor),
            bann_anwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bann_anwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bann_anwo.bottomAnchor.constraint(equalTo: safe.topAnchor, constant: 60),

            btn_retounen.leadingAnchor.constraint(equalTo: bann_anwo.leadingAnchor, constant: 16),
            btn_retounen.centerYAnchor.constraint(equalTo: bann_anwo.bottomAnchor, constant: -20),

            lab_nivo.centerXAnchor.constraint(equalTo: bann_anwo.centerXAnchor),
            lab_nivo.centerYAnchor.constraint(equalTo: btn_retounen.centerYAnchor),

            lab_pwen.trailingAnchor.constraint(equalTo: bann_anwo.trailingAnchor, constant: -16),
            lab_pwen.centerYAnchor.constraint(equalTo: btn_retounen.centerYAnchor),

            lab_tan.topAnchor.constraint(equalTo: bann_anwo.bottomAnchor, constant: 20),
            lab_tan.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            lab_enstriksyon.topAnchor.constraint(equalTo: lab_tan.bottomAnchor, constant: 8),
            lab_enstriksyon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            lab_enstriksyon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            zone_grid.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zone_grid.topAnchor.constraint(equalTo: lab_enstriksyon.bottomAnchor, constant: 30)
        ])
    }

    private func monte_grid() {
        let kolòn = nivo.kantiteKolòn
        let ranje = nivo.kantiteRanje

        let lajè_ekran = view.bounds.width
        let otè_ekran = view.bounds.height
        let otè_safe = view.safeAreaInsets.top + view.safeAreaInsets.bottom
        let otè_disponib = otè_ekran - otè_safe - 300

        let espasman: CGFloat = 12
        let lajè_disponib = lajè_ekran * 0.85

        let lajè_par_lajè = (lajè_disponib - (CGFloat(kolòn - 1) * espasman)) / CGFloat(kolòn)

        let otè_max = otè_disponib * 0.7
        let otè_par_otè = (otè_max - (CGFloat(ranje - 1) * espasman)) / CGFloat(ranje) / 1.2

        let lajè_selil = min(lajè_par_lajè, otè_par_otè)
        let otè_selil = lajè_selil * 1.2

        let lajè_total = (lajè_selil * CGFloat(kolòn)) + (espasman * CGFloat(kolòn - 1))
        let otè_total = (otè_selil * CGFloat(ranje)) + (espasman * CGFloat(ranje - 1))

        NSLayoutConstraint.activate([
            zone_grid.widthAnchor.constraint(equalToConstant: lajè_total),
            zone_grid.heightAnchor.constraint(equalToConstant: otè_total)
        ])

        for rang in 0..<ranje {
            for kol in 0..<kolòn {
                let selil = KatyoCellView()
                selil.translatesAutoresizingMaskIntoConstraints = false

                let tap = UITapGestureRecognizer(target: self, action: #selector(tap_katyo(_:)))
                selil.addGestureRecognizer(tap)
                selil.tag = rang * kolòn + kol

                zone_grid.addSubview(selil)
                lis_selil.append(selil)

                let x = CGFloat(kol) * (lajè_selil + espasman)
                let y = CGFloat(rang) * (otè_selil + espasman)

                NSLayoutConstraint.activate([
                    selil.leadingAnchor.constraint(equalTo: zone_grid.leadingAnchor, constant: x),
                    selil.topAnchor.constraint(equalTo: zone_grid.topAnchor, constant: y),
                    selil.widthAnchor.constraint(equalToConstant: lajè_selil),
                    selil.heightAnchor.constraint(equalToConstant: otè_selil)
                ])
            }
        }
    }

    // MARK: - Game Logic
    private func komanse_jwe() {
        lis_katyo = JerèrKatyo.pataje.chwaziKatyoAleatwa(kantite: nivo.kantiteTotalKatyo)
        sekans_orijinal = lis_katyo
        sekans_chwa = []
        endèks_aktyèl = 0

        eta_aktyèl = .afichaj
        montre_sekans()
    }

    private func montre_sekans() {
        lab_enstriksyon.text = "Memorize the tiles..."
        lab_tan.isHidden = true

        for (idx, selil) in lis_selil.enumerated() {
            selil.konfigire(ak: lis_katyo[idx])
            selil.animeEntransAk(TimeInterval(idx) * 0.15)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(lis_selil.count) * 0.15 + 0.5) {
            self.komanse_kont()
        }
    }

    private func komanse_kont() {
        eta_aktyèl = .kontè
        tan_ki_rete = 10
        lab_tan.isHidden = false
        lab_enstriksyon.text = "Remember the order!"

        ajou_tan()

        timatè = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.tan_ki_rete -= 1
            self.ajou_tan()

            if self.tan_ki_rete == 5 {
                self.melanje()
            }

            if self.tan_ki_rete <= 0 {
                self.timatè?.invalidate()
                self.komanse_fas_jwe()
            }
        }
    }

    private func ajou_tan() {
        lab_tan.text = "\(tan_ki_rete)"

        if tan_ki_rete <= 5 {
            lab_tan.textColor = DesignColors.accentGradientStart

            AnimationUtilities.springAnimation(duration: 0.4, damping: 0.5, velocity: 0.8, animations: {
                self.lab_tan.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }) { _ in
                AnimationUtilities.springAnimation(duration: 0.3, animations: {
                    self.lab_tan.transform = .identity
                })
            }
        } else {
            lab_tan.textColor = DesignColors.primaryGradientStart
        }
    }

    private func melanje() {
        eta_aktyèl = .melanje
        lis_katyo = JerèrKatyo.pataje.melanje(lis_katyo)

        UIView.animate(withDuration: 0.3) {
            self.lis_selil.forEach { $0.alpha = 0 }
        } completion: { _ in
            for (idx, selil) in self.lis_selil.enumerated() {
                selil.konfigire(ak: self.lis_katyo[idx])
            }

            UIView.animate(withDuration: 0.3) {
                self.lis_selil.forEach { $0.alpha = 1 }
            }
        }
    }

    private func komanse_fas_jwe() {
        eta_aktyèl = .jwe
        lab_tan.isHidden = true
        lab_enstriksyon.text = "Select tiles in the correct order!"
    }

    private func mete_ajou_pou_eta() {
        switch eta_aktyèl {
        case .afichaj:
            zone_grid.isUserInteractionEnabled = false
        case .kontè:
            zone_grid.isUserInteractionEnabled = false
        case .melanje:
            zone_grid.isUserInteractionEnabled = false
        case .jwe:
            zone_grid.isUserInteractionEnabled = true
        case .rezilta:
            zone_grid.isUserInteractionEnabled = false
        }
    }

    // MARK: - User Interaction
    @objc private func tap_katyo(_ gesture: UITapGestureRecognizer) {
        guard eta_aktyèl == .jwe, let selil = gesture.view as? KatyoCellView else { return }

        let idx = selil.tag
        let katyo_chwa = lis_katyo[idx]

        if endèks_aktyèl < sekans_orijinal.count {
            let katyo_korrèk = sekans_orijinal[endèks_aktyèl]

            if katyo_chwa == katyo_korrèk {
                selil.animeSeleksyon()
                selil.aficheNimewo(endèks_aktyèl + 1)
                sekans_chwa.append(katyo_chwa)
                endèks_aktyèl += 1

                if endèks_aktyèl == sekans_orijinal.count {
                    jenere_siyès()
                }
            } else {
                selil.animeErè()
                jenere_echèk()
            }
        }
    }

    @objc private func ale_retounen() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Results
    private func jenere_siyès() {
        eta_aktyèl = .rezilta

        let pwen_baz = 50
        let kontrè_sesyon = JerèrPwen.pataje.jwennKontreSesyonSiyès()
        let pwen_bonus = JerèrPwen.pataje.kalkilePwenBonus()

        JerèrPwen.pataje.ogmanteKontreSesyonSiyès()

        let pwen_total = pwen_baz + pwen_bonus
        self.total_pwen += pwen_total

        JerèrPwen.pataje.konsève(self.total_pwen, pou: nivo)

        var mesaj = "You completed the challenge!"
        if kontrè_sesyon >= 2 {
            mesaj += "\n\n🔥 \(kontrè_sesyon + 1) wins in a row!"
            if pwen_bonus > 0 {
                mesaj += "\nBonus: +\(pwen_bonus) points"
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            BoitDyalògPèsonalize.aficheSiyès(nan: self.view, mesaj: mesaj, pwen: pwen_total) {
                self.komanse_jwe()
            }
        }
    }

    private func jenere_echèk() {
        eta_aktyèl = .rezilta
        JerèrPwen.pataje.reyinisilizeKontreSesyonSiyès()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            BoitDyalògPèsonalize.aficheEchèk(nan: self.view, mesaj: "Wrong tile selected!\nTry again.") {
                self.komanse_jwe()
            }
        }
    }

    private func chaje_pwen() {
        let anrej = JerèrPwen.pataje.chajeToutAnrejistreman()
        let filtre = anrej.filter { $0.nivo == nivo }
        total_pwen = filtre.reduce(0) { $0 + $1.pwen }
    }
}
