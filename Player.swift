//
//  Player.swift
//  Rytier
//
//  Created by Juraj Kebis on 18/03/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation



class Player3:SKNode {
    var telo:SKSpriteNode
    var nohy:SKSpriteNode
    var seknutie:SKSpriteNode
    var revive:Bool=false
    var skin:Int=0
    var shortcut:String
    
    var zablokovaneAkcie:Bool=false     //--vsetky akcie zablokovane
    
    var attacking:Bool=false
    var mecNaPoklade:Bool=false
    var mecNaEnemy:Bool=false
    var mecNaBoss:Bool=false
    var doublejumpLeft:Int=2
    
    var otocenyDoLava:Bool=false
    var isInTheAir:Bool=false
    var onRebrik:Bool=false
    var onPlosina:Bool=false    //--zatial tusim nevyuzivam, treba pozriet v gamescene, kvoli rebriku a plosine
    var onGround:Bool=false
    var movingUp:Bool=false
    var goLeftUp:Bool=false
    var movingLeftB:Bool=false      //--ked drzim do lava button
    var movingRightB:Bool=false     //--ked drzim do prava button
    var obidveStranyB:Bool=false    //--ked drzim aj do lava aj do prava tlacidla
    var staleSkace:Bool=false
    var vPoziciSkakania:Int=1   //--1 prva faza, 2 druha, 3 tretia
    
    var walkFrames: [SKTexture] = []    //nohy
    var stayFrames: [SKTexture] = []    //walk frames
    var stayFramesR: [SKTexture] = []   //walk frames
    var sekTeloFrames:[SKTexture] = []
    var sekTeloFramesR:[SKTexture] = []
    var seknutieFrames: [SKTexture] = []
    var teloChill: [SKTexture] = []
    var teloChillR: [SKTexture] = []
    var teloRebrik: [SKTexture] = []
    var teloPohyb:SKAction?
    var teloPohybR:SKAction?
    var teloChillAnim:SKAction?
    var teloChillAnimR:SKAction?
    var attackAnim:SKAction?
    var atlasAttack = SKTextureAtlas(named: "Attack1")
    var atlasDeath = SKTextureAtlas(named: "Death1")
    var atlasNohy = SKTextureAtlas(named: "Nohy1")
    var atlasTelo = SKTextureAtlas(named: "Telo1")
    
    init(texture: SKTexture?, color: UIColor?, size: CGSize?,pos:CGPoint,revive:Bool,skin:Int) {
        
        self.revive=revive
        self.skin=skin
        //print("Rytier--\(UserDefaults.standard.integer(forKey: "PickedSkinAbsolute"))")
        //print(skin)
        atlasAttack = SKTextureAtlas(named: "Attack\(skin)")
        atlasDeath = SKTextureAtlas(named: "Death\(skin)")
        atlasNohy = SKTextureAtlas(named: "Nohy\(skin)")
        atlasTelo = SKTextureAtlas(named: "Telo\(skin)")
        
        switch skin {
        case 1:
            shortcut="r"
        case 2:
            shortcut="y"
        case 3:
            shortcut="g"
        case 4:
            shortcut="b"
        case 5:
            shortcut="s"    //siva
        default:
            shortcut="q"
        }
        telo=SKSpriteNode(texture: atlasTelo.textureNamed("\(shortcut)s1"))
        nohy=SKSpriteNode(texture: atlasNohy.textureNamed("\(shortcut)Stay1"))
        seknutie=SKSpriteNode(texture: atlasAttack.textureNamed("\(shortcut)Sek1"))
        super.init()
        createPlayer(pos: pos)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPlayer(pos:CGPoint) {
        self.addChild(telo)
        self.addChild(nohy)
        self.addChild(seknutie)
        self.telo.texture=atlasTelo.textureNamed("\(shortcut)s3")
        self.telo.size=CGSize(width: 58, height: skin==5 ? 40 : 36)    //32, 34,
        self.nohy.size=CGSize(width: 20, height: 12)
        self.telo.position=CGPoint(x: 0, y: skin==5 ? 6 : 4)
        self.nohy.position=CGPoint(x: 2, y: -18)    //x2
        
        self.position=pos
        //self.telo.size=CGSize(width: 106, height: 137)
        self.zPosition=31
        //self.xScale = -1.0
        
        self.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 24, height: 48))  //w:32 h:48
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity=true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.mass = 0.9   //0.8
        //self.physicsBody?.density=70
        //self.physicsBody?.velocity = CGVector(dx: 3, dy: 0)
        self.physicsBody?.categoryBitMask = playerCategory
        if self.revive {
            self.physicsBody?.contactTestBitMask = coinCategory | doorCategory | wallCategory | plosinaCategory | dverePressCategory
            self.physicsBody!.collisionBitMask = wallCategory | plosinaCategory
        } else {
            self.physicsBody?.contactTestBitMask = coinCategory | doorCategory | enemyCategory | wallCategory | plosinaCategory | deathCategory | bossCategory | dverePressCategory | pichliaceOhenCategory
            self.physicsBody!.collisionBitMask = wallCategory | plosinaCategory | bossCategory
        }
        
