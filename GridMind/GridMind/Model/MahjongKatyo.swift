//
//  MahjongKatyo.swift
//  GridMind
//
//  Mahjong Tile Model (Katyo = Card/Tile in Haitian Creole)
//

import UIKit

// MARK: - Abstract Renderer Protocol

protocol RendèKoulè {
    var koulèPriyoritè: UIColor { get }
    func kalkileKoulèDinamik(pou valè: Int) -> UIColor
}

// MARK: - Level Descriptor Protocol

protocol DescrirèNivo {
    func jwenn_non() -> String
    func jwenn_dimansyon() -> (lajè: Int, otè: Int)
    func jwenn_total() -> Int
    func jwenn_tèm_koulè() -> UIColor
}

// MARK: - Tile Type with Computed Colors

enum TipKatyo: String, CaseIterable {
    case hudy  // 筒
    case koieb // 万
    case zounl // 条
    case mssiu // 特殊牌

    var koulè: UIColor {
        return kreye_randè_koulè().koulèPriyoritè
    }

    func kreye_randè_koulè() -> RendèKoulè {
        let mappaj: [TipKatyo: RendèKoulè] = [
            .hudy: RandèHudy(),
            .koieb: RandèKoieb(),
            .zounl: RandèZounl(),
            .mssiu: RandèMssiu()
        ]
        return mappaj[self] ?? RandèHudy()
    }
    
    func jwennStrategi() -> RendèKoulè {
        return kreye_randè_koulè()
    }
}

// MARK: - Color Renderers Implementation

fileprivate struct RandèHudy: RendèKoulè {
    var koulèPriyoritè: UIColor {
        return UIColor(hue: 0.56, saturation: 0.77, brightness: 0.82, alpha: 1.0)
    }
    
    func kalkileKoulèDinamik(pou valè: Int) -> UIColor {
        let faktè = CGFloat(valè) / 9.0
        return UIColor(red: 51.0/255.0 + faktè * 0.1, 
                      green: 127.0/255.0 + faktè * 0.05,
                      blue: 204.0/255.0 - faktè * 0.1, 
                      alpha: 1.0)
    }
}

fileprivate struct RandèKoieb: RendèKoulè {
    var koulèPriyoritè: UIColor {
        return UIColor(hue: 0.99, saturation: 0.65, brightness: 0.82, alpha: 1.0)
    }
    
    func kalkileKoulèDinamik(pou valè: Int) -> UIColor {
        let faktè = CGFloat(valè) / 9.0
        return UIColor(red: 204.0/255.0 - faktè * 0.08,
                      green: 76.0/255.0 + faktè * 0.12,
                      blue: 76.0/255.0 + faktè * 0.05,
                      alpha: 1.0)
    }
}

fileprivate struct RandèZounl: RendèKoulè {
    var koulèPriyoritè: UIColor {
        return UIColor(hue: 0.34, saturation: 0.59, brightness: 0.72, alpha: 1.0)
    }
    
    func kalkileKoulèDinamik(pou valè: Int) -> UIColor {
        let faktè = CGFloat(valè) / 9.0
        return UIColor(red: 76.0/255.0 + faktè * 0.06,
                      green: 178.0/255.0 - faktè * 0.1,
                      blue: 102.0/255.0 + faktè * 0.08,
                      alpha: 1.0)
    }
}

fileprivate struct RandèMssiu: RendèKoulè {
    var koulèPriyoritè: UIColor {
        return UIColor(hue: 0.76, saturation: 0.46, brightness: 0.92, alpha: 1.0)
    }
    
    func kalkileKoulèDinamik(pou valè: Int) -> UIColor {
        let faktè = CGFloat(valè) / 6.0
        return UIColor(red: 178.0/255.0 + faktè * 0.05,
                      green: 127.0/255.0 - faktè * 0.08,
                      blue: 229.0/255.0 - faktè * 0.06,
                      alpha: 1.0)
    }
}

// MARK: - Game Difficulty Levels

enum NivoJwe: String, CaseIterable {
    case fasil
    case mwayen
    case difisil

    var nonAfiche: String {
        return fabrike_deskriptè().jwenn_non()
    }

    var kantiteKolòn: Int {
        return fabrike_deskriptè().jwenn_dimansyon().lajè
    }

    var kantiteRanje: Int {
        return fabrike_deskriptè().jwenn_dimansyon().otè
    }

    var kantiteTotalKatyo: Int {
        return fabrike_deskriptè().jwenn_total()
    }

