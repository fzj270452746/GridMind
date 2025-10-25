//
//  EfèPatikilSiyès.swift
//  GridMind
//
//  Success Particle Effect (Patikil = Particles in Haitian Creole)
//

import UIKit

// MARK: - Particle Configuration

struct KonfigiraskonPatikil {
    let koulè: UIColor
    let vitès: CGFloat
    let dire: CGFloat
    let echèl: CGFloat

    static var defaut: [KonfigiraskonPatikil] {
        return [
            // Purple-Blue gradient colors
            kreyeKonfig(wouj: 0.49, vèt: 0.31, ble: 0.94, vitès: 150, dire: 2.5, echèl: 0.6),
            kreyeKonfig(wouj: 0.29, vèt: 0.51, ble: 0.95, vitès: 130, dire: 2.0, echèl: 0.55),
            // Success green
            kreyeKonfig(wouj: 0.25, vèt: 0.82, ble: 0.58, vitès: 140, dire: 2.3, echèl: 0.58),
            // Golden yellow
            kreyeKonfig(wouj: 1.0, vèt: 0.75, ble: 0.29, vitès: 160, dire: 2.8, echèl: 0.62),
            // Orange accent
            kreyeKonfig(wouj: 1.0, vèt: 0.55, ble: 0.36, vitès: 145, dire: 2.2, echèl: 0.57)
        ]
    }

    private static func kreyeKonfig(wouj: CGFloat, vèt: CGFloat, ble: CGFloat, vitès: CGFloat, dire: CGFloat, echèl: CGFloat) -> KonfigiraskonPatikil {
        return KonfigiraskonPatikil(
            koulè: UIColor(red: wouj, green: vèt, blue: ble, alpha: 1.0),
            vitès: vitès,
            dire: dire,
            echèl: echèl
        )
    }
}

// MARK: - Cell Factory Protocol

fileprivate protocol FactorySelilPatikil {
    func kreeSelil(ak konfig: KonfigiraskonPatikil, imaj: UIImage) -> CAEmitterCell
}

// MARK: - Standard Cell Factory

fileprivate struct KreyatèSelilStandard: FactorySelilPatikil {
    func kreeSelil(ak konfig: KonfigiraskonPatikil, imaj: UIImage) -> CAEmitterCell {
        let selil = CAEmitterCell()

        selil.birthRate = 30.0
        selil.lifetime = 2.5
        selil.lifetimeRange = 0.8
        selil.velocity = konfig.vitès
        selil.velocityRange = 60.0
        selil.emissionRange = CGFloat.pi * 2
        selil.spin = konfig.dire
        selil.spinRange = 4.0
        selil.scaleRange = konfig.echèl
        selil.scaleSpeed = -0.15
        selil.alphaSpeed = -0.4
        selil.contents = imaj.cgImage
        selil.color = konfig.koulè.cgColor

        return selil
    }
}

// MARK: - Shape Generator Protocol

fileprivate protocol JeneratèFòm {
    func kreeImaj(ak koulè: UIColor, gwosè: CGFloat) -> UIImage
}

// MARK: - Star Shape Generator

