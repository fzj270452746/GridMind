//
//  JerèrKatyo.swift
//  GridMind
//
//  Mahjong Tile Manager (Jerèr = Manager in Haitian Creole)
//

import Foundation

// MARK: - Generation Strategy Protocol

protocol StrategyJenerasyon {
    func jenere() -> [MahjongKatyo]
}

protocol StrategyMelanje {
    func melanje<T>(_ eleman: [T]) -> [T]
}

// MARK: - Factory Protocol

protocol FactoryKatyo {
    func kreeToutKatyo() -> [MahjongKatyo]
    func kreeKatyoAleatwa(kantite: Int) -> [MahjongKatyo]
}

// MARK: - Shuffle Implementation

fileprivate struct AlgoritmMelanjeStandard: StrategyMelanje {
    func melanje<T>(_ eleman: [T]) -> [T] {
        var kopi = eleman
        var endèksCourant = kopi.count

        while endèksCourant > 1 {
            endèksCourant -= 1
            let endèksAleatwa = Int.random(in: 0...endèksCourant)
            kopi.swapAt(endèksCourant, endèksAleatwa)
        }

        return kopi
    }
}

// MARK: - Tile Generation Implementations

fileprivate struct ProdiktèKatyoOdinè: StrategyJenerasyon {
    private let tipKatyo: TipKatyo
    private let ranjeMinMax: (min: Int, max: Int)

    init(tip: TipKatyo, min: Int, max: Int) {
        self.tipKatyo = tip
        self.ranjeMinMax = (min, max)
    }

    func jenere() -> [MahjongKatyo] {
        var rezilta: [MahjongKatyo] = []
        for valè in ranjeMinMax.min...ranjeMinMax.max {
            let katyo = MahjongKatyo(tip: tipKatyo, valè: valè)
            rezilta.append(katyo)
        }
        return rezilta
    }
}

fileprivate struct ProdiktèKatyoSpesyal: StrategyJenerasyon {
    private let limit: Int

    init(kantiteMax: Int) {
        self.limit = kantiteMax
    }

    func jenere() -> [MahjongKatyo] {
        return (1...limit).map { valè in
            MahjongKatyo(tip: .mssiu, valè: valè)
        }
    }
}

// MARK: - Main Tile Manager Class

class JerèrKatyo: FactoryKatyo {
    static let pataje = JerèrKatyo()

    private var koleksyonJeneratè: [StrategyJenerasyon]
    private var algoritmMelanje: StrategyMelanje

    private init() {
        self.koleksyonJeneratè = []
        self.algoritmMelanje = AlgoritmMelanjeStandard()
        konfigireJeneratè()
    }

    private func konfigireJeneratè() {
        let tipOdinè: [TipKatyo] = [.hudy, .koieb, .zounl]

        for tip in tipOdinè {
            let jeneratè = ProdiktèKatyoOdinè(tip: tip, min: 1, max: 9)
            koleksyonJeneratè.append(jeneratè)
        }

        let jeneratèSpesyal = ProdiktèKatyoSpesyal(kantiteMax: 6)
        koleksyonJeneratè.append(jeneratèSpesyal)
    }

    func kreeToutKatyo() -> [MahjongKatyo] {
        var ensanmKatyo: [MahjongKatyo] = []

        for jeneratè in koleksyonJeneratè {
            let katyoJenere = jeneratè.jenere()
            ensanmKatyo += katyoJenere
        }

        return ensanmKatyo
    }

    func kreeKatyoAleatwa(kantite: Int) -> [MahjongKatyo] {
        let toutKatyoDisponib = kreeToutKatyo()
        let katyoMelanje = algoritmMelanje.melanje(toutKatyoDisponib)

        let kantiteReyèl = min(kantite, katyoMelanje.count)
        var seleksyone: [MahjongKatyo] = []

        for i in 0..<kantiteReyèl {
            seleksyone.append(katyoMelanje[i])
        }

        return seleksyone
    }

    func jenereToutKatyo() -> [MahjongKatyo] {
        return kreeToutKatyo()
    }

    func chwaziKatyoAleatwa(kantite: Int) -> [MahjongKatyo] {
        return kreeKatyoAleatwa(kantite: kantite)
    }

    func melanje(_ katyo: [MahjongKatyo]) -> [MahjongKatyo] {
        return algoritmMelanje.melanje(katyo)
    }

    func melanjeAvèkSeed(_ katyo: [MahjongKatyo], seed: Int) -> [MahjongKatyo] {
        var kopi = katyo
        var rng = SeededRandomGenerator(seed: seed)

        for i in stride(from: kopi.count - 1, through: 1, by: -1) {
            let j = Int(rng.next() % UInt32(i + 1))
            kopi.swapAt(i, j)
        }

        return kopi
    }
}

// MARK: - Seeded Random Generator

fileprivate struct SeededRandomGenerator {
    private var state: UInt32

    init(seed: Int) {
        self.state = UInt32(truncatingIfNeeded: seed)
    }

    mutating func next() -> UInt32 {
        state = state &* 1103515245 &+ 12345
        return (state / 65536) % 32768
    }
}