        //seknutie=SKSpriteNode(color: UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 1), size: CGSize(width: 42, height: 58))
        seknutie.size=CGSize(width: 42, height: 58)
        seknutie.texture=atlasAttack.textureNamed("\(shortcut)Sek1")
        //self.addChild(seknutie)
        seknutie.position=CGPoint(x: -12, y: 8)
        //seknutie.anchorPoint=CGPoint(x: 0.5, y: 0.2)
        setMecPhysic(revive:revive)
        self.seknutie.isHidden = true
        
        setFrames() //set frames
        
        //self.telo.run(teloPohybR!,withKey:"teloPohyb")  //set animations
        self.telo.run(teloChillAnimR!, withKey: "teloStayR")
        
        self.name="rytier"
        self.seknutie.name="mec"
        self.xScale = -1.0
    }
    func setMecPhysic(revive:Bool) {
        seknutie.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: self.seknutie.size.width, height: self.seknutie.size.height-4))
        self.seknutie.physicsBody?.isDynamic = true
        self.seknutie.physicsBody?.affectedByGravity = false
        //self.seknutie.physicsBody?.usesPreciseCollisionDetection = false
        self.seknutie.physicsBody?.allowsRotation = false
        self.seknutie.physicsBody?.pinned = true
        self.seknutie.physicsBody?.categoryBitMask = mecCategory
        if revive {
            self.seknutie.physicsBody?.contactTestBitMask = enemyCategory | pokladCategory
        } else {
            self.seknutie.physicsBody?.contactTestBitMask = enemyCategory | pokladCategory | bossCategory
        }
        
        self.seknutie.physicsBody?.collisionBitMask = 0
    }
    
    func setFrames() {
        // OTelo1 stare
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w1"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w2"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w3"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w4"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w5"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w6"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w7"))
        stayFrames.append(atlasTelo.textureNamed("\(shortcut)w8"))
        teloPohyb = SKAction.repeatForever(SKAction.animate(with: stayFrames,
                                                            timePerFrame: 0.08,
                         resize: false,
                         restore: true))
        // Telo1 stare
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w9"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w10"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w11"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w12"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w13"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w14"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w15"))
        stayFramesR.append(atlasTelo.textureNamed("\(shortcut)w16"))
        teloPohybR = SKAction.repeatForever(SKAction.animate(with: stayFramesR,
                         timePerFrame: 0.08,
                         resize: false,
                         restore: true))    //0.08
        teloChill.append(atlasTelo.textureNamed( "\(shortcut)s4"))
        teloChill.append(atlasTelo.textureNamed("\(shortcut)s3"))
        teloChill.append(atlasTelo.textureNamed("\(shortcut)s2"))
        teloChill.append(atlasTelo.textureNamed("\(shortcut)s1"))
        teloChillAnim = SKAction.repeatForever(.animate(with: teloChill, timePerFrame: 0.16, resize: false, restore: true))
        teloChillR.append(atlasTelo.textureNamed("\(shortcut)s8"))
        teloChillR.append(atlasTelo.textureNamed("\(shortcut)s7"))
        teloChillR.append(atlasTelo.textureNamed("\(shortcut)s6"))
        teloChillR.append(atlasTelo.textureNamed("\(shortcut)s5"))
        teloChillAnimR = SKAction.repeatForever(.animate(with: teloChillR, timePerFrame: 0.16, resize: false, restore: true))
        
        seknutieFrames.append(atlasAttack.textureNamed("\(shortcut)Sek1"))
        seknutieFrames.append(atlasAttack.textureNamed("\(shortcut)Sek2"))
        seknutieFrames.append(atlasAttack.textureNamed("\(shortcut)Sek3"))
        seknutieFrames.append(atlasAttack.textureNamed("\(shortcut)Sek4"))
        attackAnim = SKAction.animate(with: seknutieFrames,
        timePerFrame: 0.08,
        resize: false,
        restore: true)
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run1"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run2"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run3"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run4"))
        //walkFrames.append(SKTexture(imageNamed: "\(shortcut)Run5"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run6"))
        //walkFrames.append(SKTexture(imageNamed: "\(shortcut)Run7"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run8"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run9"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run10"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run11"))
        walkFrames.append(atlasNohy.textureNamed("\(shortcut)Run12"))
        
        sekTeloFrames.append(atlasTelo.textureNamed("\(shortcut)m1"))
        sekTeloFrames.append(atlasTelo.textureNamed("\(shortcut)m2"))
        sekTeloFrames.append(atlasTelo.textureNamed("\(shortcut)m3"))
        sekTeloFrames.append(atlasTelo.textureNamed("\(shortcut)m3"))
        sekTeloFramesR.append(atlasTelo.textureNamed("\(shortcut)m4"))
        sekTeloFramesR.append(atlasTelo.textureNamed("\(shortcut)m5"))
        sekTeloFramesR.append(atlasTelo.textureNamed("\(shortcut)m6"))
        sekTeloFramesR.append(atlasTelo.textureNamed("\(shortcut)m6"))
        
        teloRebrik.append(atlasTelo.textureNamed("\(shortcut)rebrik"))
        teloRebrik.append(atlasTelo.textureNamed("\(shortcut)rebrik2"))
    }
    
    
    
    func characterMove(left:Bool) {
        seknutiePinned(zapnut: false)
        
        //self.run(.repeatForever(.playSoundFileNamed("behanie.m4a", waitForCompletion: true)),withKey: "zvukBehanie")
        if left {
            
            otocenyDoLava=true
            let repeating = SKAction.repeatForever(.move(by:CGVector (dx: -12, dy: 0), duration: 0.1)) // -36 : 0.1
            self.run(repeating, withKey: "Left2")
            self.nohy.run(.moveTo(x: 1, duration: 0))
            self.xScale = 1.0
            
            self.telo.removeAction(forKey: "teloPohybR")
            self.telo.removeAction(forKey: "teloStay")
            self.telo.removeAction(forKey: "teloStayR")
            if !isInTheAir {
                self.telo.run(teloPohyb!,withKey:"teloPohyb")
                if self.isInTheAir == false {
                    let beh = SKAction.repeatForever(SKAction.animate(with: walkFrames,
                                 timePerFrame: 0.05,
                                 resize: false,
                                 restore: true))
                    //timePerFrame: 0.07
                    self.nohy.run(beh,withKey:"walkingRytL")
                }
            }
        } else {
            otocenyDoLava=false
            let repeating = SKAction.repeatForever(.move(by: CGVector(dx: 12, dy: 0), duration: 0.1))
            self.run(repeating, withKey: "Right2")
            self.nohy.run(.moveTo(x: 1, duration: 0))
            self.xScale = -1.0
            
            self.telo.removeAction(forKey: "teloPohyb")
            self.telo.removeAction(forKey: "teloStay")
            self.telo.removeAction(forKey: "teloStayR")
            if !isInTheAir {
                self.telo.run(teloPohybR!,withKey:"teloPohybR")
                if self.isInTheAir == false {
                    let beh = SKAction.repeatForever(SKAction.animate(with: walkFrames,
                                     timePerFrame: 0.05,
                                     resize: false,
                                     restore: true))
                    self.nohy.run(beh,withKey:"walkingRytR")
                }
            }
        }
        self.run(.wait(forDuration: 0.005),completion: {
            self.seknutiePinned(zapnut: true)
        })
        
    }
    func seknutiePinned(zapnut:Bool) {
        if zapnut {
            self.seknutie.position.x = -12
            self.seknutie.position.y = 10
            self.seknutie.physicsBody?.pinned = true
        } else {
            self.seknutie.physicsBody?.pinned = false
        }
    }
    func characterCancelMove(left:Bool) {
        //print("Character cancel move!")
        self.removeAction(forKey: "zvukBehanie")
        if left {
            self.removeAction(forKey: "Left2")
            self.nohy.removeAction(forKey: "walkingRytL")
            if !self.onRebrik || !self.isInTheAir{
                self.telo.run(teloChillAnim!, withKey: "teloStay")
            }
        } else {
            self.removeAction(forKey: "Right2")
            self.nohy.removeAction(forKey: "walkingRytR")
            if !self.onRebrik || !self.isInTheAir{
                self.telo.run(teloChillAnimR!, withKey: "teloStayR")
            }
        }
        self.nohy.texture=atlasNohy.textureNamed("\(shortcut)Stay1")
    }
    
    func characterLittleMove(left:Bool) {
        //self.physicsBody?.applyImpulse(CGVector(dx: left ? -10 : 10, dy: 0))
    }
    
    func setCollisionPlosina(collisionOn:Bool) {
        if collisionOn {
            self.physicsBody!.collisionBitMask = wallCategory |  plosinaCategory | bossCategory
        } else {
            self.physicsBody!.collisionBitMask = wallCategory | bossCategory
        }
    }
    /*
    func characterJump2(rytierAir:Bool) {
        if (self.onRebrik==false) {
            self.nohy.texture=SKTexture(imageNamed: "Run1")
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 230))   //230--284--(320)
            self.run(.wait(forDuration: 0.1),completion: {
                print("__Waited")
                if self.staleSkace==true {
                    self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 84))   //54
                }
            })
            
            
            isInTheAir=true
            //   ---  BETTER  ---
        }
    }
    */
    func characterJump(rytierAir:Bool) {
        if (self.onRebrik==false) {
            self.nohy.removeAction(forKey: "walkingRytL")
            self.nohy.removeAction(forKey: "walkingRytR")
            self.telo.removeAction(forKey: "teloPohyb")
            self.telo.removeAction(forKey: "teloPohybR")
            self.telo.removeAction(forKey: "RebrikAnimTelo")
            self.nohy.texture=atlasNohy.textureNamed("\(shortcut)Run1")
            self.telo.texture=atlasTelo.textureNamed(otocenyDoLava ? "\(shortcut)s1" : "\(shortcut)s5")
            
            if doublejumpLeft==1 {
                //print("++\(vPoziciSkakania)")
                
                self.physicsBody?.velocity.dy=0
                switch vPoziciSkakania {
                case 1:
                    self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))    //180
                case 2:
                    self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 170))
                case 3:
                    self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 210))
                default:
                    self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 220))
                }
                
                
                //self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 230))

            } else if doublejumpLeft == 2 {
                self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 230))   //230--284--(320)
                self.vPoziciSkakania=1
                self.run(.wait(forDuration: 0.25), completion: {
                    self.vPoziciSkakania=2
                    self.run(.wait(forDuration: 0.25), completion: {
                        self.vPoziciSkakania=3
                    })
                })
                
            }
            self.run(.wait(forDuration: 0.1),completion: {
                //print("__Waited2")
                if self.staleSkace==true {
                    //self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 86))   //54
                }
            })
            
            
            isInTheAir=true
            //   ---  BETTER  ---
        }
    }
    func climbLedder(up:Bool,positionX:CGFloat) {
        self.removeAllActions()
        self.position.x=positionX
        self.position.y=self.position.y
        if !self.onGround && !self.onPlosina{
            self.telo.run(SKAction.repeatForever(.animate(with: teloRebrik, timePerFrame: 0.16, resize: false, restore: true)),withKey: "RebrikAnimTelo")
            self.nohy.texture=atlasNohy.textureNamed("\(shortcut)Rebrik")
            self.nohy.run(.moveTo(x: 0, duration: 0))
        } else {
            self.telo.removeAction(forKey: "RebrikAnimTelo")
        }
        if (up) {
            let moveUp=SKAction.repeatForever(.moveBy(x: 0, y: 8, duration: 0.05))
            self.run(moveUp, withKey: "up")
        } else {
            let moveDown=SKAction.repeatForever(.moveBy(x: 0, y: -4, duration: 0.05))
            self.run(moveDown, withKey: "down")
        }
        //print("Done ledder")
    }
    func setPhysicLedder(offPhysic:Bool) {
        if (offPhysic) {
            //self.physicsBody?.isDynamic = false
            self.physicsBody?.affectedByGravity = false
        } else {
            self.physicsBody?.affectedByGravity = true
            //self.physicsBody?.isDynamic = true
        }
    }
    
    func attack() {
        
        if !attacking && !onRebrik{
            self.run(.playSoundFileNamed("MecVolneSeknutie.m4a", waitForCompletion: false))
            attacking=true
            self.seknutie.physicsBody?.categoryBitMask = mecCategory
            self.telo.run(.animate(with: otocenyDoLava ? sekTeloFramesR : sekTeloFrames, timePerFrame: 0.08), completion: {})
            //seknutie.position=CGPoint(x: -10, y: -10)
            //seknutie.position.y = -10
            //seknutie.position.x = -12
            self.seknutie.isHidden = false
            self.seknutie.run(attackAnim!, completion: {
                //self.seknutie.physicsBody?.categoryBitMask = 0
                self.seknutie.isHidden = true
                self.attacking=false
            })
        }
    }
    
    func nextFloor(goLeftUp:Bool,posunutHore:Int) {
        if goLeftUp {
            //self.position.y = self.rytier!.position.y + hrad!.poschodia[hrad!.currentLevel].vyskaIzby//+ 336
            let goUp = SKAction.move(to: CGPoint(x: -120, y:Int(self.position.y) + posunutHore) , duration: 0.01)    //338 hore
            self.run(goUp)
        } else {
            let goUp = SKAction.move(to: CGPoint(x: 120, y:Int(self.position.y) + posunutHore) , duration: 0.01)
            self.run(goUp)
        }
    }
    func nextFloor2(goLeftUp:Bool,posunutHore:Int) {
        self.removeAllActions()
        self.zablokovaneAkcie=true
        if goLeftUp {
            let goUp = SKAction.move(to: CGPoint(x: -130, y:Int(self.position.y) + posunutHore) , duration: 0.01)    //338 hore
            self.run(goUp)
            self.characterMove(left: false)
            self.run(SKAction.wait(forDuration: 0.48), completion: {
                self.characterCancelMove(left: false)
            })
        } else {
            let goUp = SKAction.move(to: CGPoint(x: 130, y:Int(self.position.y) + posunutHore) , duration: 0.01)
            self.run(goUp)
            self.characterMove(left: true)
            self.run(SKAction.wait(forDuration: 0.48), completion: {
                self.characterCancelMove(left: true)
            })
        }
        self.zablokovaneAkcie=false
    }
    
}

class PlayerDeath:SKSpriteNode {
    var tex:[SKTexture]=[]
    var typ:Int
    var atlas=SKTextureAtlas(named: "Death1")
    init(texture: SKTexture?, color: UIColor, size: CGSize,typ:Int,otocenyDoLava:Bool) {
        print("Death num\(typ)")
        self.typ=typ
        super.init(texture:texture,color:color,size:size)
        atlas = SKTextureAtlas(named: "Death1")
        
        self.texture=atlas.textureNamed("\(typ)Smrt1")
        tex.append(atlas.textureNamed("\(typ)Smrt1"))
        tex.append(atlas.textureNamed("\(typ)Smrt2"))
        tex.append(atlas.textureNamed("\(typ)Smrt3"))
        tex.append(atlas.textureNamed("\(typ)Smrt4"))
        tex.append(atlas.textureNamed("\(typ)Smrt5"))
        tex.append(atlas.textureNamed("\(typ)Smrt6"))
        
        self.zPosition=31
        self.xScale = otocenyDoLava ? 1 : -1
        self.run(.wait(forDuration: 0.1), completion: {
            self.run(.animate(with: self.tex, timePerFrame: 0.02), completion: {
                self.isHidden=true
            })
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
