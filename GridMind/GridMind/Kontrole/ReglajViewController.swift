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
    private let zone_scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()

    private let zone_kontni: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()

    // How to Play Section
    private let seksyon_kouma: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        vi.layer.cornerRadius = DesignRadius.large
        vi.layer.applyShadow(.large)
        vi.translatesAutoresizingMaskIntoConstraints = false
        
        vi.layer.borderWidth = 1.0
        vi.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        return vi
    }()

    private let lab_tit_kouma: UILabel = {
        let lab = UILabel()
        lab.text = "📖 How to Play"
        lab.font = DesignTypography.title2
        lab.textColor = DesignColors.textPrimary
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private let lab_enstriksyon: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.font = DesignTypography.body
        lab.textColor = DesignColors.textSecondary

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

        lab.text = tèks
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    // Action buttons
    private let btn_fidba: UIButton = {
        let btn = GradientButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let btn_efase: UIButton = {
        let btn = GradientButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare_ui()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
        
        if btn_fidba.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            let grad1 = GradientFactory.primaryGradient()
            grad1.frame = btn_fidba.bounds
            grad1.cornerRadius = DesignRadius.medium
            btn_fidba.layer.insertSublayer(grad1, at: 0)
        }
        
        if btn_efase.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
            let grad2 = GradientFactory.accentGradient()
            grad2.frame = btn_efase.bounds
            grad2.cornerRadius = DesignRadius.medium
            btn_efase.layer.insertSublayer(grad2, at: 0)
        }
        
        if let grad1 = btn_fidba.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            grad1.frame = btn_fidba.bounds
        }
        
        if let grad2 = btn_efase.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
            grad2.frame = btn_efase.bounds
        }
    }

    // MARK: - UI Setup
    private func prepare_ui() {
        title = "Settings"
        
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = DesignColors.primaryGradientStart
        
        let aparans = UINavigationBarAppearance()
        aparans.configureWithTransparentBackground()
        aparans.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        aparans.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = aparans
        navigationController?.navigationBar.scrollEdgeAppearance = aparans

        view.addSubview(zone_scroll)
        zone_scroll.addSubview(zone_kontni)

        zone_kontni.addSubview(seksyon_kouma)
        seksyon_kouma.addSubview(lab_tit_kouma)
        seksyon_kouma.addSubview(lab_enstriksyon)

        zone_kontni.addSubview(btn_fidba)
        zone_kontni.addSubview(btn_efase)
        
        monte_bouton(btn_fidba, emoji: "✉️", tit: "Send Feedback", aksyon: #selector(tap_fidba))
        monte_bouton(btn_efase, emoji: "🗑️", tit: "Clear All Data", aksyon: #selector(tap_efase))

        monte_kontrènt()
    }

    private func monte_bouton(_ btn: UIButton, emoji: String, tit: String, aksyon: Selector) {
        let stak = UIStackView()
        stak.axis = .horizontal
        stak.spacing = 12
        stak.alignment = .center
        stak.isUserInteractionEnabled = false
        stak.translatesAutoresizingMaskIntoConstraints = false

        let lab_emoji = UILabel()
        lab_emoji.text = emoji
        lab_emoji.font = UIFont.systemFont(ofSize: 24)

        let lab_tit = UILabel()
        lab_tit.text = tit
        lab_tit.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        lab_tit.textColor = .white

        stak.addArrangedSubview(lab_emoji)
        stak.addArrangedSubview(lab_tit)

        btn.addSubview(stak)

        NSLayoutConstraint.activate([
            stak.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            stak.centerYAnchor.constraint(equalTo: btn.centerYAnchor)
        ])

        btn.addTarget(self, action: aksyon, for: .touchUpInside)
        btn.addTarget(self, action: #selector(prese_anba(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(lage(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private func monte_kontrènt() {
        let safe = view.safeAreaLayoutGuide
        let marge: CGFloat = 20

        NSLayoutConstraint.activate([
            zone_scroll.topAnchor.constraint(equalTo: safe.topAnchor),
            zone_scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zone_scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zone_scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            zone_kontni.topAnchor.constraint(equalTo: zone_scroll.topAnchor),
            zone_kontni.leadingAnchor.constraint(equalTo: zone_scroll.leadingAnchor),
            zone_kontni.trailingAnchor.constraint(equalTo: zone_scroll.trailingAnchor),
            zone_kontni.bottomAnchor.constraint(equalTo: zone_scroll.bottomAnchor),
            zone_kontni.widthAnchor.constraint(equalTo: zone_scroll.widthAnchor),

            seksyon_kouma.topAnchor.constraint(equalTo: zone_kontni.topAnchor, constant: marge),
            seksyon_kouma.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge),
            seksyon_kouma.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge),

            lab_tit_kouma.topAnchor.constraint(equalTo: seksyon_kouma.topAnchor, constant: 20),
            lab_tit_kouma.leadingAnchor.constraint(equalTo: seksyon_kouma.leadingAnchor, constant: 20),
            lab_tit_kouma.trailingAnchor.constraint(equalTo: seksyon_kouma.trailingAnchor, constant: -20),

            lab_enstriksyon.topAnchor.constraint(equalTo: lab_tit_kouma.bottomAnchor, constant: 16),
            lab_enstriksyon.leadingAnchor.constraint(equalTo: seksyon_kouma.leadingAnchor, constant: 20),
            lab_enstriksyon.trailingAnchor.constraint(equalTo: seksyon_kouma.trailingAnchor, constant: -20),
            lab_enstriksyon.bottomAnchor.constraint(equalTo: seksyon_kouma.bottomAnchor, constant: -20),

            btn_fidba.topAnchor.constraint(equalTo: seksyon_kouma.bottomAnchor, constant: 24),
            btn_fidba.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge),
            btn_fidba.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge),
            btn_fidba.heightAnchor.constraint(equalToConstant: 56),

            btn_efase.topAnchor.constraint(equalTo: btn_fidba.bottomAnchor, constant: 16),
            btn_efase.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: marge),
            btn_efase.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -marge),
            btn_efase.heightAnchor.constraint(equalToConstant: 56),
            btn_efase.bottomAnchor.constraint(equalTo: zone_kontni.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Actions
    @objc private func tap_fidba() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["feedback@mahjong gridmind.com"])
            mail.setSubject("Mahjong Grid Mind Feedback")
            mail.setMessageBody("Hi there,\n\nI would like to share feedback about the game:\n\n", isHTML: false)

            present(mail, animated: true)
        } else {
            let alèt = UIAlertController(
                title: "Email Not Available",
                message: "Please configure your email account in Settings to send feedback.",
                preferredStyle: .alert
            )
            alèt.addAction(UIAlertAction(title: "OK", style: .default))
            present(alèt, animated: true)
        }
    }

    @objc private func tap_efase() {
        BoitDyalògPèsonalize.aficheKonfimmasyon(
            nan: view,
            tikèt: "⚠️ Clear All Data",
            mesaj: "This will delete all your scores and progress. This action cannot be undone.",
            konfimeAksyon: { [weak self] in
                self?.efase_tout()
            },
            anileAksyon: {}
        )
    }

    private func efase_tout() {
        UserDefaults.standard.removeObject(forKey: "AnrejistrePwenKle")
        UserDefaults.standard.removeObject(forKey: "KontreSesyonSiyès")

        let alèt = UIAlertController(
            title: "✅ Success",
            message: "All data has been cleared successfully.",
            preferredStyle: .alert
        )
        alèt.addAction(UIAlertAction(title: "OK", style: .default))
        present(alèt, animated: true)
    }

    @objc private func prese_anba(_ btn: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.15, animations: {
            btn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    @objc private func lage(_ btn: UIButton) {
        AnimationUtilities.springAnimation(duration: 0.3, damping: 0.6, animations: {
            btn.transform = .identity
        })
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension ReglajViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
