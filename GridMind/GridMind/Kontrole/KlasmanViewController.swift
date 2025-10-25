//
//  KlasmanViewController.swift
//  GridMind
//
//  Leaderboard View Controller (Klasman = Ranking/Leaderboard in Haitian Creole)
//

import UIKit

class KlasmanViewController: UIViewController {

    // MARK: - Properties
    private let segmanteKontwòl: UISegmentedControl = {
        let items = NivoJwe.allCases.map { $0.nonAfiche }
        let kontwòl = UISegmentedControl(items: items)
        kontwòl.selectedSegmentIndex = 0
        kontwòl.translatesAutoresizingMaskIntoConstraints = false
        return kontwòl
    }()

    private let tablVi: UITableView = {
        let tablVi = UITableView(frame: .zero, style: .insetGrouped)
        tablVi.backgroundColor = .clear
        tablVi.separatorStyle = .none
        tablVi.translatesAutoresizingMaskIntoConstraints = false
        return tablVi
    }()

    private let viVid: UIView = {
        let vi = UIView()
        vi.translatesAutoresizingMaskIntoConstraints = false
        return vi
    }()

    private let etikètVid: UILabel = {
        let etikèt = UILabel()
        etikèt.text = "🏆\n\nNo scores yet!\nPlay games to see your scores here."
        etikèt.numberOfLines = 0
        etikèt.textAlignment = .center
        etikèt.font = DesignTypography.body
        etikèt.textColor = UIColor.white.withAlphaComponent(0.85)
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private var nivoSeleksyone: NivoJwe = .fasil
    private var anrejistreman: [AnrejistrePwen] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        konfigireUI()
        charjeAnrejistreman()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        charjeAnrejistreman()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update background gradient frame
        DynamicBackgroundFactory.updateBackgroundFrame(for: view)
    }

    // MARK: - UI Configuration
    private func konfigireUI() {
        title = "Leaderboard"
        
        // Add dynamic animated background
        DynamicBackgroundFactory.createAnimatedBackground(for: view)
        
        navigationController?.setNavigationBarHidden(false, animated: true)

        // Configure navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = DesignColors.primaryGradientStart
        
        // Make navigation bar transparent
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        view.addSubview(segmanteKontwòl)
        view.addSubview(tablVi)
        view.addSubview(viVid)
        viVid.addSubview(etikètVid)

        tablVi.delegate = self
        tablVi.dataSource = self
        tablVi.register(PwenTableViewCell.self, forCellReuseIdentifier: "PwenCell")

        segmanteKontwòl.addTarget(self, action: #selector(segmanChanje(_:)), for: .valueChanged)

        aplikiKontrènt()
    }

    private func aplikiKontrènt() {
        let gwayidSekire = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            segmanteKontwòl.topAnchor.constraint(equalTo: gwayidSekire.topAnchor, constant: 16),
            segmanteKontwòl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmanteKontwòl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            tablVi.topAnchor.constraint(equalTo: segmanteKontwòl.bottomAnchor, constant: 16),
            tablVi.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tablVi.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tablVi.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            viVid.topAnchor.constraint(equalTo: tablVi.topAnchor),
            viVid.leadingAnchor.constraint(equalTo: tablVi.leadingAnchor),
            viVid.trailingAnchor.constraint(equalTo: tablVi.trailingAnchor),
            viVid.bottomAnchor.constraint(equalTo: tablVi.bottomAnchor),

            etikètVid.centerXAnchor.constraint(equalTo: viVid.centerXAnchor),
            etikètVid.centerYAnchor.constraint(equalTo: viVid.centerYAnchor),
            etikètVid.widthAnchor.constraint(equalTo: viVid.widthAnchor, multiplier: 0.8)
        ])
    }

    // MARK: - Data Management
    private func charjeAnrejistreman() {
        anrejistreman = JerèrPwen.pataje.jwennKlasmanPou(nivoSeleksyone)
        tablVi.reloadData()

        viVid.isHidden = !anrejistreman.isEmpty
    }

    // MARK: - Actions
    @objc private func segmanChanje(_ sender: UISegmentedControl) {
        nivoSeleksyone = NivoJwe.allCases[sender.selectedSegmentIndex]
        charjeAnrejistreman()
    }
}

