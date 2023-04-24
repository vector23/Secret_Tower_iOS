//
//  Enemies.swift
//  Rytier
//
//  Created by Juraj Kebis on 20/08/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class Kostlivec: SKSpriteNode {
    var walkFrames: [SKTexture] = []
    var distance:Int=170
    var duration:Double=3.0
    var minus30:Bool?
    let atlas=SKTextureAtlas(named: "Kost")
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, distance:Int?,duration:Double?,minus30:Bool?) {
        self.minus30=minus30
        super.init(texture: texture, color: .white, size: CGSize(width: 30, height: 30))
        if (distance != nil) {self.distance = distance!}
        if (duration != nil) {self.duration = duration!}
        //self.position=CGPoint(x: 0, y: 0)
        if minus30==true {
            self.position=CGPoint(x: -30, y: 0)
        } else if minus30==false {
            self.position=CGPoint(x: 30, y: 0)
        } else {
            self.position=CGPoint(x: 0, y: 0)
        }
        self.size=CGSize(width: 30, height: 30)
        self.texture=atlas.textureNamed("KostStay1")
        self.zPosition=25
        
        walkFrames.append(atlas.textureNamed("KostRun1"))
        walkFrames.append(atlas.textureNamed("KostRun2"))
        walkFrames.append(atlas.textureNamed("KostRun3"))
        walkFrames.append(atlas.textureNamed("KostRun4"))
        walkFrames.append(atlas.textureNamed("KostRun3"))
        walkFrames.append(atlas.textureNamed("KostRun2"))
        
        //move()
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = enemyCategory
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func move2() {
        //self.run(.repeatForever(.playSoundFileNamed("Kostlivec2.m4a", waitForCompletion: true)))
        var distTemp=0
        var durTemp:Double=0.0
        if minus30==true {
            distTemp = (distance/3)*2
            durTemp = (duration/3)*2
        } else if minus30==false {
            distTemp = (distance/3)
            durTemp = duration/3
        } else {
            distTemp = distance/2
            durTemp = duration/2
        }
        let moveStart = SKAction.move(by: CGVector(dx: distTemp, dy: 0), duration: durTemp)  //distance/2
        let moveLeft=SKAction.move(by: CGVector(dx: -distance, dy: 0), duration: duration)
        let moveRight=SKAction.move(by: CGVector(dx: distance, dy: 0), duration: duration)
        let scalX=SKAction.scaleX(to: 1, duration: 0.0)
        let scalX2=SKAction.scaleX(to: -1, duration: 0.0)
        let seq=SKAction.sequence([moveLeft,scalX,moveRight,scalX2])
        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: walkFrames,
                         timePerFrame: 0.12,
                         resize: false,
                         restore: true)),
        withKey:"walkingInPlaceBear")
        self.run(moveStart, completion: {
            self.xScale = -1
            self.run(SKAction.repeatForever(seq))
        })
 
    }
    
    func move() {
        //self.run(.repeatForever(.playSoundFileNamed("Kostlivec2.m4a", waitForCompletion: true)))
        let moveStart = SKAction.move(by: CGVector(dx: distance/2, dy: 0), duration: duration/2)
        let moveLeft=SKAction.move(by: CGVector(dx: -distance, dy: 0), duration: duration)
        let moveRight=SKAction.move(by: CGVector(dx: distance, dy: 0), duration: duration)
        let scalX=SKAction.scaleX(to: 1, duration: 0.0)
        let scalX2=SKAction.scaleX(to: -1, duration: 0.0)
        let seq=SKAction.sequence([moveLeft,scalX,moveRight,scalX2])
        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: walkFrames,
                         timePerFrame: 0.12,
                         resize: false,
                         restore: true)),
        withKey:"walkingInPlaceBear")
        self.run(moveStart, completion: {
            self.xScale = -1
            self.run(SKAction.repeatForever(seq))
        })
    }
}

