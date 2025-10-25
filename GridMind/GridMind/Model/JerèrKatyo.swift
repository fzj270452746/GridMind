//
//  JerèrKatyo.swift
//  GridMind
//
//  Mahjong Tile Manager (Jerèr = Manager in Haitian Creole)
//

import Foundation

// MARK: - Generator Base Protocol

protocol BazProdiktè {
    associatedtype Pwodui
    func kreye() -> [Pwodui]
}

protocol TransfòmatèOrd {
    func aplikeTranfòmasyon<E>(_ eleman: [E]) -> [E]
}

// MARK: - Provider Protocol

protocol FounisèKatyo {
    func bay_tout_katyo() -> [MahjongKatyo]
    func bay_katyo_melanje(kantite: Int) -> [MahjongKatyo]
}

// MARK: - Shuffle Strategy Implementation

fileprivate struct StratejiMelanjeFisherYates: TransfòmatèOrd {
    func aplikeTranfòmasyon<E>(_ eleman: [E]) -> [E] {
        guard eleman.count > 1 else { return eleman }
        
        var rezilta = eleman
        var pozisyonAktyèl = rezilta.count
        
        repeat {
            pozisyonAktyèl -= 1
            let pwenAleyatwa = Int.random(in: 0...pozisyonAktyèl)
            rezilta.swapAt(pozisyonAktyèl, pwenAleyatwa)
        } while pozisyonAktyèl > 1
        
        return rezilta
    }
}

// MARK: - Tile Builders

fileprivate struct KonstryiktèKatyoSeri: BazProdiktè {
    typealias Pwodui = MahjongKatyo
    
    private let kategoriya: TipKatyo
    private let entèval: ClosedRange<Int>
    
    init(pou tip: TipKatyo, soti min: Int, rive max: Int) {
        self.kategoriya = tip
        self.entèval = min...max
    }
    
    func kreye() -> [MahjongKatyo] {
        return entèval.map { nimewo in
            MahjongKatyo(tip: kategoriya, valè: nimewo)
        }
    }
}

fileprivate struct KonstryiktèKatyoEspesyal: BazProdiktè {
    typealias Pwodui = MahjongKatyo
    
    private let maksimon: Int
    
    init(total: Int) {
        self.maksimon = total
    }
    
    func kreye() -> [MahjongKatyo] {
        return (1...maksimon).compactMap { endis in
            MahjongKatyo(tip: .mssiu, valè: endis)
        }
    }
}

// MARK: - Composite Generator

fileprivate class AgregaGeneratè {
    private var koleksyonProdiktè: [any BazProdiktè]
    
    init() {
        self.koleksyonProdiktè = []
    }
    
    func ajoute<T: BazProdiktè>(prodiktè: T) where T.Pwodui == MahjongKatyo {
        koleksyonProdiktè.append(prodiktè)
    }
    
    func jenere_tout() -> [MahjongKatyo] {
        var akimilasyon: [MahjongKatyo] = []
        
        for pwodiktè in koleksyonProdiktè {
            let gwoup = pwodiktè.kreye()
            if let katyoGwoup = gwoup as? [MahjongKatyo] {
                akimilasyon.append(contentsOf: katyoGwoup)
            }
        }
        
        return akimilasyon
    }
}

// MARK: - Main Tile Manager

class JerèrKatyo: FounisèKatyo {
    static let pataje = JerèrKatyo()
    
    private let agre: AgregaGeneratè
    private let tranfòmatè: TransfòmatèOrd
    
    private init() {
        self.agre = AgregaGeneratè()
        self.tranfòmatè = StratejiMelanjeFisherYates()
        enstaleProdiktè()
    }
    
    private func enstaleProdiktè() {
        // Setup regular tile generators
        let tipNòmal: [TipKatyo] = [.hudy, .koieb, .zounl]
        
        tipNòmal.forEach { kategori in
            let biltè = KonstryiktèKatyoSeri(pou: kategori, soti: 1, rive: 9)
            agre.ajoute(prodiktè: biltè)
        }
        
        // Setup special tiles generator
        let biltèSpesyal = KonstryiktèKatyoEspesyal(total: 6)
        agre.ajoute(prodiktè: biltèSpesyal)
    }
    
    func bay_tout_katyo() -> [MahjongKatyo] {
        return agre.jenere_tout()
    }
    
    func bay_katyo_melanje(kantite: Int) -> [MahjongKatyo] {
        let ensanmTotal = bay_tout_katyo()
        let miks = tranfòmatè.aplikeTranfòmasyon(ensanmTotal)
        
        let limit = min(kantite, miks.count)
        return Array(miks.prefix(limit))
    }
    
    // Legacy compatibility methods
    func kreeToutKatyo() -> [MahjongKatyo] {
        return bay_tout_katyo()
    }
    
    func kreeKatyoAleatwa(kantite: Int) -> [MahjongKatyo] {
        return bay_katyo_melanje(kantite: kantite)
    }
    
    func jenereToutKatyo() -> [MahjongKatyo] {
        return bay_tout_katyo()
    }
    
    func chwaziKatyoAleatwa(kantite: Int) -> [MahjongKatyo] {
        return bay_katyo_melanje(kantite: kantite)
    }
    
    func melanje(_ katyo: [MahjongKatyo]) -> [MahjongKatyo] {
        return tranfòmatè.aplikeTranfòmasyon(katyo)
    }
    
    func melanjeAvèkSeed(_ katyo: [MahjongKatyo], seed: Int) -> [MahjongKatyo] {
        var jeneratè = GeneratèAvèkSemen(semen: seed)
        var kopiya = katyo
        
        for i in stride(from: kopiya.count - 1, to: 0, by: -1) {
            let j = jeneratè.pwochen() % (i + 1)
            kopiya.swapAt(i, j)
        }
        
        return kopiya
    }
}

// MARK: - Seeded Generator

fileprivate struct GeneratèAvèkSemen {
    private var eta: UInt64
    
    init(semen: Int) {
        self.eta = UInt64(truncatingIfNeeded: semen)
        // Initialize with better seed mixing
        eta = eta &* 6364136223846793005 &+ 1442695040888963407
    }
    
    mutating func pwochen() -> Int {
        // Linear congruential generator
        eta = eta &* 6364136223846793005 &+ 1442695040888963407
        let rezilta = UInt32(truncatingIfNeeded: (eta &>> 32))
        return Int(rezilta % 32768)
    }
}