// MARK: - UITableViewDataSource
extension KlasmanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anrejistreman.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PwenCell", for: indexPath) as! PwenTableViewCell
        let anrejistreman = anrejistreman[indexPath.row]
        let ran = indexPath.row + 1
        cell.konfigire(ak: anrejistreman, ran: ran)
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

// MARK: - Custom Table View Cell
class PwenTableViewCell: UITableViewCell {

    private let kontènèVi: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor(white: 1.0, alpha: 0.98)
        vi.layer.cornerRadius = DesignRadius.medium
        vi.layer.applyShadow(.medium)
        vi.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subtle border
        vi.layer.borderWidth = 1.0
        vi.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        return vi
    }()

    private let etikètRan: UILabel = {
        let etikèt = UILabel()
        etikèt.font = DesignTypography.title2
        etikèt.textAlignment = .center
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private let etikètPwen: UILabel = {
        let etikèt = UILabel()
        etikèt.font = UIFont.systemFont(ofSize: 32, weight: .black)
        etikèt.textColor = DesignColors.primaryGradientStart
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    private let etikètDat: UILabel = {
        let etikèt = UILabel()
        etikèt.font = DesignTypography.caption
        etikèt.textColor = DesignColors.textSecondary
        etikèt.translatesAutoresizingMaskIntoConstraints = false
        return etikèt
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        konfigireUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func konfigireUI() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(kontènèVi)
        kontènèVi.addSubview(etikètRan)
        kontènèVi.addSubview(etikètPwen)
        kontènèVi.addSubview(etikètDat)

        NSLayoutConstraint.activate([
            kontènèVi.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            kontènèVi.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            kontènèVi.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            kontènèVi.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            etikètRan.leadingAnchor.constraint(equalTo: kontènèVi.leadingAnchor, constant: 16),
            etikètRan.centerYAnchor.constraint(equalTo: kontènèVi.centerYAnchor),
            etikètRan.widthAnchor.constraint(equalToConstant: 50),

            etikètPwen.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -16),
            etikètPwen.topAnchor.constraint(equalTo: kontènèVi.topAnchor, constant: 12),

            etikètDat.trailingAnchor.constraint(equalTo: kontènèVi.trailingAnchor, constant: -16),
            etikètDat.bottomAnchor.constraint(equalTo: kontènèVi.bottomAnchor, constant: -12)
        ])
    }

    func konfigire(ak anrejistreman: AnrejistrePwen, ran: Int) {
        let ikònRan: String
        switch ran {
        case 1: ikònRan = "🥇"
        case 2: ikònRan = "🥈"
        case 3: ikònRan = "🥉"
        default: ikònRan = "#\(ran)"
        }

        etikètRan.text = ikònRan
        etikètPwen.text = "\(anrejistreman.pwen)"
        etikètDat.text = anrejistreman.datAfiche

        // Apply gradient for top 3
        if ran <= 3 {
            let gradientLayer = CAGradientLayer()
            let baseColor: UIColor
            
            switch ran {
            case 1: baseColor = DesignColors.warningGradientStart
            case 2: baseColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
            case 3: baseColor = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 1.0)
            default: baseColor = .white
            }
            
            gradientLayer.colors = [
                baseColor.withAlphaComponent(0.15).cgColor,
                baseColor.withAlphaComponent(0.05).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.cornerRadius = DesignRadius.medium
            gradientLayer.frame = kontènèVi.bounds
            
            // Remove old gradient if exists
            kontènèVi.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
            kontènèVi.layer.insertSublayer(gradientLayer, at: 0)
        } else {
            kontènèVi.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
        }
    }
}