class Carodejnik: SKSpriteNode {
    var strong:Bool
    var tictoc:Int=0
    var strela:SKSpriteNode
    var walkFrames: [SKTexture] = []
    let atlas = SKTextureAtlas(named: "Carodej")
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, strong:Bool) {
        self.strela = SKSpriteNode(color: UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1), size: CGSize(width: 6, height: 6))
        self.strong=strong
        self.strela.texture=atlas.textureNamed("Zbran2")
        super.init(texture: texture, color: .black, size: CGSize(width: 22, height: 46))
        self.position=CGPoint(x: 0, y: 0)
        self.size=CGSize(width: 22, height: 46)
        self.texture=atlas.textureNamed(strong ? "Caro1" : "Carodej1")
        self.zPosition=25
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = enemyCategory
        
        if strong {
            walkFrames.append(atlas.textureNamed("Caro1"))
            walkFrames.append(atlas.textureNamed("Caro2"))
            walkFrames.append(atlas.textureNamed("Caro3"))
        } else {
            walkFrames.append(atlas.textureNamed("Carodej1"))
            walkFrames.append(atlas.textureNamed("Carodej2"))
            walkFrames.append(atlas.textureNamed("Carodej3"))
        }
        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: walkFrames,
                         timePerFrame: 0.3,
                         resize: false,
                         restore: true)),
        withKey:"walkingInPlceBear")
        
        strielat()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func strielat() {
        let group = DispatchGroup()
        group.enter()
        
        self.strela.position=CGPoint(x: 0, y: 0)
        self.strela.physicsBody = SKPhysicsBody(rectangleOf: self.strela.size)
        self.strela.physicsBody?.affectedByGravity = false
        self.strela.physicsBody?.isDynamic = false
        //self.strela.physicsBody?.categoryBitMask = enemyCategory
        self.strela.physicsBody?.categoryBitMask = deathCategory
        self.addChild(strela)
        
        let strielat=SKAction.moveBy(x: 200, y: 0, duration: 0.8)   //0.5
        let pockat=SKAction.wait(forDuration: 1.5)
        let pockat1=SKAction.wait(forDuration: 1.2)
        let pockat2=SKAction.wait(forDuration: 0.5)
        
        if self.strong {
            self.strela.run(strielat, completion: {
                self.strela.removeFromParent()
                self.run(self.tictoc==1 ? pockat2 : pockat1, completion: {
                    DispatchQueue.main.async {
                        if self.tictoc==1 {self.tictoc=0}else{self.tictoc=1}
                        group.leave()
                    }
                })
            })
        } else {
            self.strela.run(strielat, completion: {
                self.strela.removeFromParent()
                self.run(pockat, completion: {
                    DispatchQueue.main.async {
                        group.leave()
                    }
                })
            })
        }
        group.notify(queue: .main) {
            self.strielat()
        }
    }
}

class Hlava:SKSpriteNode {
    var walkFrames: [SKTexture] = []
    var distance:Int=180
    var duration:Double=6.0
    var minus30:Bool?
    let atlas=SKTextureAtlas(named: "Hlava")
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?,distance:Int?,duration:Double?,minus30:Bool?) {
        self.minus30=minus30
        super.init(texture: texture, color: .white, size: CGSize(width: 22, height: 26))
        if (distance != nil) {self.distance=distance!}
        if (duration != nil) {self.duration=duration!}
        if minus30==true {
            self.position=CGPoint(x: -30, y: 0)
        } else if minus30==false {
            self.position=CGPoint(x: 30, y: 0)
        } else {
            self.position=CGPoint(x: 0, y: 0)
        }
        //self.position=CGPoint(x: 0, y: 0)
        self.size=CGSize(width: 22, height: 26)
        self.texture=atlas.textureNamed("Hlava3")
        self.zPosition=25
        
        walkFrames.append(atlas.textureNamed("Hlava1"))
        walkFrames.append(atlas.textureNamed("Hlava2"))
        walkFrames.append(atlas.textureNamed("Hlava3"))
        walkFrames.append(atlas.textureNamed("Hlava2"))
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        //self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = deathCategory
        
        //move()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func move() {
        var distTemp=0
        var durTemp:Double=0.0
        if minus30==true {
            distTemp = (distance/3)*2
            durTemp = (duration/3)*2
        } else if minus30==false {
            distTemp = (distance/3)
            durTemp = duration/3
        } else {
            distTemp = distance/2
            durTemp = duration/2
        }
        let moveStart = SKAction.move(by: CGVector(dx: distTemp, dy: 0), duration: durTemp)  //distance/2
        let moveLeft=SKAction.move(by: CGVector(dx: -distance, dy: 0), duration: duration)
        let moveRight=SKAction.move(by: CGVector(dx: distance, dy: 0), duration: duration)
        let scalX=SKAction.scaleX(to: 1, duration: 0.0)
        let scalX2=SKAction.scaleX(to: -1, duration: 0.0)
        let seq=SKAction.sequence([moveLeft,scalX,moveRight,scalX2])
        
        self.run(SKAction.repeatForever(
        SKAction.animate(with: walkFrames,
                         timePerFrame: 0.2,
                         resize: false,
                         restore: true)),
        withKey:"walkingInPlaceBear")
        self.run(moveStart, completion: {
            self.xScale = -1
            self.run(SKAction.repeatForever(seq))
        })
 
    }
}

