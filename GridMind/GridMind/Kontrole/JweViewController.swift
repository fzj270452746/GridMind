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
    private var katyoLis: [MahjongKatyo] = []
    private var orijinalSekans: [MahjongKatyo] = []
    private var seleksyonSekans: [MahjongKatyo] = []
    private var endèksSeleksyonAktiyèl: Int = 0

    private var etaJwe: EtaJwe = .afichaj {
        didSet {
            mizeAjouPouEtaJwe()
        }
    }

    private var kontèTan: Timer?
    private var tanRestan: Int = 10

    // UI Components
    private let barAnwo: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        vi.layer.applyShadow(.medium)
        vi.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subtle blur effect
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        vi.insertSubview(blurView, at: 0)
        
        return vi
    }()

    private let boutonRetounen: UIButton = {
        let bouton = UIButton(type: .system)
        bouton.setTitle("← Back", for: .normal)
        bouton.titleLabel?.font = DesignTypography.callout
        bouton.setTitleColor(DesignColors.primaryGradientStart, for: .normal)
        bouton.translatesAutoresizingMaskIntoConstraints = false
        return bouton
    }()

    private let etikètNivo: UILabel = {
        let etikèt = UILabel()
        etikèt.font = DesignTypography.title3
        etikèt.textAlignment = .center
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private let etikètPwen: UILabel = {
        let etikèt = UILabel()
        etikèt.font = DesignTypography.body
        etikèt.textColor = DesignColors.textSecondary
        etikèt.text = "Score: 0"
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private let etikètTan: UILabel = {
        let etikèt = UILabel()
        etikèt.font = UIFont.systemFont(ofSize: 64, weight: .black)
        etikèt.textAlignment = .center
        etikèt.textColor = DesignColors.primaryGradientStart
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow for better readability
        etikèt.layer.shadowColor = UIColor.black.cgColor
        etikèt.layer.shadowOffset = CGSize(width: 0, height: 2)
        etikèt.layer.shadowOpacity = 0.15
        etikèt.layer.shadowRadius = 4
        
        return etikèt
    }()

    private let etikètEnstriksyon: UILabel = {
        let etikèt = UILabel()
        etikèt.font = DesignTypography.body
        etikèt.textAlignment = .center
        etikèt.numberOfLines = 0
        etikèt.textColor = DesignColors.textSecondary
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private let kontènèGrid: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()

    private var selilKatyo: [KatyoCellView] = []

    private var pwenTotal: Int = 0 {
        didSet {
            etikètPwen.text = "Score: \(pwenTotal)"
        }
    }

    // MARK: - Game States
    enum EtaJwe {
        case afichaj        // Showing tiles in sequence
        case kontè          // Countdown timer
        case melanje        // Shuffling tiles
        case jwe            // Player selecting tiles
        case rezilta        // Showing results
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
        konfigireUI()
        chajePwenTotal()
        kòmanseJwe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kontèTan?.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update background gradient frame
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
        
        // Update blur view frame in top bar
        if let blurView = barAnwo.subviews.first as? UIVisualEffectView {
            blurView.frame = barAnwo.bounds
        }
    }

    // MARK: - UI Configuration
    private func konfigireUI() {
        // Add dynamic animated background
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(barAnwo)
        barAnwo.addSubview(boutonRetounen)
        barAnwo.addSubview(etikètNivo)
        barAnwo.addSubview(etikètPwen)

        view.addSubview(etikètTan)
        view.addSubview(etikètEnstriksyon)
        view.addSubview(kontènèGrid)

        etikètNivo.text = nivo.nonAfiche
        etikètNivo.textColor = nivo.koulèPrènsipal

        boutonRetounen.addTarget(self, action: #selector(boutonRetounenTape), for: .touchUpInside)

        konfigireKontrènt()
        konfigireGrid()
    }

    private func konfigireKontrènt() {
        let gwayidSekire = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            barAnwo.topAnchor.constraint(equalTo: view.topAnchor),
            barAnwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barAnwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barAnwo.bottomAnchor.constraint(equalTo: gwayidSekire.topAnchor, constant: 60),

            boutonRetounen.leadingAnchor.constraint(equalTo: barAnwo.leadingAnchor, constant: 16),
            boutonRetounen.centerYAnchor.constraint(equalTo: barAnwo.bottomAnchor, constant: -20),

            etikètNivo.centerXAnchor.constraint(equalTo: barAnwo.centerXAnchor),
            etikètNivo.centerYAnchor.constraint(equalTo: boutonRetounen.centerYAnchor),

            etikètPwen.trailingAnchor.constraint(equalTo: barAnwo.trailingAnchor, constant: -16),
            etikètPwen.centerYAnchor.constraint(equalTo: boutonRetounen.centerYAnchor),

            etikètTan.topAnchor.constraint(equalTo: barAnwo.bottomAnchor, constant: 20),
            etikètTan.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            etikètEnstriksyon.topAnchor.constraint(equalTo: etikètTan.bottomAnchor, constant: 8),
            etikètEnstriksyon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            etikètEnstriksyon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            kontènèGrid.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kontènèGrid.topAnchor.constraint(equalTo: etikètEnstriksyon.bottomAnchor, constant: 30)
        ])
    }

    private func konfigireGrid() {
        let kolòn = nivo.kantiteKolòn
        let ranje = nivo.kantiteRanje

        let lajèEkran = view.bounds.width
        let otèEkran = view.bounds.height
        let otèSekire = view.safeAreaInsets.top + view.safeAreaInsets.bottom
        let otèDisponib = otèEkran - otèSekire - 300 // Reserve space for top bar, timer, and instructions

        // Calculate maximum cell size based on available space
        let espasman: CGFloat = 12
        let lajèDisponib = lajèEkran * 0.85

        // Calculate cell width based on screen width
        let lajèSekilParLajè = (lajèDisponib - (CGFloat(kolòn - 1) * espasman)) / CGFloat(kolòn)

        // Calculate cell width based on screen height to prevent overflow
        let otèMaxGrid = otèDisponib * 0.7 // Use 70% of available height
        let otèSekilParOtè = (otèMaxGrid - (CGFloat(ranje - 1) * espasman)) / CGFloat(ranje) / 1.2

        // Use the smaller of the two to ensure everything fits
        let lajèSelil = min(lajèSekilParLajè, otèSekilParOtè)
        let otèSelil = lajèSelil * 1.2

        let lajèGridTotal = (lajèSelil * CGFloat(kolòn)) + (espasman * CGFloat(kolòn - 1))
        let otèGridTotal = (otèSelil * CGFloat(ranje)) + (espasman * CGFloat(ranje - 1))

        NSLayoutConstraint.activate([
            kontènèGrid.widthAnchor.constraint(equalToConstant: lajèGridTotal),
            kontènèGrid.heightAnchor.constraint(equalToConstant: otèGridTotal)
        ])

        for ranjEndèks in 0..<ranje {
            for kolònEndèks in 0..<kolòn {
                let selil = KatyoCellView()
                selil.translatesAutoresizingMaskIntoConstraints = false

                let tapGès = UITapGestureRecognizer(target: self, action: #selector(katyoTape(_:)))
                selil.addGestureRecognizer(tapGès)
                selil.tag = ranjEndèks * kolòn + kolònEndèks

                kontènèGrid.addSubview(selil)
                selilKatyo.append(selil)

                let x = CGFloat(kolònEndèks) * (lajèSelil + espasman)
                let y = CGFloat(ranjEndèks) * (otèSelil + espasman)

                NSLayoutConstraint.activate([
                    selil.leadingAnchor.constraint(equalTo: kontènèGrid.leadingAnchor, constant: x),
                    selil.topAnchor.constraint(equalTo: kontènèGrid.topAnchor, constant: y),
                    selil.widthAnchor.constraint(equalToConstant: lajèSelil),
                    selil.heightAnchor.constraint(equalToConstant: otèSelil)
                ])
            }
        }
    }

    // MARK: - Game Logic
    private func kòmanseJwe() {
        katyoLis = JerèrKatyo.pataje.chwaziKatyoAleatwa(kantite: nivo.kantiteTotalKatyo)
        orijinalSekans = katyoLis
        seleksyonSekans = []
        endèksSeleksyonAktiyèl = 0

        etaJwe = .afichaj
        aficheSekansKatyo()
    }

    private func aficheSekansKatyo() {
        etikètEnstriksyon.text = "Memorize the tiles..."
        etikètTan.isHidden = true

        for (endèks, selil) in selilKatyo.enumerated() {
            selil.konfigire(ak: katyoLis[endèks])
            selil.animeEntransAk(TimeInterval(endèks) * 0.15)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(selilKatyo.count) * 0.15 + 0.5) {
            self.kòmanseKontè()
        }
    }

    private func kòmanseKontè() {
        etaJwe = .kontè
        tanRestan = 10
        etikètTan.isHidden = false
        etikètEnstriksyon.text = "Remember the order!"

        mizeAjouAfichajTan()

        kontèTan = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.tanRestan -= 1
            self.mizeAjouAfichajTan()

            if self.tanRestan == 5 {
                self.melanjeKatyo()
            }

            if self.tanRestan <= 0 {
                self.kontèTan?.invalidate()
                self.kòmanseJwePhase()
            }
        }
    }

    private func mizeAjouAfichajTan() {
        etikètTan.text = "\(tanRestan)"

        if tanRestan <= 5 {
            etikètTan.textColor = DesignColors.accentGradientStart

            AnimationUtilities.springAnimation(duration: 0.4, damping: 0.5, velocity: 0.8, animations: {
                self.etikètTan.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }) { _ in
                AnimationUtilities.springAnimation(duration: 0.3, animations: {
                    self.etikètTan.transform = .identity
                })
            }
        } else {
            etikètTan.textColor = DesignColors.primaryGradientStart
        }
    }

    private func melanjeKatyo() {
        etaJwe = .melanje
        katyoLis = JerèrKatyo.pataje.melanje(katyoLis)

        UIView.animate(withDuration: 0.3) {
            self.selilKatyo.forEach { $0.alpha = 0 }
        } completion: { _ in
            for (endèks, selil) in self.selilKatyo.enumerated() {
                selil.konfigire(ak: self.katyoLis[endèks])
            }

            UIView.animate(withDuration: 0.3) {
                self.selilKatyo.forEach { $0.alpha = 1 }
            }
        }
    }

    private func kòmanseJwePhase() {
        etaJwe = .jwe
        etikètTan.isHidden = true
        etikètEnstriksyon.text = "Select tiles in the correct order!"
    }

    private func mizeAjouPouEtaJwe() {
        switch etaJwe {
        case .afichaj:
            kontènèGrid.isUserInteractionEnabled = false
        case .kontè:
            kontènèGrid.isUserInteractionEnabled = false
        case .melanje:
            kontènèGrid.isUserInteractionEnabled = false
        case .jwe:
            kontènèGrid.isUserInteractionEnabled = true
        case .rezilta:
            kontènèGrid.isUserInteractionEnabled = false
        }
    }

    // MARK: - User Interaction
    @objc private func katyoTape(_ jès: UITapGestureRecognizer) {
        guard etaJwe == .jwe, let selil = jès.view as? KatyoCellView else { return }

        let endèks = selil.tag
        let katyoSeleksyone = katyoLis[endèks]

        if endèksSeleksyonAktiyèl < orijinalSekans.count {
            let katyoKòrèk = orijinalSekans[endèksSeleksyonAktiyèl]

            if katyoSeleksyone == katyoKòrèk {
                // Correct selection
                selil.animeSeleksyon()
                selil.aficheNimewo(endèksSeleksyonAktiyèl + 1)
                seleksyonSekans.append(katyoSeleksyone)
                endèksSeleksyonAktiyèl += 1

                if endèksSeleksyonAktiyèl == orijinalSekans.count {
                    // All correct!
                    jenereSiyès()
                }
            } else {
                // Wrong selection
                selil.animeErè()
                jenereEchèk()
            }
        }
    }

    @objc private func boutonRetounenTape() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Game Results
    private func jenereSiyès() {
        etaJwe = .rezilta

        let pwenBaz = 50
        let kontreSesyon = JerèrPwen.pataje.jwennKontreSesyonSiyès()
        let pwenBonus = JerèrPwen.pataje.kalkilePwenBonus()

        JerèrPwen.pataje.ogmanteKontreSesyonSiyès()

        let pwenTotal = pwenBaz + pwenBonus
        self.pwenTotal += pwenTotal

        JerèrPwen.pataje.konsève(self.pwenTotal, pou: nivo)

        var mesaj = "You completed the challenge!"
        if kontreSesyon >= 2 {
            mesaj += "\n\n🔥 \(kontreSesyon + 1) wins in a row!"
            if pwenBonus > 0 {
                mesaj += "\nBonus: +\(pwenBonus) points"
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            BoitDyalògPèsonalize.aficheSiyès(nan: self.view, mesaj: mesaj, pwen: pwenTotal) {
                self.kòmanseJwe()
            }
        }
    }

    private func jenereEchèk() {
        etaJwe = .rezilta
        JerèrPwen.pataje.reyinisilizeKontreSesyonSiyès()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            BoitDyalògPèsonalize.aficheEchèk(nan: self.view, mesaj: "Wrong tile selected!\nTry again.") {
                self.kòmanseJwe()
            }
        }
    }

    private func chajePwenTotal() {
        let anrejistreman = JerèrPwen.pataje.chajeToutAnrejistreman()
        let filtreNivo = anrejistreman.filter { $0.nivo == nivo }
        pwenTotal = filtreNivo.reduce(0) { $0 + $1.pwen }
    }
}
