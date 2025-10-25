//
//  JerèrPwen.swift
//  GridMind
//
//  Score Manager (Pwen = Score/Points in Haitian Creole)
//

import Foundation

// MARK: - Score Entry Model

struct AnrejistrePwen: Codable {
    let nivo: NivoJwe
    let pwen: Int
    let dat: Date

    var datAfiche: String {
        return FormatèDat.enstans.tranfòme(dat)
    }
}

// MARK: - Date Formatter Singleton

fileprivate class FormatèDat {
    static let enstans = FormatèDat()
    
    private let formatè: DateFormatter
    
    private init() {
        self.formatè = DateFormatter()
        formatè.dateStyle = .medium
        formatè.timeStyle = .short
    }
    
    func tranfòme(_ dat: Date) -> String {
        return formatè.string(from: dat)
    }
}

// MARK: - Persistence Abstraction

protocol KouchPèsistans {
    func ekri<T: Encodable>(_ objè: T, nan kle: String)
    func li<T: Decodable>(kle: String) -> T?
    func retire(kle: String)
}

protocol EntrepozoPwen {
    func sove(_ pwen: AnrejistrePwen)
    func chaje_tout() -> [AnrejistrePwen]
    func filtre_pa_nivo(_ nivo: NivoJwe) -> [AnrejistrePwen]
}

// MARK: - UserDefaults Wrapper

fileprivate class PerstansUserDefaults: KouchPèsistans {
    private let depo: UserDefaults
    private let kodè_json: JSONEncoder
    private let dekodè_json: JSONDecoder
    
    init(depozitwa: UserDefaults = .standard) {
        self.depo = depozitwa
        self.kodè_json = JSONEncoder()
        self.dekodè_json = JSONDecoder()
    }
    
    func ekri<T: Encodable>(_ objè: T, nan kle: String) {
        guard let done = try? kodè_json.encode(objè) else {
            print("Erè ancodaj objè pou kle: \(kle)")
            return
        }
        depo.set(done, forKey: kle)
        depo.synchronize()
    }
    
    func li<T: Decodable>(kle: String) -> T? {
        guard let done = depo.data(forKey: kle) else {
            return nil
        }
        
        return try? dekodè_json.decode(T.self, from: done)
    }
    
    func retire(kle: String) {
        depo.removeObject(forKey: kle)
        depo.synchronize()
    }
}

// MARK: - Bonus Calculator

protocol MotèKalkil {
    func kalkile_bonus(seri: Int) -> Int
}

fileprivate struct KalkilatèBonusProgresif: MotèKalkil {
    private let minimòm_pou_aktive: Int
    private let baz_pwen: Int
    private let eskalasyon: Int
    
    init() {
        self.minimòm_pou_aktive = 3
        self.baz_pwen = 50
        self.eskalasyon = 25
    }
    
    func kalkile_bonus(seri: Int) -> Int {
        guard seri >= minimòm_pou_aktive else {
            return 0
        }
        
        let nivo_bonus = seri - minimòm_pou_aktive + 1
        let total = baz_pwen + (nivo_bonus * eskalasyon)
        return total
    }
}

// MARK: - Streak Tracker

fileprivate class SyiviSeri {
    private var  sistèm: KouchPèsistans
    private var klef_estokaj: String
    
    init(sistèm_pèsistans: KouchPèsistans, kle: String) {
        self.sistèm = sistèm_pèsistans
        self.klef_estokaj = kle
    }
    
    func jwenn_valè() -> Int {
        let rezilta: Int? = sistèm.li(kle: klef_estokaj)
        return rezilta ?? 0
    }
    
    func ogmante() {
        let nouvo = jwenn_valè() + 1
        sistèm.ekri(nouvo, nan: klef_estokaj)
    }
    
    func reyajiste() {
        sistèm.ekri(0, nan: klef_estokaj)
    }
}

// MARK: - Main Score Manager

class JerèrPwen: EntrepozoPwen {
    static let pataje = JerèrPwen()
    
    private let koudistokaj: KouchPèsistans
    private let trakè_seri: SyiviSeri
    private let kalkilatè: MotèKalkil
    
    private let kle_pwentaj = "AnrejistrePwenKle"
    private let kle_reyisi = "KontreSesyonSiyès"
    
    private init() {
        let pèsistans = PerstansUserDefaults()
        self.koudistokaj = pèsistans
        self.trakè_seri = SyiviSeri(sistèm_pèsistans: pèsistans, kle: kle_reyisi)
        self.kalkilatè = KalkilatèBonusProgresif()
    }
    
    func sove(_ pwen: AnrejistrePwen) {
        var lis_egzistan = chaje_tout()
        lis_egzistan.append(pwen)
        koudistokaj.ekri(lis_egzistan, nan: kle_pwentaj)
    }
    
    func chaje_tout() -> [AnrejistrePwen] {
        let rezilta: [AnrejistrePwen]? = koudistokaj.li(kle: kle_pwentaj)
        return rezilta ?? []
    }
    
    func filtre_pa_nivo(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        let tout = chaje_tout()
        
        let seleksyone = tout.filter { rekò in
            return rekò.nivo == nivo && rekò.pwen > 0
        }
        
        let odyonè = seleksyone.sorted { premye, dezyèm in
            return premye.pwen > dezyèm.pwen
        }
        
        return odyonè
    }
    
    // Legacy compatibility methods
    func anrejistre(_ pwen: AnrejistrePwen) {
        sove(pwen)
    }
    
    func rekiperetTout() -> [AnrejistrePwen] {
        return chaje_tout()
    }
    
    func filtreParNivo(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        return filtre_pa_nivo(nivo)
    }
    
    func konsève(_ pwen: Int, pou nivo: NivoJwe) {
        guard pwen > 0 else { return }
        
        let nouvo_anrejistreman = AnrejistrePwen(
            nivo: nivo,
            pwen: pwen,
            dat: Date()
        )
        
        sove(nouvo_anrejistreman)
    }
    
    func chajeToutAnrejistreman() -> [AnrejistrePwen] {
        return chaje_tout()
    }
    
    func jwennKlasmanPou(_ nivo: NivoJwe) -> [AnrejistrePwen] {
        return filtre_pa_nivo(nivo)
    }
    
    func ogmanteKontreSesyonSiyès() {
        trakè_seri.ogmante()
    }
    
    func reyinisilizeKontreSesyonSiyès() {
        trakè_seri.reyajiste()
    }
    
    func jwennKontreSesyonSiyès() -> Int {
        return trakè_seri.jwenn_valè()
    }
    
    func kalkilePwenBonus() -> Int {
        let seri_aktyèl = jwennKontreSesyonSiyès()
        return kalkilatè.kalkile_bonus(seri: seri_aktyèl)
    }
    
    func efaseToutDone() {
        koudistokaj.retire(kle: kle_pwentaj)
        reyinisilizeKontreSesyonSiyès()
    }
}

// MARK: - Codable Extensions

extension TipKatyo: Codable {}
extension NivoJwe: Codable {}
