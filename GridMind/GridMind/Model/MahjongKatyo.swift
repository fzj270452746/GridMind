//
//  MahjongKatyo.swift
//  GridMind
//
//  Mahjong Tile Model (Katyo = Card/Tile in Haitian Creole)
//

import UIKit

// MARK: - Color Configuration Protocol

protocol KoulèStrategy {
    func koulèPouTip() -> UIColor
}

protocol KonfigiraskonNivo {
    var nonAfiche: String { get }
    var dimansyonGriy: (kolòn: Int, ranje: Int) { get }
    var kantiteTotalKatyo: Int { get }
    var koulèPrènsipal: UIColor { get }
}

// MARK: - Tile Category Enum

enum TipKatyo: String, CaseIterable {
    case hudy  // 筒
    case koieb // 万
    case zounl // 条
    case mssiu // 特殊牌

    var koulè: UIColor {
        switch self {
        case .hudy:
            return UIColor(hue: 0.55, saturation: 0.75, brightness: 0.80, alpha: 1.0)
        case .koieb:
            return UIColor(hue: 0.98, saturation: 0.63, brightness: 0.80, alpha: 1.0)
        case .zounl:
            return UIColor(hue: 0.33, saturation: 0.57, brightness: 0.70, alpha: 1.0)
        case .mssiu:
            return UIColor(hue: 0.75, saturation: 0.44, brightness: 0.90, alpha: 1.0)
        }
    }

    private static var stratejiFabrik: [TipKatyo: KoulèStrategy] = {
        return [
            .hudy: KoulèHudyImpl(),
            .koieb: KoulèKoiebImpl(),
            .zounl: KoulèZounlImpl(),
            .mssiu: KoulèMssiuImpl()
        ]
    }()

    func jwennStrategi() -> KoulèStrategy {
        return Self.stratejiFabrik[self]!
    }
}

// MARK: - Color Strategy Concrete Types

fileprivate struct KoulèHudyImpl: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        let rgb = (r: 51.0/255.0, g: 127.0/255.0, b: 204.0/255.0)
        return UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
    }
}

fileprivate struct KoulèKoiebImpl: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        let rgb = (r: 204.0/255.0, g: 76.0/255.0, b: 76.0/255.0)
        return UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
    }
}

fileprivate struct KoulèZounlImpl: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        let rgb = (r: 76.0/255.0, g: 178.0/255.0, b: 102.0/255.0)
        return UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
    }
}

fileprivate struct KoulèMssiuImpl: KoulèStrategy {
    func koulèPouTip() -> UIColor {
        let rgb = (r: 178.0/255.0, g: 127.0/255.0, b: 229.0/255.0)
        return UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
    }
}

// MARK: - Difficulty Level Enum

enum NivoJwe: String, CaseIterable {
    case fasil
    case mwayen
    case difisil

    var nonAfiche: String {
        return jwennKonfigirasyon().nonAfiche
    }

    var kantiteKolòn: Int {
        return jwennKonfigirasyon().dimansyonGriy.kolòn
    }

    var kantiteRanje: Int {
        return jwennKonfigirasyon().dimansyonGriy.ranje
    }

    var kantiteTotalKatyo: Int {
        return jwennKonfigirasyon().kantiteTotalKatyo
    }

    var koulèPrènsipal: UIColor {
        return jwennKonfigirasyon().koulèPrènsipal
    }

    private func jwennKonfigirasyon() -> KonfigiraskonNivo {
        switch self {
        case .fasil:
            return KonfiguraskonFasilImpl()
        case .mwayen:
            return KonfiguraskonMwayenImpl()
        case .difisil:
            return KonfiguraskonDifisilImpl()
        }
    }
}

// MARK: - Difficulty Configuration Implementations

fileprivate struct KonfiguraskonFasilImpl: KonfigiraskonNivo {
    let nonAfiche = "Easy"
    let dimansyonGriy = (kolòn: 2, ranje: 2)

    var kantiteTotalKatyo: Int {
        return dimansyonGriy.kolòn * dimansyonGriy.ranje
    }

    var koulèPrènsipal: UIColor {
        return UIColor(hue: 0.40, saturation: 0.50, brightness: 0.80, alpha: 1.0)
    }
}

fileprivate struct KonfiguraskonMwayenImpl: KonfigiraskonNivo {
    let nonAfiche = "Medium"
    let dimansyonGriy = (kolòn: 3, ranje: 2)

    var kantiteTotalKatyo: Int {
        return dimansyonGriy.kolòn * dimansyonGriy.ranje
    }

    var koulèPrènsipal: UIColor {
        return UIColor(hue: 0.12, saturation: 0.67, brightness: 0.90, alpha: 1.0)
    }
}

fileprivate struct KonfiguraskonDifisilImpl: KonfigiraskonNivo {
    let nonAfiche = "Hard"
    let dimansyonGriy = (kolòn: 3, ranje: 3)

    var kantiteTotalKatyo: Int {
        return dimansyonGriy.kolòn * dimansyonGriy.ranje
    }

    var koulèPrènsipal: UIColor {
        return UIColor(hue: 0.0, saturation: 0.56, brightness: 0.90, alpha: 1.0)
    }
}

// MARK: - Core Tile Data Model

struct MahjongKatyo: Equatable, Codable {
    let idantifikasyon: String
    let tip: TipKatyo
    let valè: Int

    var nonImaj: String {
        return "\(tip.rawValue)_\(valè)"
    }

    init(tip: TipKatyo, valè: Int) {
        self.idantifikasyon = Self.jenereIdanik()
        self.tip = tip
        self.valè = valè
    }

    private static func jenereIdanik() -> String {
        let timestamp = Date().timeIntervalSince1970
        let random = arc4random_uniform(99999)
        return "\(Int(timestamp * 1000))_\(random)"
    }

    static func == (lhs: MahjongKatyo, rhs: MahjongKatyo) -> Bool {
        return lhs.idantifikasyon == rhs.idantifikasyon
    }
}

// MARK: - Tile Positioning State

struct KatyoAvèkPozisyon {
    let katyo: MahjongKatyo
    let endèks: Int
    var chwazi: Bool
    var afiche: Bool

    init(katyo: MahjongKatyo, endèks: Int) {
        self.katyo = katyo
        self.endèks = endèks
        self.chwazi = false
        self.afiche = false
    }

    mutating func baskileChouazi() {
        chwazi = !chwazi
    }

    mutating func baskilaAfiche() {
        afiche = !afiche
    }

    mutating func definiChwazi(_ nouvoEta: Bool) {
        chwazi = nouvoEta
    }

    mutating func definiAfiche(_ nouvoEta: Bool) {
        afiche = nouvoEta
    }
}
