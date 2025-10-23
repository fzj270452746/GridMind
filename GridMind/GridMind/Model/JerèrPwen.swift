//
//  JerèrPwen.swift
//  GridMind
//
//  Score Manager (Pwen = Score/Points in Haitian Creole)
//

import Foundation

// MARK: - Score Value Object

struct AnrejistrePwen: Codable {
    let nivo: NivoJwe
    let pwen: Int
    let dat: Date

    var datAfiche: String {
        KonvertisèDat.shared.konvètiAnTèks(dat)
    }
}

// MARK: - Date Converter Utility

fileprivate class KonvertisèDat {
    static let shared = KonvertisèDat()

    private lazy var formatè: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    private init() {}

    func konvètiAnTèks(_ dat: Date) -> String {
        formatè.string(from: dat)
    }
}

// MARK: - Storage Protocol

protocol StockajDone {
    func konsève<T: Encodable>(_ valè: T, ak kle: String)
    func rekipere<T: Decodable>(kle: String) -> T?
    func efase(kle: String)
}

// MARK: - UserDefaults Storage Implementation

fileprivate class StockajUserDefaults: StockajDone {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func konsève<T: Encodable>(_ valè: T, ak kle: String) {
        guard let enkode = try? JSONEncoder().encode(valè) else { return }
        defaults.set(enkode, forKey: kle)
    }

    func rekipere<T: Decodable>(kle: String) -> T? {
        guard let done = defaults.data(forKey: kle),
              let dekode = try? JSONDecoder().decode(T.self, from: done) else {
            return nil
        }
        return dekode
    }

    func efase(kle: String) {
        defaults.removeObject(forKey: kle)
    }
}

// MARK: - Score Repository Protocol

protocol RepozitwarPwen {
    func anrejistre(_ pwen: AnrejistrePwen)
    func rekiperetTout() -> [AnrejistrePwen]
    func filtreParNivo(_ nivo: NivoJwe) -> [AnrejistrePwen]
}

// MARK: - Bonus Calculator Protocol

protocol KalkilatèBonus {
    func kalkile(kontrè: Int) -> Int
}

fileprivate struct KalkilatèBonusKonsekirif: KalkilatèBonus {
    private let sekilMinimòm: Int = 3
    private let bonusBaz: Int = 50
    private let miltiplikatè: Int = 25

    func kalkile(kontrè: Int) -> Int {
        guard kontrè >= sekilMinimòm else { return 0 }
        return bonusBaz + (kontrè - (sekilMinimòm - 1)) * miltiplikatè
    }
}

// MARK: - Streak Tracker

fileprivate class SuiviKonsekirif {
    private let stockaj: StockajDone
    private let kle: String

    init(stockaj: StockajDone, kle: String) {
        self.stockaj = stockaj
        self.kle = kle
    }

    var valèAktiyèl: Int {
        stockaj.rekipere(kle: kle) ?? 0
    }

    func ogmante() {
        stockaj.konsève(valèAktiyèl + 1, ak: kle)
    }

    func reyinisyalize() {
        stockaj.konsève(0, ak: kle)
    }
}

// MARK: - Score Manager Implementation

class JerèrPwen: RepozitwarPwen {
    static let pataje = JerèrPwen()

    private let stockaj: StockajDone
    private let suiviKonsekirif: SuiviKonsekirif
    private let kalkilatè: KalkilatèBonus

    private let kleAnrejistreman = "AnrejistrePwenKle"
    private let kleSesyon = "KontreSesyonSiyès"

    private init(
        stockaj: StockajDone? = nil,
        kalkilatè: KalkilatèBonus? = nil
    ) {
        let stock = stockaj ?? StockajUserDefaults()
        self.stockaj = stock
        self.suiviKonsekirif = SuiviKonsekirif(stockaj: stock, kle: kleSesyon)
        self.kalkilatè = kalkilatè ?? KalkilatèBonusKonsekirif()
    }

    func konsève(_ pwen: Int, pou nivo: NivoJwe) {
        guard pwen > 0 else { return }
        let nouvo = AnrejistrePwen(nivo: nivo, pwen: pwen, dat: Date())
        anrejistre(nouvo)
    }

    func anrejistre(_ pwen: AnrejistrePwen) {
        let tout = rekiperetTout()
        let nouvoLis = tout + [pwen]
        stockaj.konsève(nouvoLis, ak: kleAnrejistreman)
    }

    func chajeToutAnrejistreman() -> [AnrejistrePwen] {
        rekiperetTout()
    }

    func rekiperetTout() -> [AnrejistrePwen] {
        stockaj.rekipere(kle: kleAnrejistreman) ?? []
    }

    func jwennKlasmanPou(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        filtreParNivo(nivo)
    }

    func filtreParNivo(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        rekiperetTout()
            .filter { $0.nivo == nivo && $0.pwen > 0 }
            .sorted { $0.pwen > $1.pwen }
    }

    func ogmanteKontreSesyonSiyès() {
        suiviKonsekirif.ogmante()
    }

    func reyinisilizeKontreSesyonSiyès() {
        suiviKonsekirif.reyinisyalize()
    }

    func jwennKontreSesyonSiyès() -> Int {
        suiviKonsekirif.valèAktiyèl
    }

    func kalkilePwenBonus() -> Int {
        kalkilatè.kalkile(kontrè: suiviKonsekirif.valèAktiyèl)
    }
}

// MARK: - Extensions for Codable

extension TipKatyo: Codable {}
extension NivoJwe: Codable {}
