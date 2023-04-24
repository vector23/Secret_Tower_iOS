//
//  Objects.swift
//  Rytier
//
//  Created by Juraj Kebis on 17/03/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Fakla:SKSpriteNode {
    var movement: [SKTexture] = []
    let atlas=SKTextureAtlas(named: "Fakla")
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.position=CGPoint(x: 0, y: 0)
        self.texture=atlas.textureNamed("Fakla1")
        self.size=CGSize(width: 12, height: 20)
        self.zPosition=21
        
        movement.append(atlas.textureNamed("Fakla1"))    //f1,f2,f3
        movement.append(atlas.textureNamed("Fakla2"))
        movement.append(atlas.textureNamed("Fakla3"))
        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: movement,
                         timePerFrame: 0.5,
                         resize: false,
                         restore: true)),
        withKey:"faklin")
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Okno:SKSpriteNode {
    var typco:Okna
    let atlas=SKTextureAtlas(named: "Okno")
    //var atlasis:SKTextureAtlas
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, typ:Okna) {
        typco=typ
        //atlasis=SKTextureAtlas(named: "Okna")
        super.init(texture: texture, color: .white, size: CGSize(width: 10, height: 10))
        self.position=CGPoint(x: 0, y: 0)
        switch typ {
        case .normal:
            self.size=CGSize(width: 10, height: 24)
            self.texture=atlas.textureNamed("Okno")
        case .svetle:
            self.size=CGSize(width: 18, height: 32)
            self.texture=atlas.textureNamed("OknoS")
        case .tmave:
            self.size=CGSize(width: 18, height: 32)
            self.texture=atlas.textureNamed("OknoD")
        }
        
        self.zPosition=21
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Dvere:SKSpriteNode {  //Nerozumiem co to tu robi
    let atlas=SKTextureAtlas(named: "KlenbaCele")
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.position=CGPoint(x: 0, y: 0)
        self.size=CGSize(width: 45, height: 200)
        self.texture=atlas.textureNamed("Dvere1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class Sekera:SKNode {
    var zaklad:SKSpriteNode
    var seker:SKSpriteNode
    var big:Bool=false
    let atlas=SKTextureAtlas(named: "Sekera")
    
    init(big:Bool) {
        zaklad=SKSpriteNode(texture: atlas.textureNamed("SekeraZaklad"))
        seker=SKSpriteNode(texture: atlas.textureNamed(big ? "Sekera2" : "Sekera1"))//oprava
        super.init()
        zaklad.size=CGSize(width: 18, height: 6)
        seker.size=CGSize(width: 26, height: 128)
        self.addChild(zaklad)
        self.addChild(seker)
        self.zaklad.position=CGPoint(x: 0, y: 0)
        //self.seker.anchorPoint=CGPoint(x: 0.5, y: 1.0)
        self.seker.position=CGPoint(x: 0, y: 0)
        self.zaklad.zPosition=27
        self.seker.zPosition=26
        
        self.run(.wait(forDuration: 0.6),completion: {
            self.setPhysic(on: true)
        })
        rotate(big:big)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPhysic(on:Bool) {
        if on {
            self.seker.physicsBody = SKPhysicsBody(texture: atlas.textureNamed(big ? "Sekera2" : "Sekera1"), size: self.seker.size)
            self.seker.physicsBody?.affectedByGravity = false
            self.seker.physicsBody?.isDynamic = false
            self.seker.physicsBody?.categoryBitMask = enemyCategory
        } else {
            self.physicsBody=nil
        }
        
    }
    func rotate(big:Bool){
        if big {
            let start:SKAction = .rotate(byAngle: (3.14/2), duration: 0.5)
            let rotateLeft:SKAction = .rotate(byAngle: -(3.14), duration: 1.2)
            rotateLeft.timingMode = .easeInEaseOut
            let rotateRight:SKAction = .rotate(byAngle: (3.14), duration: 1.2)
            rotateRight.timingMode = .easeInEaseOut
            let wait:SKAction = .wait(forDuration: 0.2)
            let seq1:SKAction = .repeatForever(.sequence([rotateLeft,wait,rotateRight,wait]))
            let seq2:SKAction = .sequence([start,seq1])
            self.run(.wait(forDuration: 0.7),completion: {
                self.run(.repeatForever(.playSoundFileNamed("Sekera2.m4a", waitForCompletion: true)))
            })
            self.seker.run(seq2)
        } else {

            let start:SKAction = .rotate(byAngle: (3.14/2), duration: 0.5)
            let rotateLeft:SKAction = .rotate(byAngle: -(3.14), duration: 1.3)
            rotateLeft.timingMode = .easeInEaseOut
            let rotateRight:SKAction = .rotate(byAngle: (3.14), duration: 1.3)
            rotateRight.timingMode = .easeInEaseOut
            let wait:SKAction = .wait(forDuration: 0.8)
            let seq1:SKAction = .repeatForever(.sequence([rotateLeft,wait,rotateRight,wait]))
            let seq2:SKAction = .sequence([start,seq1])
            self.seker.run(seq2)
            self.run(.wait(forDuration: 0.8),completion: {
                self.run(.repeatForever(.playSoundFileNamed("SekeraSmall.m4a", waitForCompletion: true)))
            })
        }
    }
}
    
class SekeraB:SKNode {
    var zaklad:SKSpriteNode
    var seker:SKSpriteNode
    let atlas=SKTextureAtlas(named: "Sekera")
    override init() {
        zaklad=SKSpriteNode(texture: atlas.textureNamed("SekeraZaklad"))
        seker=SKSpriteNode(texture: atlas.textureNamed("Sekera2"))//oprava
        super.init()
        zaklad.size=CGSize(width: 18, height: 6)
        seker.size=CGSize(width: 26, height: 128)
        self.addChild(zaklad)
        self.addChild(seker)
        self.zaklad.position=CGPoint(x: 0, y: 0)
        //self.seker.anchorPoint=CGPoint(x: 0.5, y: 1.0)
        self.seker.position=CGPoint(x: 0, y: 0)
        self.zaklad.zPosition=27
        self.seker.zPosition=26
        
        //self.seker.physicsBody = SKPhysicsBody(rectangleOf:self.seker.size)
        self.seker.physicsBody = SKPhysicsBody(texture: atlas.textureNamed("Sekera2"), size: self.seker.size)
        self.seker.physicsBody?.affectedByGravity = false
        self.seker.physicsBody?.isDynamic = false
        self.seker.physicsBody?.categoryBitMask = enemyCategory
        rotate()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPhysic(on:Bool) {
        if on {
            self.seker.physicsBody = SKPhysicsBody(texture: atlas.textureNamed("Sekera2"), size: self.seker.size)
            self.seker.physicsBody?.affectedByGravity = false
            self.seker.physicsBody?.isDynamic = false
            self.seker.physicsBody?.categoryBitMask = enemyCategory
        } else {
            self.physicsBody=nil
        }
        
    }
    func rotate(){
        let start:SKAction = .rotate(byAngle: (3.14/2), duration: 0.5)
        let rotateLeft:SKAction = .rotate(byAngle: -(3.14), duration: 1.2)
        rotateLeft.timingMode = .easeInEaseOut
        let rotateRight:SKAction = .rotate(byAngle: (3.14), duration: 1.2)
        rotateRight.timingMode = .easeInEaseOut
        let wait:SKAction = .wait(forDuration: 0.2)
        let seq1:SKAction = .repeatForever(.sequence([rotateLeft,wait,rotateRight,wait]))
        let seq2:SKAction = .sequence([start,seq1])
        self.seker.run(seq2)
    }
}

class Pasca:SKSpriteNode {
    var frames:[SKTexture] = []
    var frames2:[SKTexture] = []
    let atlas=SKTextureAtlas(named: "Pichliace")
    var picha:Bool=false
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.position=CGPoint(x: 0, y: 0)
        self.size=CGSize(width: 30, height: 12)
        self.texture=atlas.textureNamed("Pich1")
        self.zPosition=24
        
        frames.append(atlas.textureNamed("Pich1"))
        frames2.append(atlas.textureNamed("Pich2"))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 26, height: 10))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = pichliaceOhenCategory
        initPich()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPich() {
        let group = DispatchGroup()
        group.enter()
        picha=false
        self.run(SKAction.animate(with: frames2,
        timePerFrame: 2,
        resize: false,
        restore: true),completion: {
            DispatchQueue.main.async {
                group.leave()
            }
        })
        group.notify(queue: .main) {
            self.pichat()
        }
    }
    func pichat() {
        let group = DispatchGroup()
        group.enter()
        picha=true
        self.run(SKAction.animate(with: frames,
                         timePerFrame: 2,
                         resize: false,
                         restore: true),completion: {
                            DispatchQueue.main.async {
                                group.leave()
                            }
        })
        group.notify(queue: .main) {
            self.initPich()
        }
    }
}

class Pokladnica: SKSpriteNode {
    let atlas=SKTextureAtlas(named: "Poklad")
    var otvoreny:Bool=false
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.position=CGPoint(x: 0, y: 0)
        self.size=CGSize(width: 22, height: 26)
        self.texture=atlas.textureNamed("PokladM1")
        self.zPosition=25
        
        self.physicsBody = SKPhysicsBody(rectangleOf: (self.size))
        //self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = pokladCategory
        
    }
    
    func openPoklad() {
        self.run(.playSoundFileNamed("poklad.m4a", waitForCompletion: false))
        self.run(.playSoundFileNamed("minceViac.m4a", waitForCompletion: false))
        otvoreny=true
        self.texture=atlas.textureNamed("PokladM2")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Coin: SKSpriteNode {
    var mincen: [SKTexture] = []
    let atlas=SKTextureAtlas(named: "MincaAnimacia")
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.position=CGPoint(x: 0, y: 0)
        self.size=CGSize(width: 24, height: 28)
        self.texture=atlas.textureNamed("M1")
        self.zPosition = 30
        
        self.physicsBody = SKPhysicsBody(rectangleOf: (self.size))
        //self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = coinCategory
        
        mincen.append(atlas.textureNamed("M1"))
        mincen.append(atlas.textureNamed("M2"))
        mincen.append(atlas.textureNamed("M3"))
        mincen.append(atlas.textureNamed("M4"))
        mincen.append(atlas.textureNamed("M5"))
        mincen.append(atlas.textureNamed("M6"))
        mincen.append(atlas.textureNamed("M7"))

        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: mincen,
                         timePerFrame: 0.07,
                         resize: false,
                         restore: true)),
        withKey:"mincaMove")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Ohen: SKSpriteNode {
    var ohenStatic: [SKTexture] = []
    var plamen: [SKTexture] = []
    var rot:CGFloat
    let atlas=SKTextureAtlas(named: "Plamenomet")
    var striela:Bool=false
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, rotate:CGFloat) {
        self.rot=rotate
        super.init(texture:atlas.textureNamed("P1"), color: .white, size: CGSize(width: 12, height: 68))
        
        self.position=CGPoint(x: 0, y: 0)
        //self.size=CGSize(width: 12, height: 68)
        self.texture=atlas.textureNamed("P1")
        self.zPosition = 30
        self.zRotation = rotate
        
        self.physicsBody = SKPhysicsBody(rectangleOf: (self.size))
        //self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 0
        
        ohenStatic.append(atlas.textureNamed("P2"))
        ohenStatic.append(atlas.textureNamed("P3"))
        ohenStatic.append(atlas.textureNamed("P4"))
        plamen.append(atlas.textureNamed("P7"))
        plamen.append(atlas.textureNamed("P8"))
        plamen.append(atlas.textureNamed("P9"))
        
        self.physicsBody?.categoryBitMask = pichliaceOhenCategory
        
        //normalOhen()
        
    }
    func normalOhen() {
        let group = DispatchGroup()
        group.enter()
        //striela=false
        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: ohenStatic,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: false)),
        withKey:"ohenFire")
        let pockat=SKAction.wait(forDuration: 2.0)
        self.run(pockat,completion: {
            self.removeAction(forKey: "ohenFire")
            self.run(.animate(with: [self.atlas.textureNamed("P5"),SKTexture(imageNamed: "P6")], timePerFrame: 0.1),completion: {
                DispatchQueue.main.async {
                    group.leave()
                }
            })
        })
        group.notify(queue: .main) {
            self.strielat()
        }
    }
    
    func strielat() {
        let group = DispatchGroup()
        group.enter()
        striela=true
        self.run(SKAction.repeatForever(SKAction.animate(with: plamen,
                         timePerFrame: 0.1,
                         resize: false,
                         restore: false)),
                 withKey:"ohenStrielat")
        let pockat=SKAction.wait(forDuration: 1.5)
        self.run(pockat,completion: {
            self.removeAction(forKey: "ohenStrielat")
            self.striela=false
            self.run(.animate(with: [self.atlas.textureNamed("P6"),self.atlas.textureNamed("P5")], timePerFrame: 0.1),completion: {
                DispatchQueue.main.async {
                    group.leave()
                }
            })
        })
        group.notify(queue: .main) {
            self.normalOhen()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Kamen: SKSpriteNode {
    let atlas=SKTextureAtlas(named: "BossStenaIne")
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, poX:Int) {
        super.init(texture: atlas.textureNamed("Gula"), color: .white, size: CGSize(width: 16, height: 16))
    
        self.position=CGPoint(x: poX + 0, y: 500)
        //self.size=CGSize(width: 12, height: 68)
        self.texture=atlas.textureNamed("Gula")
        self.zPosition = 34
    
        self.physicsBody = SKPhysicsBody(rectangleOf: (self.size))
        //self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = deathCategory
        
    }
    func padat() {
        let move=SKAction.moveBy(x: 0, y: -1000, duration: 2.0) //1.8   1000/2sec
        self.run(move)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SrdceBoss:SKNode {
    var tien:SKSpriteNode
    var svetlo:SKSpriteNode
    var vypln:SKSpriteNode
    var okraj:SKSpriteNode
    let atlas=SKTextureAtlas(named: "BossStenaIne")
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, nic:Bool) {
        tien=SKSpriteNode(texture: atlas.textureNamed("srdceTien"))
        tien.size=CGSize(width: 92, height: 76)
        tien.zPosition = 50
        tien.alpha=0.5
        svetlo=SKSpriteNode(texture: atlas.textureNamed("srdceSvetlo"))
        svetlo.size=CGSize(width: 92, height: 76)
        svetlo.zPosition=52
        svetlo.run(.fadeOut(withDuration: 0))
        vypln=SKSpriteNode(texture: atlas.textureNamed("srdceFull"))
        vypln.size=CGSize(width: 92, height: 76)
        vypln.zPosition=51
        okraj=SKSpriteNode(texture: atlas.textureNamed("srdceOkraj"))
        okraj.size=CGSize(width: 92, height: 76)
        okraj.zPosition=53
        super.init()
        self.addChild(tien)
        self.addChild(vypln)
        self.addChild(svetlo)
        self.addChild(okraj)
        self.position=CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func uberZivot(naJedna:Bool) {
        if naJedna {
            svetlo.run(.fadeIn(withDuration: 0.0),completion: {
                self.vypln.texture=self.atlas.textureNamed("srdcePol")
            })
            svetlo.run(.wait(forDuration: 0.2),completion: {
                self.svetlo.run(.fadeOut(withDuration: 0.1))
            })
        } else {
            svetlo.run(.fadeIn(withDuration: 0.0),completion: {
                self.vypln.isHidden=true
            })
            svetlo.run(.wait(forDuration: 0.2),completion: {
                self.svetlo.run(.fadeOut(withDuration: 0.1))
            })
        }
    }
}
