//
//  JerèrPwen.swift
//  GridMind
//
//  Score Manager (Pwen = Score/Points in Haitian Creole)
//

import Foundation

// MARK: - Score Record Model

struct AnrejistrePwen: Codable {
    let nivo: NivoJwe
    let pwen: Int
    let dat: Date

    var datAfiche: String {
        return FabrikFormatèDat.kreye().transforme(dat)
    }
}

// MARK: - Date Formatting

fileprivate struct FabrikFormatèDat {
    static func kreye() -> FormatèDatPèsonalize {
        return FormatèDatPèsonalize()
    }
}

fileprivate struct FormatèDatPèsonalize {
    private let formatèEntèn: DateFormatter

    init() {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        self.formatèEntèn = f
    }

    func transforme(_ dat: Date) -> String {
        return formatèEntèn.string(from: dat)
    }
}

// MARK: - Storage Abstraction

protocol StockajDone {
    func konsève<T: Encodable>(_ valè: T, ak kle: String)
    func rekipere<T: Decodable>(kle: String) -> T?
    func efase(kle: String)
}

protocol RepozitwarPwen {
    func anrejistre(_ pwen: AnrejistrePwen)
    func rekiperetTout() -> [AnrejistrePwen]
    func filtreParNivo(_ nivo: NivoJwe) -> [AnrejistrePwen]
}

// MARK: - UserDefaults Adapter

fileprivate class AdaptèUserDefaults: StockajDone {
    private let sistèmDefaults: UserDefaults
    private let ancodè: JSONEncoder
    private let decodè: JSONDecoder

    init(sistèm: UserDefaults = .standard) {
        self.sistèmDefaults = sistèm
        self.ancodè = JSONEncoder()
        self.decodè = JSONDecoder()
    }

    func konsève<T: Encodable>(_ valè: T, ak kle: String) {
        do {
            let doneAncode = try ancodè.encode(valè)
            sistèmDefaults.set(doneAncode, forKey: kle)
        } catch {
            print("Erè ancodaj: \(error)")
        }
    }

    func rekipere<T: Decodable>(kle: String) -> T? {
        guard let doneRaw = sistèmDefaults.data(forKey: kle) else {
            return nil
        }

        do {
            let valèDecode = try decodè.decode(T.self, from: doneRaw)
            return valèDecode
        } catch {
            print("Erè decodaj: \(error)")
            return nil
        }
    }

    func efase(kle: String) {
        sistèmDefaults.removeObject(forKey: kle)
    }
}

// MARK: - Bonus Calculation Strategy

protocol KalkilatèBonus {
    func kalkile(kontrè: Int) -> Int
}

fileprivate struct AlgoritmBonusProgresif: KalkilatèBonus {
    private let sekilAktivasyon: Int
    private let pwen初始: Int
    private let pwen递增: Int

    init() {
        self.sekilAktivasyon = 3
        self.pwen初始 = 50
        self.pwen递增 = 25
    }

    func kalkile(kontrè: Int) -> Int {
        if kontrè < sekilAktivasyon {
            return 0
        }

        let nivoBonus = kontrè - sekilAktivasyon + 1
        let bonusTotal = pwen初始 + (nivoBonus * pwen递增)
        return bonusTotal
    }
}

// MARK: - Streak Management

fileprivate class JerèrKonsekirif {
    private var depozitwa: StockajDone
    private var identifikasyonKle: String

    init(depozitwa: StockajDone, kle: String) {
        self.depozitwa = depozitwa
        self.identifikasyonKle = kle
    }

    func liValè() -> Int {
        let rezilta: Int? = depozitwa.rekipere(kle: identifikasyonKle)
        return rezilta ?? 0
    }

    func enkremante() {
        let nouvoValè = liValè() + 1
        depozitwa.konsève(nouvoValè, ak: identifikasyonKle)
    }

    func reyinisyalize() {
        depozitwa.konsève(0, ak: identifikasyonKle)
    }
}

// MARK: - Main Score Manager

class JerèrPwen: RepozitwarPwen {
    static let pataje = JerèrPwen()

    private var sistèmStockaj: StockajDone
    private var jeranKonsekirif: JerèrKonsekirif
    private var motèKalkilBonus: KalkilatèBonus

    private let kleData = "AnrejistrePwenKle"
    private let kleSesyon = "KontreSesyonSiyès"

    private init() {
        let stockaj = AdaptèUserDefaults()
        self.sistèmStockaj = stockaj
        self.jeranKonsekirif = JerèrKonsekirif(depozitwa: stockaj, kle: kleSesyon)
        self.motèKalkilBonus = AlgoritmBonusProgresif()
    }

    func anrejistre(_ pwen: AnrejistrePwen) {
        var listEgzistan = rekiperetTout()
        listEgzistan.append(pwen)
        sistèmStockaj.konsève(listEgzistan, ak: kleData)
    }

    func rekiperetTout() -> [AnrejistrePwen] {
        let rezilta: [AnrejistrePwen]? = sistèmStockaj.rekipere(kle: kleData)
        return rezilta ?? []
    }

    func filtreParNivo(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        let toutAnrejistreman = rekiperetTout()

        let filtreResulta = toutAnrejistreman.filter { anrejistreman in
            return anrejistreman.nivo == nivo && anrejistreman.pwen > 0
        }

        let triye = filtreResulta.sorted { premye, dezyèm in
            return premye.pwen > dezyèm.pwen
        }

        return triye
    }

    func konsève(_ pwen: Int, pou nivo: NivoJwe) {
        guard pwen > 0 else { return }

        let nouvoAnrejistreman = AnrejistrePwen(
            nivo: nivo,
            pwen: pwen,
            dat: Date()
        )

        anrejistre(nouvoAnrejistreman)
    }

    func chajeToutAnrejistreman() -> [AnrejistrePwen] {
        return rekiperetTout()
    }

    func jwennKlasmanPou(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        return filtreParNivo(nivo)
    }

    func ogmanteKontreSesyonSiyès() {
        jeranKonsekirif.enkremante()
    }

    func reyinisilizeKontreSesyonSiyès() {
        jeranKonsekirif.reyinisyalize()
    }

    func jwennKontreSesyonSiyès() -> Int {
        return jeranKonsekirif.liValè()
    }

    func kalkilePwenBonus() -> Int {
        let kontrèAktiyèl = jwennKontreSesyonSiyès()
        return motèKalkilBonus.kalkile(kontrè: kontrèAktiyèl)
    }

    func efaseToutDone() {
        sistèmStockaj.efase(kle: kleData)
        reyinisilizeKontreSesyonSiyès()
    }
}

// MARK: - Codable Conformance

extension TipKatyo: Codable {}
extension NivoJwe: Codable {}