fileprivate struct ProdiktèEtwal: JeneratèFòm {
    func kreeImaj(ak koulè: UIColor, gwosè: CGFloat) -> UIImage {
        let dimansyon = CGSize(width: gwosè, height: gwosè)
        let rektang = CGRect(origin: CGPoint.zero, size: dimansyon)

        UIGraphicsBeginImageContextWithOptions(dimansyon, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let konteks = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }

        konteks.setFillColor(koulè.cgColor)

        let santral = CGPoint(x: gwosè / 2, y: gwosè / 2)
        let rayon = gwosè / 2
        desineEtwalDans(konteks: konteks, santè: santral, rayon: rayon)

        guard let imajFinal = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }

        return imajFinal
    }

    private func desineEtwalDans(konteks: CGContext, santè: CGPoint, rayon: CGFloat) {
        var pwenEksteryè: [CGPoint] = []
        var pwenEnteryè: [CGFloat] = []

        for i in 0..<5 {
            let ang = CGFloat(i) * CGFloat.pi * 2 / 5 - CGFloat.pi / 2
            let x = santè.x + rayon * cos(ang)
            let y = santè.y + rayon * sin(ang)
            pwenEksteryè.append(CGPoint(x: x, y: y))
        }

        var pwenEntèn: [CGPoint] = []
        for i in 0..<5 {
            let angDekale = CGFloat(i) * CGFloat.pi * 2 / 5 - CGFloat.pi / 2 + CGFloat.pi / 5
            let rayonEntèn = rayon * 0.4
            let x = santè.x + rayonEntèn * cos(angDekale)
            let y = santè.y + rayonEntèn * sin(angDekale)
            pwenEntèn.append(CGPoint(x: x, y: y))
        }

        konteks.beginPath()

        for i in 0..<5 {
            if i == 0 {
                konteks.move(to: pwenEksteryè[i])
            } else {
                konteks.addLine(to: pwenEksteryè[i])
            }
            konteks.addLine(to: pwenEntèn[i])
        }

        konteks.closePath()
        konteks.fillPath()
    }
}

// MARK: - Particle Effect View

class EfèPatikilSiyès: UIView {

    private var koleksyonEmèter: [CAEmitterLayer] = []
    private let fabrikSelil: FactorySelilPatikil
    private let prodiktèFòm: JeneratèFòm

    override init(frame: CGRect) {
        self.fabrikSelil = KreyatèSelilStandard()
        self.prodiktèFòm = ProdiktèEtwal()
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func kòmanseEfèSiyès(nan pozisyon: CGPoint) {
        let nouvoEmèter = fabrikeEmèter(pozisyon: pozisyon)

        var listaSelil: [CAEmitterCell] = []
        for konfig in KonfigiraskonPatikil.defaut {
            let imaj = prodiktèFòm.kreeImaj(ak: konfig.koulè, gwosè: 20)
            let selil = fabrikSelil.kreeSelil(ak: konfig, imaj: imaj)
            listaSelil.append(selil)
        }

        nouvoEmèter.emitterCells = listaSelil
        layer.addSublayer(nouvoEmèter)
        koleksyonEmèter.append(nouvoEmèter)

        programeArete(emèter: nouvoEmèter)
    }

    func kòmanseEfèSelebrasyon() {
        let lajèEkran = bounds.width
        let otèEkran = bounds.height

        var listPozisyon: [CGPoint] = []

        // Create more explosion points for dramatic effect
        for _ in 0..<8 {
            let x = CGFloat.random(in: lajèEkran * 0.15...lajèEkran * 0.85)
            let y = CGFloat.random(in: otèEkran * 0.25...otèEkran * 0.75)
            listPozisyon.append(CGPoint(x: x, y: y))
        }

        for (index, poz) in listPozisyon.enumerated() {
            let delay = Double(index) * 0.08
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.kòmanseEfèSiyès(nan: poz)
            }
        }
    }

    private func fabrikeEmèter(pozisyon: CGPoint) -> CAEmitterLayer {
        let emèter = CAEmitterLayer()
        emèter.emitterPosition = pozisyon
        emèter.emitterShape = .circle
        emèter.emitterSize = CGSize(width: 15, height: 15)
        emèter.renderMode = .additive
        emèter.emitterZPosition = 10
        return emèter
    }

    private func programeArete(emèter: CAEmitterLayer) {
        let delè1: TimeInterval = 2.0
        let delè2: TimeInterval = 2.5

        DispatchQueue.main.asyncAfter(deadline: .now() + delè1) { [weak emèter] in
            guard let emèterReyèl = emèter else { return }
            
            // Gradually fade out
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            emèterReyèl.birthRate = 0
            CATransaction.commit()

            DispatchQueue.main.asyncAfter(deadline: .now() + delè2) {
                emèterReyèl.removeFromSuperlayer()
            }
        }
    }

    func rete() {
        for emèter in koleksyonEmèter {
            emèter.birthRate = 0
            emèter.removeFromSuperlayer()
        }
        koleksyonEmèter.removeAll()
    }
}
