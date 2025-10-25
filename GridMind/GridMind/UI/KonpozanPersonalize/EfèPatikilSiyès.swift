//
//  EfèPatikilSiyès.swift
//  GridMind
//
//  Success Particle Effect (Patikil = Particles in Haitian Creole)
//

import UIKit

// MARK: - Particle Settings

struct ParametPatikil {
    let koulè: UIColor
    let vistès: CGFloat
    let rotasyon: CGFloat
    let echèl_baz: CGFloat

    static var palets_defo: [ParametPatikil] {
        return [
            fabrike(r: 0.49, g: 0.31, b: 0.94, vit: 150, rot: 2.5, ech: 0.6),
            fabrike(r: 0.29, g: 0.51, b: 0.95, vit: 130, rot: 2.0, ech: 0.55),
            fabrike(r: 0.25, g: 0.82, b: 0.58, vit: 140, rot: 2.3, ech: 0.58),
            fabrike(r: 1.0, g: 0.75, b: 0.29, vit: 160, rot: 2.8, ech: 0.62),
            fabrike(r: 1.0, g: 0.55, b: 0.36, vit: 145, rot: 2.2, ech: 0.57)
        ]
    }

    private static func fabrike(r: CGFloat, g: CGFloat, b: CGFloat, vit: CGFloat, rot: CGFloat, ech: CGFloat) -> ParametPatikil {
        return ParametPatikil(
            koulè: UIColor(red: r, green: g, blue: b, alpha: 1.0),
            vistès: vit,
            rotasyon: rot,
            echèl_baz: ech
        )
    }
}

// MARK: - Cell Builder Protocol

fileprivate protocol KonstryiktèSelil {
    func fabrike(_ param: ParametPatikil, imaj: UIImage) -> CAEmitterCell
}

// MARK: - Standard Cell Builder

fileprivate struct BiltèSelilStandard: KonstryiktèSelil {
    func fabrike(_ param: ParametPatikil, imaj: UIImage) -> CAEmitterCell {
        let selil = CAEmitterCell()

        selil.birthRate = 30.0
        selil.lifetime = 2.5
        selil.lifetimeRange = 0.8
        selil.velocity = param.vistès
        selil.velocityRange = 60.0
        selil.emissionRange = CGFloat.pi * 2
        selil.spin = param.rotasyon
        selil.spinRange = 4.0
        selil.scaleRange = param.echèl_baz
        selil.scaleSpeed = -0.15
        selil.alphaSpeed = -0.4
        selil.contents = imaj.cgImage
        selil.color = param.koulè.cgColor

        return selil
    }
}

// MARK: - Image Generator Protocol

fileprivate protocol JeneratèGrafik {
    func pwodui(_ koulè: UIColor, dimansyon: CGFloat) -> UIImage
}

// MARK: - Star Generator

fileprivate struct PwodiktèEtwal: JeneratèGrafik {
    func pwodui(_ koulè: UIColor, dimansyon: CGFloat) -> UIImage {
        let tay = CGSize(width: dimansyon, height: dimansyon)
        let rektang = CGRect(origin: CGPoint.zero, size: tay)

        UIGraphicsBeginImageContextWithOptions(tay, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let konteks = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }

        konteks.setFillColor(koulè.cgColor)

        let sant = CGPoint(x: dimansyon / 2, y: dimansyon / 2)
        let rayon = dimansyon / 2
        desine_etwal_5_pwent(konteks: konteks, santè: sant, rayon: rayon)

        guard let rezilta = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }

        return rezilta
    }

    private func desine_etwal_5_pwent(konteks: CGContext, santè: CGPoint, rayon: CGFloat) {
        var pwent_eksteryè: [CGPoint] = []

        for i in 0..<5 {
            let ang = CGFloat(i) * CGFloat.pi * 2 / 5 - CGFloat.pi / 2
            let x = santè.x + rayon * cos(ang)
            let y = santè.y + rayon * sin(ang)
            pwent_eksteryè.append(CGPoint(x: x, y: y))
        }

        var pwent_enteryè: [CGPoint] = []
        for i in 0..<5 {
            let ang_offset = CGFloat(i) * CGFloat.pi * 2 / 5 - CGFloat.pi / 2 + CGFloat.pi / 5
            let rayon_int = rayon * 0.4
            let x = santè.x + rayon_int * cos(ang_offset)
            let y = santè.y + rayon_int * sin(ang_offset)
            pwent_enteryè.append(CGPoint(x: x, y: y))
        }

        konteks.beginPath()

        for i in 0..<5 {
            if i == 0 {
                konteks.move(to: pwent_eksteryè[i])
            } else {
                konteks.addLine(to: pwent_eksteryè[i])
            }
            konteks.addLine(to: pwent_enteryè[i])
        }

        konteks.closePath()
        konteks.fillPath()
    }
}

// MARK: - Particle Effect View

class EfèPatikilSiyès: UIView {

    private var koleksyon_emèter: [CAEmitterLayer] = []
    private let fabrik_selil: KonstryiktèSelil
    private let jeneratè_imaj: JeneratèGrafik

    override init(frame: CGRect) {
        self.fabrik_selil = BiltèSelilStandard()
        self.jeneratè_imaj = PwodiktèEtwal()
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func kòmanseEfèSiyès(nan pozisyon: CGPoint) {
        let emèter_nouvo = monte_emèter(pozisyon: pozisyon)

        var lis_selil: [CAEmitterCell] = []
        for param in ParametPatikil.palets_defo {
            let imaj = jeneratè_imaj.pwodui(param.koulè, dimansyon: 20)
            let selil = fabrik_selil.fabrike(param, imaj: imaj)
            lis_selil.append(selil)
        }

        emèter_nouvo.emitterCells = lis_selil
        layer.addSublayer(emèter_nouvo)
        koleksyon_emèter.append(emèter_nouvo)

        pwograme_fèmti(emèter: emèter_nouvo)
    }

    func kòmanseEfèSelebrasyon() {
        let lajè = bounds.width
        let otè = bounds.height

        var pozisyon_lis: [CGPoint] = []

        for _ in 0..<8 {
            let x = CGFloat.random(in: lajè * 0.15...lajè * 0.85)
            let y = CGFloat.random(in: otè * 0.25...otè * 0.75)
            pozisyon_lis.append(CGPoint(x: x, y: y))
        }

        for (index, poz) in pozisyon_lis.enumerated() {
            let ret = Double(index) * 0.08
            DispatchQueue.main.asyncAfter(deadline: .now() + ret) {
                self.kòmanseEfèSiyès(nan: poz)
            }
        }
    }

    private func monte_emèter(pozisyon: CGPoint) -> CAEmitterLayer {
        let em = CAEmitterLayer()
        em.emitterPosition = pozisyon
        em.emitterShape = .circle
        em.emitterSize = CGSize(width: 15, height: 15)
        em.renderMode = .additive
        em.emitterZPosition = 10
        return em
    }

    private func pwograme_fèmti(emèter: CAEmitterLayer) {
        let ret1: TimeInterval = 2.0
        let ret2: TimeInterval = 2.5

        DispatchQueue.main.asyncAfter(deadline: .now() + ret1) { [weak emèter] in
            guard let em = emèter else { return }
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            em.birthRate = 0
            CATransaction.commit()

            DispatchQueue.main.asyncAfter(deadline: .now() + ret2) {
                em.removeFromSuperlayer()
            }
        }
    }

    func rete() {
        for em in koleksyon_emèter {
            em.birthRate = 0
            em.removeFromSuperlayer()
        }
        koleksyon_emèter.removeAll()
    }
}