class Boss: SKSpriteNode {
    var hlava:SKSpriteNode?
    var nohy:SKSpriteNode?
    var life:Int=2
    var typ:Int
    var siz:CGSize
    var stayFrames: [SKTexture] = []
    var neviditelny:Bool=false
    var killedPlayer:Bool=false
    var atlas=SKTextureAtlas(named: "Boss")
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?, typ:Int) {
        self.typ=typ
        atlas=SKTextureAtlas(named: "Boss\(typ)")
        switch typ {
        case 1:
            siz=CGSize(width: 22, height: 44)
        case 2:
            siz=CGSize(width: 32, height: 30)
        case 3:
            siz=CGSize(width: 20, height: 46)
        case 4:
            siz=CGSize(width: 18, height: 26)
        case 5:
            siz=CGSize(width: 30, height: 46)
        case 6:
            siz=CGSize(width: 22, height: 38)
        case 7:
            siz=CGSize(width: 22, height: 46)
        default:
            siz=CGSize(width: 22, height: 44)
        }
        super.init(texture: texture, color: .black, size: CGSize(width: 22, height: 46))
        self.position=CGPoint(x: 0, y: 0)
        self.size=siz
        if typ == 2 {
            self.texture=atlas.textureNamed("BossTelo")
        } else {
            self.texture=atlas.textureNamed("Boss\(self.typ).1")
        }
        self.zPosition=25
        self.xScale = -1
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = bossCategory
        
        if typ != 2 {
            stayFrames.append(atlas.textureNamed("Boss\(self.typ).1"))
            stayFrames.append(atlas.textureNamed("Boss\(self.typ).2"))  //nefunguje
            self.run(SKAction.repeatForever(
            SKAction.animate(with: stayFrames,
                             timePerFrame: 0.6,
                             resize: false,
                             restore: true)),
            withKey:"bossStayFrames")
        } else {
            hlava=SKSpriteNode(texture: atlas.textureNamed("Hlava"))
            hlava?.size=CGSize(width: 12, height: 12)
            self.addChild(hlava!)
            self.hlava?.position.y += 14
            self.hlava?.position.x -= 0 //2
            self.hlava?.zPosition=26
            nohy=SKSpriteNode(texture: atlas.textureNamed("BossNohy"))
            self.addChild(nohy!)
            self.nohy?.position.y -= 14
            self.nohy?.zPosition=26
            let movup=SKAction.moveBy(x: 0, y: 2, duration: 0)
            let movedow=SKAction.moveBy(x: 0, y: -2, duration: 0)
            let wai=SKAction.wait(forDuration: 0.6)
            let seqq=SKAction.repeatForever(.sequence([movup,wai,movedow,wai]))
            self.hlava?.run(seqq)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func hitted() {
        self.run(.animate(with: [atlas.textureNamed("Boss\(typ)Krv")], timePerFrame: 0.4),withKey: "AnimateBossDeath")
        if self.typ == 2 {
            self.run(.wait(forDuration: 0.4),completion: {
                self.run(.animate(with: [self.atlas.textureNamed("BossTelo")], timePerFrame: 1))
            })
        }
    }
    
    func jumpEasy(fromRight:Bool) { //7 sec
        //----first from plosina--startLittleUp, startmoveSide
        //----full down -- fullDown
        //----full right -- fullRight
        //----full left -- fullLeft
        //----hlaf up -- halfUp
        //----half down -- halfDown
        //----localthings -- local
        self.nohy!.run(.moveBy(x: 0, y: -4, duration: 0.1))
        let startLittleUp=SKAction.moveBy(x: 0, y: 80, duration: 0.4)
        let startmoveSide=SKAction.moveBy(x: fromRight ? 84 : -84, y: 0, duration: 0.6)
        let fullDown=SKAction.moveBy(x: 0, y: -304, duration: 1.1)
        let localNohySchovat=SKAction.moveBy(x: 0, y: 8, duration: 0)
        let localHlavaSchovat=SKAction.moveBy(x: 0, y: -8, duration: 0)
        let x = fromRight ? (3.14/2)*12 : -(3.14/2)*12
        let rotate=SKAction.rotate(byAngle: CGFloat(x), duration: 2)
        let movesid=SKAction.moveBy(x: fromRight ? -168 : 168, y: 0, duration: 0.7)
        let halfUp=SKAction.moveBy(x: 0, y: 120, duration: 0.6)
        let halfDown=SKAction.moveBy(x: 0, y: -120, duration: 0.6)
        let localNohyUkaz=SKAction.moveBy(x: 0, y: -8, duration: 0)
        let localHlavaUkaz=SKAction.moveBy(x: 0, y: 8, duration: 0)
        let finishUp=SKAction.moveBy(x: 0, y: 40, duration: 0.4)
        let finishDown=SKAction.moveBy(x: 0, y: -40, duration: 0.4)
        //movesid.timingMode = .easeIn
        halfUp.timingMode = .easeOut
        halfDown.timingMode = .easeIn
        fullDown.timingMode = .easeIn
        startLittleUp.timingMode = .easeOut
        finishUp.timingMode = .easeOut
        finishDown.timingMode = .easeIn
        self.run(startmoveSide)
        self.run(startLittleUp,completion: {
            if !self.killedPlayer {
                self.nohy?.run(localNohySchovat)
                self.hlava?.run(localHlavaSchovat)
                self.run(fullDown,withKey: "fullDown")
                self.run(rotate)
                self.run(.wait(forDuration: 1.0),completion: {
                    if !self.killedPlayer {
                        self.run(movesid,completion: {
                            if !self.killedPlayer {
                                self.nohy?.run(localNohyUkaz)
                                self.hlava?.run(localHlavaUkaz)
                                self.run(finishUp,completion: {
                                    if !self.killedPlayer {
                                        self.run(finishDown,completion: {
                                            self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                            self.killedPlayer=false
                                        })
                                    } else {
                                        self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                        self.killedPlayer=false
                                    }
                                })
                            } else {
                                self.nohy?.run(localNohyUkaz)
                                self.hlava?.run(localHlavaUkaz)
                                self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                self.killedPlayer=false
                            }
                        })
                    } else {
                        self.nohy?.run(localNohyUkaz)
                        self.hlava?.run(localHlavaUkaz)
                        self.removeAction(forKey: "fullDown")
                        self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                        self.killedPlayer=false
                    }
                    
                })
            } else {
                self.nohy?.run(localNohyUkaz)
                self.hlava?.run(localHlavaUkaz)
                self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                self.killedPlayer=false
            }
        })
        
    }
    
    func jumpHard(fromRight:Bool) {
        self.nohy!.run(.moveBy(x: 0, y: -4, duration: 0.1))
        let startLittleUp=SKAction.moveBy(x: 0, y: 80, duration: 0.4)
        let startmoveSide=SKAction.moveBy(x: fromRight ? 84 : -84, y: 0, duration: 0.6)
        let fullDown=SKAction.moveBy(x: 0, y: -304, duration: 1.1)
        let localNohySchovat=SKAction.moveBy(x: 0, y: 8, duration: 0)
        let localHlavaSchovat=SKAction.moveBy(x: 0, y: -8, duration: 0)
        let x = fromRight ? (3.14/2)*12 : -(3.14/2)*12
        let y = !fromRight ? (3.14/2)*12 : -(3.14/2)*12
        let rotate=SKAction.rotate(byAngle: CGFloat(x), duration: 2)
        let rotateOpak=SKAction.rotate(byAngle: CGFloat(y), duration: 2)
        let movesid=SKAction.moveBy(x: fromRight ? -168 : 168, y: 0, duration: 0.7)
        let moveSidOpak=SKAction.moveBy(x: !fromRight ? -168 : 168, y: 0, duration: 0.7)
        let halfUp=SKAction.moveBy(x: 0, y: 140, duration: 0.6)
        let halfDown=SKAction.moveBy(x: 0, y: -140, duration: 0.6)
        let localNohyUkaz=SKAction.moveBy(x: 0, y: -8, duration: 0)
        let localHlavaUkaz=SKAction.moveBy(x: 0, y: 8, duration: 0)
        let finishUp=SKAction.moveBy(x: 0, y: 40, duration: 0.4)
        let finishDown=SKAction.moveBy(x: 0, y: -40, duration: 0.4)
        //movesid.timingMode = .easeIn
        //moveSidOpak.timingMode = .easeIn
        halfUp.timingMode = .easeOut
        halfDown.timingMode = .easeIn
        finishUp.timingMode = .easeOut
        fullDown.timingMode = .easeIn
        finishDown.timingMode = .easeIn
        startLittleUp.timingMode = .easeOut
        self.run(startmoveSide)
        self.run(startLittleUp,completion: {
            if !self.killedPlayer {
                self.nohy?.run(localNohySchovat)
                self.hlava?.run(localHlavaSchovat)
                self.run(fullDown,withKey: "fullDown")
                self.run(rotate)
                self.run(.wait(forDuration: 1.0),completion: {
                    if !self.killedPlayer {
                        self.run(movesid,withKey: "moveSid")
                        self.run(.wait(forDuration: 0.6),completion:{
                            if !self.killedPlayer {
                                self.run(halfUp,completion:{
                                    if !self.killedPlayer {
                                        self.run(rotateOpak)
                                        self.run(halfDown,withKey: "halfDown")
                                        self.run(.wait(forDuration: 0.5),completion:{
                                            if !self.killedPlayer {
                                                self.run(moveSidOpak,completion: {
                                                    if !self.killedPlayer {
                                                        self.run(finishUp,completion: {
                                                            if !self.killedPlayer {
                                                                self.run(finishDown,completion: {
                                                                    if !self.killedPlayer {
                                                                        self.nohy?.run(localNohyUkaz)
                                                                        self.hlava?.run(localHlavaUkaz)
                                                                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                                                        self.run(.wait(forDuration: 3.5),completion:{
                                                                        })
                                                                    } else {
                                                                        self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                                                        self.nohy?.run(localNohyUkaz)
                                                                        self.hlava?.run(localHlavaUkaz)
                                                                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                                                        self.killedPlayer=false
                                                                    }
                                                                })
                                                            } else {
                                                                self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                                                self.nohy?.run(localNohyUkaz)
                                                                self.hlava?.run(localHlavaUkaz)
                                                                self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                                                self.killedPlayer=false
                                                            }
                                                        })
                                                    } else {
                                                        self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                                        self.nohy?.run(localNohyUkaz)
                                                        self.hlava?.run(localHlavaUkaz)
                                                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                                        self.killedPlayer=false
                                                    }
                                                })
                                            } else {
                                                self.removeAction(forKey: "halfDown")
                                                self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                                self.nohy?.run(localNohyUkaz)
                                                self.hlava?.run(localHlavaUkaz)
                                                self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                                self.killedPlayer=false
                                            }
                                        })
                                    } else {
                                        self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                        self.nohy?.run(localNohyUkaz)
                                        self.hlava?.run(localHlavaUkaz)
                                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                        self.killedPlayer=false
                                    }
                                })
                            } else {
                                self.removeAction(forKey: "moveSid")
                                self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                                self.nohy?.run(localNohyUkaz)
                                self.hlava?.run(localHlavaUkaz)
                                self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                                self.killedPlayer=false
                            }
                        })
                    } else {
                        self.removeAction(forKey: "fullDown")
                        self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                        self.nohy?.run(localNohyUkaz)
                        self.hlava?.run(localHlavaUkaz)
                        self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                        self.killedPlayer=false
                    }
                })
            } else {
                self.run(.move(to: CGPoint(x: 0, y: 240), duration: 0))
                self.nohy?.run(localNohyUkaz)
                self.hlava?.run(localHlavaUkaz)
                self.nohy!.run(.moveBy(x: 0, y: 4, duration: 0.1))
                self.killedPlayer=false
            }
        })
        
    }
    func jumpBack() {
        let moveUp=SKAction.moveBy(x: 0, y: 224, duration: 1)
        moveUp.timingMode = .easeOut
        let moveSide=SKAction.moveTo(x: 0, duration: 1)
        self.run(moveUp)
        self.run(moveSide)
    }
    
}
