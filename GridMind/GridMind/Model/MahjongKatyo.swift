//
//  MahjongKatyo.swift
//  GridMind
//
//  Mahjong Tile Model (Katyo = Card/Tile in Haitian Creole)
//

import UIKit

// MARK: - Protocols for Abstraction

protocol KoulèStrategy {
    func koulèPouTip() -> UIColor
}

protocol KonfigiraskonNivo {
    var nonAfiche: String { get }
    var dimansyonGriy: (kolòn: Int, ranje: Int) { get }
    var kantiteTotalKatyo: Int { get }
    var koulèPrènsipal: UIColor { get }
}

// MARK: - Color Strategy Implementations

fileprivate struct KoulèHudy: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        .init(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)
    }
}

fileprivate struct KoulèKoieb: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        .init(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
    }
}

fileprivate struct KoulèZounl: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        .init(red: 0.3, green: 0.7, blue: 0.4, alpha: 1.0)
    }
}

fileprivate struct KoulèMssiu: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        .init(red: 0.7, green: 0.5, blue: 0.9, alpha: 1.0)
    }
}

// MARK: - Tile Type with Strategy Pattern

enum TipKatyo: String, CaseIterable {
    case hudy  // 筒
    case koieb // 万
    case zounl // 条
    case mssiu // 特殊牌

    private var strategy: KoulèStrategy {
        let strategies: [TipKatyo: KoulèStrategy] = [
            .hudy: KoulèHudy(),
            .koieb: KoulèKoieb(),
            .zounl: KoulèZounl(),
            .mssiu: KoulèMssiu()
        ]
        return strategies[self]!
    }

    var koulè: UIColor {
        strategy.koulèPouTip()
    }
}

// MARK: - Difficulty Configuration Implementations

fileprivate struct KonfigiraskonFasil: KonfigiraskonNivo {
    var nonAfiche: String { "Easy" }
    var dimansyonGriy: (kolòn: Int, ranje: Int) { (2, 2) }
    var kantiteTotalKatyo: Int { dimansyonGriy.kolòn * dimansyonGriy.ranje }
    var koulèPrènsipal: UIColor {
        .init(red: 0.4, green: 0.8, blue: 0.6, alpha: 1.0)
    }
}

fileprivate struct KonfigiraskonMwayen: KonfigiraskonNivo {
    var nonAfiche: String { "Medium" }
    var dimansyonGriy: (kolòn: Int, ranje: Int) { (3, 2) }
    var kantiteTotalKatyo: Int { dimansyonGriy.kolòn * dimansyonGriy.ranje }
    var koulèPrènsipal: UIColor {
        .init(red: 0.9, green: 0.7, blue: 0.3, alpha: 1.0)
    }
}

fileprivate struct KonfigiraskonDifisil: KonfigiraskonNivo {
    var nonAfiche: String { "Hard" }
    var dimansyonGriy: (kolòn: Int, ranje: Int) { (3, 3) }
    var kantiteTotalKatyo: Int { dimansyonGriy.kolòn * dimansyonGriy.ranje }
    var koulèPrènsipal: UIColor {
        .init(red: 0.9, green: 0.4, blue: 0.4, alpha: 1.0)
    }
}

// MARK: - Game Difficulty with Configuration Pattern

enum NivoJwe: String, CaseIterable {
    case fasil
    case mwayen
    case difisil

    private var konfigirasyon: KonfigiraskonNivo {
        [
            .fasil: KonfigiraskonFasil(),
            .mwayen: KonfigiraskonMwayen(),
            .difisil: KonfigiraskonDifisil()
        ][self]!
    }

    var nonAfiche: String { konfigirasyon.nonAfiche }

    var kantiteKolòn: Int { konfigirasyon.dimansyonGriy.kolòn }

    var kantiteRanje: Int { konfigirasyon.dimansyonGriy.ranje }

    var kantiteTotalKatyo: Int { konfigirasyon.kantiteTotalKatyo }

    var koulèPrènsipal: UIColor { konfigirasyon.koulèPrènsipal }
}

// MARK: - Tile Value Object

struct MahjongKatyo: Equatable, Codable {
    let idantifikasyon: String
    let tip: TipKatyo
    let valè: Int

    var nonImaj: String {
        [tip.rawValue, String(valè)].joined(separator: "_")
    }

    init(tip: TipKatyo, valè: Int) {
        self.idantifikasyon = UUID().uuidString
        self.tip = tip
        self.valè = valè
    }

    static func == (lhs: MahjongKatyo, rhs: MahjongKatyo) -> Bool {
        lhs.idantifikasyon == rhs.idantifikasyon
    }
}

// MARK: - Tile State Wrapper

struct KatyoAvèkPozisyon {
    let katyo: MahjongKatyo
    let endèks: Int
    var chwazi: Bool = false
    var afiche: Bool = false

    mutating func baskileChouazi() {
        chwazi.toggle()
    }

    mutating func baskilaAfiche() {
        afiche.toggle()
    }
}