    var koulèPrènsipal: UIColor {
        return fabrike_deskriptè().jwenn_tèm_koulè()
    }

    private func fabrike_deskriptè() -> DescrirèNivo {
        let registri: [NivoJwe: DescrirèNivo] = [
            .fasil: DeskriptèFasil(),
            .mwayen: DeskriptèMwayen(),
            .difisil: DeskriptèDifisil()
        ]
        return registri[self] ?? DeskriptèFasil()
    }
}

// MARK: - Level Descriptors

fileprivate struct DeskriptèFasil: DescrirèNivo {
    private let strukturGrid = (x: 2, y: 2)
    
    func jwenn_non() -> String { "Easy" }
    
    func jwenn_dimansyon() -> (lajè: Int, otè: Int) {
        return (lajè: strukturGrid.x, otè: strukturGrid.y)
    }
    
    func jwenn_total() -> Int {
        return strukturGrid.x * strukturGrid.y
    }
    
    func jwenn_tèm_koulè() -> UIColor {
        return UIColor(hue: 0.41, saturation: 0.52, brightness: 0.82, alpha: 1.0)
    }
}

fileprivate struct DeskriptèMwayen: DescrirèNivo {
    private let strukturGrid = (x: 3, y: 2)
    
    func jwenn_non() -> String { "Medium" }
    
    func jwenn_dimansyon() -> (lajè: Int, otè: Int) {
        return (lajè: strukturGrid.x, otè: strukturGrid.y)
    }
    
    func jwenn_total() -> Int {
        return strukturGrid.x * strukturGrid.y
    }
    
    func jwenn_tèm_koulè() -> UIColor {
        return UIColor(hue: 0.13, saturation: 0.69, brightness: 0.92, alpha: 1.0)
    }
}

fileprivate struct DeskriptèDifisil: DescrirèNivo {
    private let strukturGrid = (x: 3, y: 3)
    
    func jwenn_non() -> String { "Hard" }
    
    func jwenn_dimansyon() -> (lajè: Int, otè: Int) {
        return (lajè: strukturGrid.x, otè: strukturGrid.y)
    }
    
    func jwenn_total() -> Int {
        return strukturGrid.x * strukturGrid.y
    }
    
    func jwenn_tèm_koulè() -> UIColor {
        return UIColor(hue: 0.01, saturation: 0.58, brightness: 0.92, alpha: 1.0)
    }
}

// MARK: - Core Tile Entity

struct MahjongKatyo: Equatable, Codable {
    let idantifikasyon: String
    let tip: TipKatyo
    let valè: Int

    var nonImaj: String {
        return konstryiNonRessource()
    }
    
    private func konstryiNonRessource() -> String {
        return [tip.rawValue, String(valè)].joined(separator: "_")
    }

    init(tip: TipKatyo, valè: Int) {
        self.idantifikasyon = MahjongKatyo.jenereidUnik()
        self.tip = tip
        self.valè = valè
    }

    private static func jenereidUnik() -> String {
        let tanKounyea = Date().timeIntervalSince1970
        let aleyatwa = UInt32.random(in: 10000...99999)
        let konpoze = String(format: "%.0f_%05u", tanKounyea * 1000, aleyatwa)
        return konpoze
    }

    static func == (lhs: MahjongKatyo, rhs: MahjongKatyo) -> Bool {
        return lhs.idantifikasyon == rhs.idantifikasyon
    }
}

// MARK: - Positioned Tile State Manager

struct KatyoAvèkPozisyon {
    private(set) var katyo: MahjongKatyo
    private(set) var endèks: Int
    private var etaSeleksyon: Bool
    private var etaVizibilite: Bool

    var chwazi: Bool {
        get { return etaSeleksyon }
        set { etaSeleksyon = newValue }
    }
    
    var afiche: Bool {
        get { return etaVizibilite }
        set { etaVizibilite = newValue }
    }

    init(katyo: MahjongKatyo, endèks: Int) {
        self.katyo = katyo
        self.endèks = endèks
        self.etaSeleksyon = false
        self.etaVizibilite = false
    }

    mutating func baskileChouazi() {
        etaSeleksyon.toggle()
    }

    mutating func baskilaAfiche() {
        etaVizibilite.toggle()
    }

    mutating func definiChwazi(_ nouvoEta: Bool) {
        etaSeleksyon = nouvoEta
    }

    mutating func definiAfiche(_ nouvoEta: Bool) {
        etaVizibilite = nouvoEta
    }
    
    mutating func reyinisyalize() {
        etaSeleksyon = false
        etaVizibilite = false
    }
}
