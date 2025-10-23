//
//  JerèrKatyo.swift
//  GridMind
//
//  Mahjong Tile Manager (Jerèr = Manager in Haitian Creole)
//

import Foundation

// MARK: - Tile Generation Strategy Protocol

protocol StrategyJenerasyon {
    func jenere() -> [MahjongKatyo]
}

// MARK: - Tile Generation Strategies

fileprivate struct JeneratèKatyoNòmal: StrategyJenerasyon {
    let tip: TipKatyo
    let ranjeValè: ClosedRange<Int>

    func jenere() -> [MahjongKatyo] {
        ranjeValè.map { MahjongKatyo(tip: tip, valè: $0) }
    }
}

fileprivate struct JeneratèKatyoEspesyal: StrategyJenerasyon {
    let ranjeValè: ClosedRange<Int>

    func jenere() -> [MahjongKatyo] {
        ranjeValè.map { MahjongKatyo(tip: .mssiu, valè: $0) }
    }
}

// MARK: - Tile Factory Protocol

protocol FactoryKatyo {
    func kreeToutKatyo() -> [MahjongKatyo]
    func kreeKatyoAleatwa(kantite: Int) -> [MahjongKatyo]
}

// MARK: - Shuffling Strategy Protocol

protocol StrategyMelanje {
    func melanje<T>(_ eleman: [T]) -> [T]
}

fileprivate struct MelanjeAleatwa: StrategyMelanje {
    func melanje<T>(_ eleman: [T]) -> [T] {
        eleman.shuffled()
    }
}

// MARK: - Concrete Tile Factory

class JerèrKatyo: FactoryKatyo {
    static let pataje = JerèrKatyo()

    private let strategyJenerasyon: [StrategyJenerasyon]
    private let strategyMelanje: StrategyMelanje

    private init(
        strategies: [StrategyJenerasyon]? = nil,
        melanjeStrategy: StrategyMelanje? = nil
    ) {
        self.strategyJenerasyon = strategies ?? Self.kreyeStrategyParDefaut()
        self.strategyMelanje = melanjeStrategy ?? MelanjeAleatwa()
    }

    private static func kreyeStrategyParDefaut() -> [StrategyJenerasyon] {
        let tipNòmal: [TipKatyo] = [.hudy, .koieb, .zounl]
        let strategyNòmal = tipNòmal.map { tip in
            JeneratèKatyoNòmal(tip: tip, ranjeValè: 1...9)
        }
        let strategyEspesyal = JeneratèKatyoEspesyal(ranjeValè: 1...6)
        return strategyNòmal + [strategyEspesyal]
    }

    func jenereToutKatyo() -> [MahjongKatyo] {
        kreeToutKatyo()
    }

    func kreeToutKatyo() -> [MahjongKatyo] {
        strategyJenerasyon.flatMap { $0.jenere() }
    }

    func chwaziKatyoAleatwa(kantite: Int) -> [MahjongKatyo] {
        kreeKatyoAleatwa(kantite: kantite)
    }

    func kreeKatyoAleatwa(kantite: Int) -> [MahjongKatyo] {
        let toutKatyo = kreeToutKatyo()
        let melanjeKatyo = strategyMelanje.melanje(toutKatyo)
        return Array(melanjeKatyo.prefix(kantite))
    }

    func melanje(_ katyo: [MahjongKatyo]) -> [MahjongKatyo] {
        strategyMelanje.melanje(katyo)
    }
}
