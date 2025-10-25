//
//  ReglajViewController.swift
//  GridMind
//
//  Settings View Controller (Reglaj = Settings in Haitian Creole)
//

import UIKit
import MessageUI

class ReglajViewController: UIViewController {

    // MARK: - Properties
    private let defilerVi: UIScrollView = {
        let defilerVi = UIScrollView()
        defilerVi.translatesAutoresizingMaskIntoConstraints = false
        defilerVi.showsVerticalScrollIndicator = false
        return defilerVi
    }()

    private let kontènèVi: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()

    // How to Play Section
    private let seksyonKòmanJwe: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        vi.layer.cornerRadius = DesignRadius.large
        vi.layer.applyShadow(.large)
        vi.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subtle border
        vi.layer.borderWidth = 1.0
        vi.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        return vi
    }()

    private let tikètKòmanJwe: UILabel = {
        let etikèt = UILabel()
        etikèt.text = "📖 How to Play"
        etikèt.font = DesignTypography.title2
        etikèt.textColor = DesignColors.textPrimary
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private let tèksEnstriksyon: UILabel = {
        let etikèt = UILabel()
        etikèt.numberOfLines = 0
        etikèt.font = DesignTypography.body
        etikèt.textColor = DesignColors.textSecondary

        let tèks = """
        🎮 Game Rules:

        1️⃣ Select a difficulty level:
           • Easy: 2×2 grid (4 tiles)
           • Medium: 3×2 grid (6 tiles)
           • Hard: 3×3 grid (9 tiles)

        2️⃣ Mahjong tiles will appear one by one in sequence. Pay attention to the order!

        3️⃣ After all tiles appear, you have 10 seconds to memorize them.

        4️⃣ At 5 seconds remaining, the tiles will shuffle positions.

        5️⃣ When time's up, select the tiles in the correct order you saw them appear.

        6️⃣ If you select correctly, you'll see the sequence number. Complete all tiles to win!

        7️⃣ Wrong selection = Game Over. Try again!

        🏆 Scoring:
        • Complete a round: +50 points
        • 3+ consecutive wins: Bonus points!
        • Build your high score on the leaderboard!

        🀄️ Tile Types:
        • Hudy (筒): Blue tiles, 1-9
        • Koieb (万): Red tiles, 1-9
        • Zounl (条): Green tiles, 1-9
        • Mssiu (特殊): Special purple tiles, 1-6
        """

        etikèt.text = tèks
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    // Feedback Section
    private let boutonFidba: UIButton = {
        let bouton = GradientButton()
        bouton.translatesAutoresizingMaskIntoConstraints = false
        return bouton
    }()

    private let boutonEfase: UIButton = {
        let bouton = GradientButton()
        bouton.translatesAutoresizingMaskIntoConstraints = false
        return bouton
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        konfigireUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update background gradient frame
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
        
        // Add gradient to buttons after layout
        if boutonFidba.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            let gradientFidba = GradientFactory.primaryGradient()
            gradientFidba.frame = boutonFidba.bounds
            gradientFidba.cornerRadius = DesignRadius.medium
            boutonFidba.layer.insertSublayer(gradientFidba, at: 0)
        }
        
        if boutonEfase.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            let gradientEfase = GradientFactory.accentGradient()
            gradientEfase.frame = boutonEfase.bounds
            gradientEfase.cornerRadius = DesignRadius.medium
            boutonEfase.layer.insertSublayer(gradientEfase, at: 0)
        }
        
        // Update gradient frames
        if let gradientFidba = boutonFidba.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientFidba.frame = boutonFidba.bounds
        }
        
        if let gradientEfase = boutonEfase.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            gradientEfase.frame = boutonEfase.bounds
        }
    }

    // MARK: - UI Configuration
    private func konfigireUI() {
        title = "Settings"
        
        // Add dynamic animated background
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = DesignColors.primaryGradientStart
        
        // Make navigation bar transparent
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        view.addSubview(defilerVi)
        defilerVi.addSubview(kontènèVi)

        kontènèVi.addSubview(seksyonKòmanJwe)
        seksyonKòmanJwe.addSubview(tikètKòmanJwe)
        seksyonKòmanJwe.addSubview(tèksEnstriksyon)

        kontènèVi.addSubview(boutonFidba)
        kontènèVi.addSubview(boutonEfase)
        
        konfigireBouton(boutonFidba, ikòn: "✉️", tit: "Send Feedback", aksyon: #selector(boutonFidbaTape))
        konfigireBouton(boutonEfase, ikòn: "🗑️", tit: "Clear All Data", aksyon: #selector(boutonEfaseTape))

        aplikiKontrènt()
    }

    private func konfigireBouton(_ bouton: UIButton, ikòn: String, tit: String, aksyon: Selector) {
        let pila = UIStackView()
        pila.axis = .horizontal
        pila.spacing = 12
        pila.alignment = .center
        pila.isUserInteractionEnabled = false
        pila.translatesAutoresizingMaskIntoConstraints = false

        let etikètIkòn = UILabel()
        etikètIkòn.text = ikòn
        etikètIkòn.font = UIFont.systemFont(ofSize: 24)

        let etikètTit = UILabel()
        etikètTit.text = tit
        etikètTit.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        etikètTit.textColor = .white

        pila.addArrangedSubview(etikètIkòn)
        pila.addArrangedSubview(etikètTit)

        bouton.addSubview(pila)

        NSLayoutConstraint.activate([
            pila.centerXAnchor.constraint(equalTo: bouton.centerXAnchor),
            pila.centerYAnchor.constraint(equalTo: bouton.centerYAnchor)
        ])

        bouton.addTarget(self, action: aksyon, for: .touchUpInside)
        bouton.addTarget(self, action: #selector(boutonPreseAnba(_:)), for: .touchDown)
        bouton.addTarget(self, action: #selector(boutonLage(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private func aplikiKontrènt() {
        let gwayidSekire = view.safeAreaLayoutGuide
        let marj: CGFloat = 20

        NSLayoutConstraint.activate([
            defilerVi.topAnchor.constraint(equalTo: gwayidSekire.topAnchor),
            defilerVi.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            defilerVi.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            defilerVi.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            kontènèVi.topAnchor.constraint(equalTo: defilerVi.topAnchor),
            kontènèVi.leadingAnchor.constraint(equalTo: defilerVi.leadingAnchor),
            kontènèVi.trailingAnchor.constraint(equalTo: defilerVi.trailingAnchor),
            kontènèVi.bottomAnchor.constraint(equalTo: defilerVi.bottomAnchor),
            kontènèVi.widthAnchor.constraint(equalTo: defilerVi.widthAnchor),

            seksyonKòmanJwe.topAnchor.constraint(equalTo: kontènèVi.topAnchor, constant: marj),
            seksyonKòmanJwe.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: marj),
            seksyonKòmanJwe.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -marj),

            tikètKòmanJwe.topAnchor.constraint(equalTo: seksyonKòmanJwe.topAnchor, constant: 20),
            tikètKòmanJwe.leadingAnchor.constraint(equalTo: seksyonKòmanJwe.leadingAnchor, constant: 20),
            tikètKòmanJwe.trailingAnchor.constraint(equalTo: seksyonKòmanJwe.trailingAnchor, constant: -20),

            tèksEnstriksyon.topAnchor.constraint(equalTo: tikètKòmanJwe.bottomAnchor, constant: 16),
            tèksEnstriksyon.leadingAnchor.constraint(equalTo: seksyonKòmanJwe.leadingAnchor, constant: 20),
            tèksEnstriksyon.trailingAnchor.constraint(equalTo: seksyonKòmanJwe.trailingAnchor, constant: -20),
            tèksEnstriksyon.bottomAnchor.constraint(equalTo: seksyonKòmanJwe.bottomAnchor, constant: -20),

            boutonFidba.topAnchor.constraint(equalTo: seksyonKòmanJwe.bottomAnchor, constant: 24),
            boutonFidba.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: marj),
            boutonFidba.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -marj),
            boutonFidba.heightAnchor.constraint(equalToConstant: 56),

            boutonEfase.topAnchor.constraint(equalTo: boutonFidba.bottomAnchor, constant: 16),
            boutonEfase.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: marj),
            boutonEfase.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -marj),
            boutonEfase.heightAnchor.constraint(equalToConstant: 56),
            boutonEfase.bottomAnchor.constraint(equalTo: kontènèVi.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Actions
    @objc private func boutonFidbaTape() {
        if MFMailComposeViewController.canSendMail() {
            let mailKonpoze = MFMailComposeViewController()
            mailKonpoze.mailComposeDelegate = self
            mailKonpoze.setToRecipients(["feedback@mahjong gridmind.com"])
            mailKonpoze.setSubject("Mahjong Grid Mind Feedback")
            mailKonpoze.setMessageBody("Hi there,\n\nI would like to share feedback about the game:\n\n", isHTML: false)

            present(mailKonpoze, animated: true)
        } else {
            let alè = UIAlertController(
                title: "Email Not Available",
                message: "Please configure your email account in Settings to send feedback.",
                preferredStyle: .alert
            )
            alè.addAction(UIAlertAction(title: "OK", style: .default))
            present(alè, animated: true)
        }
    }

    @objc private func boutonEfaseTape() {
        BoitDyalògPèsonalize.aficheKonfimmasyon(
            nan: view,
            tikèt: "⚠️ Clear All Data",
            mesaj: "This will delete all your scores and progress. This action cannot be undone.",
            konfimeAksyon: { [weak self] in
                self?.efaseToutDone()
            },
            anileAksyon: {}
        )
    }

    private func efaseToutDone() {
        UserDefaults.standard.removeObject(forKey: "AnrejistrePwenKle")
        UserDefaults.standard.removeObject(forKey: "KontreSesyonSiyès")

        let alè = UIAlertController(
            title: "✅ Success",
            message: "All data has been cleared successfully.",
            preferredStyle: .alert
        )
        alè.addAction(UIAlertAction(title: "OK", style: .default))
        present(alè, animated: true)
    }

    @objc private func boutonPreseAnba(_ bouton: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.15, animations: {
            bouton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    @objc private func boutonLage(_ bouton: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.3, damping: 0.6, animations: {
            bouton.transform = .identity
        })
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ReglajViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
