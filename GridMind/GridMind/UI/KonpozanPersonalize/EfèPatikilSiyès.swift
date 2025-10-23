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

    static let defaut: [KonfigiraskonPatikil] = [
        .init(koulè: .init(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), vitès: 100, dire: 2.0, echèl: 0.5),
        .init(koulè: .init(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0), vitès: 120, dire: 2.5, echèl: 0.6),
        .init(koulè: .init(red: 0.4, green: 0.8, blue: 1.0, alpha: 1.0), vitès: 110, dire: 1.8, echèl: 0.55)
    ]
}

// MARK: - Particle Cell Factory Protocol

fileprivate protocol FactorySelilPatikil {
    func kreeSelil(ak konfig: KonfigiraskonPatikil, imaj: UIImage) -> CAEmitterCell
}

fileprivate struct FactorySelilStandard: FactorySelilPatikil {
    func kreeSelil(ak konfig: KonfigiraskonPatikil, imaj: UIImage) -> CAEmitterCell {
        let selil = CAEmitterCell()
        selil.birthRate = 20.0
        selil.lifetime = 2.0
        selil.lifetimeRange = 0.5
        selil.velocity = konfig.vitès
        selil.velocityRange = 50.0
        selil.emissionRange = .pi * 2
        selil.spin = konfig.dire
        selil.spinRange = 3.0
        selil.scaleRange = konfig.echèl
        selil.scaleSpeed = -0.1
        selil.contents = imaj.cgImage
        selil.color = konfig.koulè.cgColor
        return selil
    }
}

// MARK: - Shape Generator Protocol

fileprivate protocol JeneratèFòm {
    func kreeImaj(ak koulè: UIColor, gwosè: CGFloat) -> UIImage
}

fileprivate struct JeneratèEtwal: JeneratèFòm {
    func kreeImaj(ak koulè: UIColor, gwosè: CGFloat) -> UIImage {
        let rektang = CGRect(origin: .zero, size: .init(width: gwosè, height: gwosè))
        UIGraphicsBeginImageContextWithOptions(rektang.size, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return UIImage() }

        ctx.setFillColor(koulè.cgColor)
        desineEtwal(nan: ctx, santè: .init(x: gwosè / 2, y: gwosè / 2), rayon: gwosè / 2)

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

    private func desineEtwal(nan ctx: CGContext, santè: CGPoint, rayon: CGFloat) {
        var eksterye: [CGPoint] = []
        var entèn: [CGPoint] = []

        for i in 0..<5 {
            let ang = CGFloat(i) * .pi * 2 / 5 - .pi / 2
            eksterye.append(.init(x: santè.x + rayon * cos(ang), y: santè.y + rayon * sin(ang)))
        }

        for i in 0..<5 {
            let ang = CGFloat(i) * .pi * 2 / 5 - .pi / 2 + .pi / 5
            entèn.append(.init(x: santè.x + rayon * 0.4 * cos(ang), y: santè.y + rayon * 0.4 * sin(ang)))
        }

        ctx.beginPath()
        for i in 0..<5 {
            if i == 0 { ctx.move(to: eksterye[i]) }
            else { ctx.addLine(to: eksterye[i]) }
            ctx.addLine(to: entèn[i])
        }
        ctx.closePath()
        ctx.fillPath()
    }
}

// MARK: - Particle Effect View

class EfèPatikilSiyès: UIView {

    private var emèterPatikil: CAEmitterLayer?
    private let factorySelil: FactorySelilPatikil = FactorySelilStandard()
    private let jeneratèFòm: JeneratèFòm = JeneratèEtwal()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func kòmanseEfèSiyès(nan pozisyon: CGPoint) {
        let emèter = kreeEmèter(pozisyon: pozisyon)
        let selils = KonfigiraskonPatikil.defaut.map { konfig in
            let imaj = jeneratèFòm.kreeImaj(ak: konfig.koulè, gwosè: 20)
            return factorySelil.kreeSelil(ak: konfig, imaj: imaj)
        }

        emèter.emitterCells = selils
        layer.addSublayer(emèter)
        self.emèterPatikil = emèter

        programeArete(emèter)
    }

    func kòmanseEfèSelebrasyon() {
        let dimansyon = (lajè: bounds.width, otè: bounds.height)
        let pozisyons = (0..<5).map { _ in
            CGPoint(
                x: .random(in: dimansyon.lajè * 0.2...dimansyon.lajè * 0.8),
                y: .random(in: dimansyon.otè * 0.3...dimansyon.otè * 0.7)
            )
        }
        pozisyons.forEach { kòmanseEfèSiyès(nan: $0) }
    }

    private func kreeEmèter(pozisyon: CGPoint) -> CAEmitterLayer {
        let emèter = CAEmitterLayer()
        emèter.emitterPosition = pozisyon
        emèter.emitterShape = .circle
        emèter.emitterSize = CGSize(width: 10, height: 10)
        emèter.renderMode = .additive
        return emèter
    }

    private func programeArete(_ emèter: CAEmitterLayer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak emèter] in
            emèter?.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                emèter?.removeFromSuperlayer()
            }
        }
    }

    func rete() {
        [emèterPatikil].compactMap { $0 }.forEach {
            $0.birthRate = 0
            $0.removeFromSuperlayer()
        }
        emèterPatikil = nil
    }
}
