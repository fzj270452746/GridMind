//
//  KlasmanViewController.swift
//  GridMind
//
//  Leaderboard View Controller (Klasman = Ranking/Leaderboard in Haitian Creole)
//

import UIKit

class KlasmanViewController: UIViewController {

    // MARK: - Properties
    private let kontwòl_segment: UISegmentedControl = {
        let opsyon = NivoJwe.allCases.map { $0.nonAfiche }
        let kontwòl = UISegmentedControl(items: opsyon)
        kontwòl.selectedSegmentIndex = 0
        kontwòl.translatesAutoresizingMaskIntoConstraints = false
        return kontwòl
    }()

    private let tab_vi: UITableView = {
        let tab = UITableView(frame: .zero, style: .insetGrouped)
        tab.backgroundColor = .clear
        tab.separatorStyle = .none
        tab.translatesAutoresizingMaskIntoConstraints = false
        return tab
    }()

    private let zone_vid: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()

    private let lab_vid: UILabel = {
        let lab = UILabel()
        lab.text = "🏆\n\nNo scores yet!\nPlay games to see your scores here."
        lab.numberOfLines = 0
        lab.textAlignment = .center
        lab.font = DesignTypography.body
        lab.textColor = UIColor.white.withAlphaComponent(0.85)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private var nivo_chwazi: NivoJwe = .fasil
    private var done_anrejistre: [AnrejistrePwen] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare_ui()
        chaje_done()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chaje_done()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
    }

    // MARK: - UI Setup
    private func prepare_ui() {
        title = "Leaderboard"
        
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

        view.addSubview(kontwòl_segment)
        view.addSubview(tab_vi)
        view.addSubview(zone_vid)
        zone_vid.addSubview(lab_vid)

        tab_vi.delegate = self
        tab_vi.dataSource = self
        tab_vi.register(CellPwen.self, forCellReuseIdentifier: "PwenCell")

        kontwòl_segment.addTarget(self, action: #selector(chanje_segment(_:)), for: .valueChanged)

        monte_kontrènt()
    }

    private func monte_kontrènt() {
        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            kontwòl_segment.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            kontwòl_segment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            kontwòl_segment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tab_vi.topAnchor.constraint(equalTo: kontwòl_segment.bottomAnchor, constant: 16),
            tab_vi.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tab_vi.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tab_vi.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            zone_vid.topAnchor.constraint(equalTo: tab_vi.topAnchor),
            zone_vid.leadingAnchor.constraint(equalTo: tab_vi.leadingAnchor),
            zone_vid.trailingAnchor.constraint(equalTo: tab_vi.trailingAnchor),
            zone_vid.bottomAnchor.constraint(equalTo: tab_vi.bottomAnchor),

            lab_vid.centerXAnchor.constraint(equalTo: zone_vid.centerXAnchor),
            lab_vid.centerYAnchor.constraint(equalTo: zone_vid.centerYAnchor),
            lab_vid.widthAnchor.constraint(equalTo: zone_vid.widthAnchor, multiplier: 0.8)
        ])
    }

    // MARK: - Data
    private func chaje_done() {
        done_anrejistre = JerèrPwen.pataje.jwennKlasmanPou(nivo_chwazi)
        tab_vi.reloadData()

        zone_vid.isHidden = !done_anrejistre.isEmpty
    }

    // MARK: - Actions
    @objc private func chanje_segment(_ sender: UISegmentedControl) {
        nivo_chwazi = NivoJwe.allCases[sender.selectedSegmentIndex]
        chaje_done()
    }
}

// MARK: - UITableViewDataSource
extension KlasmanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return done_anrejistre.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PwenCell", for: indexPath) as! CellPwen
        let anrej = done_anrejistre[indexPath.row]
        let pozisyon = indexPath.row + 1
        cell.prepare(anrej, pozisyon: pozisyon)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KlasmanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Custom Cell
class CellPwen: UITableViewCell {

    private let zone_kontni: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 1.0, alpha: 0.98)
        vi.layer.cornerRadius = DesignRadius.medium
        vi.layer.applyShadow(.medium)
        vi.translatesAutoresizingMaskIntoConstraints = false
        
        vi.layer.borderWidth = 1.0
        vi.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        return vi
    }()

    private let lab_ran: UILabel = {
        let lab = UILabel()
        lab.font = DesignTypography.title2
        lab.textAlignment = .center
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private let lab_pwen: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 32, weight: .black)
        lab.textColor = DesignColors.primaryGradientStart
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    private let lab_dat: UILabel = {
        let lab = UILabel()
        lab.font = DesignTypography.caption
        lab.textColor = DesignColors.textSecondary
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        monte_ui()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func monte_ui() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(zone_kontni)
        zone_kontni.addSubview(lab_ran)
        zone_kontni.addSubview(lab_pwen)
        zone_kontni.addSubview(lab_dat)

        NSLayoutConstraint.activate([
            zone_kontni.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            zone_kontni.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            zone_kontni.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            zone_kontni.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            lab_ran.leadingAnchor.constraint(equalTo: zone_kontni.leadingAnchor, constant: 16),
            lab_ran.centerYAnchor.constraint(equalTo: zone_kontni.centerYAnchor),
            lab_ran.widthAnchor.constraint(equalToConstant: 50),

            lab_pwen.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -16),
            lab_pwen.topAnchor.constraint(equalTo: zone_kontni.topAnchor, constant: 12),

            lab_dat.trailingAnchor.constraint(equalTo: zone_kontni.trailingAnchor, constant: -16),
            lab_dat.bottomAnchor.constraint(equalTo: zone_kontni.bottomAnchor, constant: -12)
        ])
    }

    func prepare(_ anrej: AnrejistrePwen, pozisyon: Int) {
        let ikòn: String
        switch pozisyon {
        case 1: ikòn = "🥇"
        case 2: ikòn = "🥈"
        case 3: ikòn = "🥉"
        default: ikòn = "#\(pozisyon)"
        }

        lab_ran.text = ikòn
        lab_pwen.text = "\(anrej.pwen)"
        lab_dat.text = anrej.datAfiche

        if pozisyon <= 3 {
            let grad = CAGradientLayer()
            let koulè_baz: UIColor
            
            switch pozisyon {
            case 1: koulè_baz = DesignColors.warningGradientStart
            case 2: koulè_baz = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
            case 3: koulè_baz = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
            default: koulè_baz = .white
            }
            
            grad.colors = [
                koulè_baz.withAlphaComponent(0.15).cgColor,
                koulè_baz.withAlphaComponent(0.05).cgColor
            ]
            grad.startPoint = CGPoint(x: 0, y: 0.5)
            grad.endPoint = CGPoint(x: 1, y: 0.5)
            grad.cornerRadius = DesignRadius.medium
            grad.frame = zone_kontni.bounds
            
            zone_kontni.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
            zone_kontni.layer.insertSublayer(grad, at: 0)
        } else {
            zone_kontni.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
        }
    }
}
