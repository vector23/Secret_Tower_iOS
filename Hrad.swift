//
//  Hrad.swift
//  Rytier
//
//  Created by Juraj Kebis on 25/03/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//
import SpriteKit
import Foundation
/*
 Bosses Ok:
 - 46 all good
 - 47 working
 - 48 all good, odrazanie asi moze byt
 - 49 all good, just enemies
 - 50 all good
 - 51 good
 - 52 all good
 */
class Hrad:SKNode {
    var poschodia=[Poschodie]()
    var zamiesanychDesat:[Int]?
    var zamiesaneVsetkyBoss=[Int]() //--zamiesane poschodia aj s bossom najblizsim, robene v create hrad a po zabiti bossa
    var vsetkyPoBossa:[Int]?
    var zem:SKSpriteNode?
    var oblaky=[Oblaky]()
    var oblakyVyska=0
    var hranicaL:SKSpriteNode?
    var hranicaP:SKSpriteNode?
    var spodnaZatva:SKSpriteNode?
    var posunutHrad:SKSpriteNode?
    var posunulHradKolko:Int=0
    var vyberBossa:Int=Int.random(in: 52...52)
    var nextBoss:Int=1  //boss 1 zaklad
    var justKilledBoss:Int=1
    var zabilBossaPosunutHrad:Bool=false
    var bossFightSpusteny:Bool=false
    var mrtvyHrac:Bool=true
    let atlis1=SKTextureAtlas(named: "CistePodlazie")
    let atlasGround=SKTextureAtlas(named: "Ground")
    var strasiak:SKSpriteNode?
    var strasiakLifeLeft:Int=2
    
    
    //--vyska na podlazie
    var vyskaVPixeloch:Int64=0
    
    //--pocitania
    var zamiesaneCount=0    //-pocita a sleduje pole zamiesanychDesat, a prechadza postupne cez ne
    var zamiesaneOdpocitat=0    //-odpocitava kvoli pridavaniu dalsich setov
    var level:Int=0     //-sucasny level poschodii, kvoli pridavaniu do array + -
    var levelHeight:Int=0   //-celkovy pocet poschodii
    var currentLevel:Int=0  //-ukazuje na ktorej urovni sme kvoli vymazavaniu childs(coins)
    var score:Int=0 //-ukazuje score hraca, kolko elevatorov presiel
    
    
    func addFloor2() {
        if ((oblakyVyska) < vyskaVPixeloch) {
            //print("Posuvame: vyska hradu \(vyskaVPixeloch) a oblaky vyska \(oblakyVyska)")
            pridatOblaky()
        }
        currentLevel = currentLevel + 1
        //----ADDING----
        poschodia.append(Poschodie(type: zamiesaneVsetkyBoss[zamiesaneCount], vchodL: poschodia[currentLevel+3].vychodNaPravo ? true:false, pairRoom: levelHeight % 2 == 0 ? true:false,zakrytRoom: false)) //currentLevel-1 dal som +3
        self.addChild(poschodia[level])
        
        poschodia[level].position=CGPoint(x: self.position.x, y: CGFloat(vyskaVPixeloch))  //336 * levelHeight
        vyskaVPixeloch=vyskaVPixeloch + Int64(poschodia[level].vyskaIzby)
        //stare-poschodia[level].position=CGPoint(x: self.position.x, y: (poschodia[level-1].vyskaIzby * CGFloat(levelHeight)))
        //----DELETE----
        if levelHeight > 9 {    //7
            poschodia[0].removeFromParent()
            zem?.removeFromParent()
            poschodia.remove(at: 0)
            currentLevel = currentLevel - 1
            level = level - 1
        }
        level = level + 1
        levelHeight=levelHeight + 1
        zamiesaneCount=zamiesaneCount + 1
        zamiesaneOdpocitat -= 1
    }
    
    func addFloor() {
        if ((oblakyVyska) < vyskaVPixeloch) {
            //print("Posuvame: vyska hradu \(vyskaVPixeloch) a oblaky vyska \(oblakyVyska)")
            pridatOblaky()
        }
        if levelHeight > 30 && levelHeight <= 39 && zamiesaneOdpocitat == 0 {
            print("%%")
            print(self.currentLevel)
            zamiesanychDesat=bossFloors(boss: vyberBossa)
            zamiesaneOdpocitat=8
            zamiesaneCount=0
        } else if (zamiesanychDesat == nil || zamiesaneOdpocitat == 0) {
            zamiesanychDesat = mixTenFloors()
            zamiesaneOdpocitat=10
            zamiesaneCount=0
        }      //zamiesanie 10 poschodi
        currentLevel = currentLevel + 1
        //----ADDING----
        poschodia.append(Poschodie(type: zamiesanychDesat![zamiesaneCount], vchodL: poschodia[currentLevel+3].vychodNaPravo ? true:false, pairRoom: levelHeight % 2 == 0 ? true:false,zakrytRoom: false)) //currentLevel-1 dal som +3
        self.addChild(poschodia[level])
        
        poschodia[level].position=CGPoint(x: self.position.x, y: CGFloat(vyskaVPixeloch))  //336 * levelHeight
        vyskaVPixeloch=vyskaVPixeloch + Int64(poschodia[level].vyskaIzby)
        //stare-poschodia[level].position=CGPoint(x: self.position.x, y: (poschodia[level-1].vyskaIzby * CGFloat(levelHeight)))
        //----DELETE----
        if levelHeight > 7 {
            poschodia[0].removeFromParent()
            zem?.removeFromParent()
            poschodia.remove(at: 0)
            currentLevel = currentLevel - 1
            level = level - 1
        }
        level = level + 1
        levelHeight=levelHeight + 1
        zamiesaneCount=zamiesaneCount + 1
        zamiesaneOdpocitat -= 1
    }
 
    func createHrad() {
        //--pridane
        zamiesaneVsetkyBoss=mixFloorsAndBoss(boss: 1)   //1
        zamiesaneOdpocitat=zamiesaneVsetkyBoss.count
        zamiesaneCount=0
        //--------
        
        zem=SKSpriteNode(texture: atlasGround.textureNamed("ground"))
        //zem=SKSpriteNode(imageNamed: "GroundBac")
        zem?.size=CGSize(width: 2354, height: 560)   //800x344
        //spodek?.size=CGSize(width: 3080, height: 1200)
        zem?.position=CGPoint(x: -477, y: -64) //-101,-172
        zem?.zPosition=13
        self.addChild(zem!)
        zem?.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: -1177, y: 61), to: CGPoint(x: 1177, y: 61))
        zem?.physicsBody?.restitution = 0
        zem?.physicsBody?.isDynamic = false
        zem?.physicsBody?.categoryBitMask = wallCategory
        let temp1=SKSpriteNode(texture: atlasGround.textureNamed("lStenap"))
        let temp2=SKSpriteNode(texture: atlasGround.textureNamed("lStenaz"))
        let temp3=SKSpriteNode(texture: atlasGround.textureNamed("strom"))
        let temp4=SKSpriteNode(texture: atlasGround.textureNamed("stras"))
        let temp5=SKSpriteNode(texture: atlasGround.textureNamed("bigKamen"))
        let temp6=SKSpriteNode(texture: atlasGround.textureNamed("smKamen"))
        self.zem?.addChild(temp1)
        self.zem?.addChild(temp2)
        self.zem?.addChild(temp3)
        strasiak=temp4
        self.zem?.addChild(strasiak!)
        self.zem?.addChild(temp5)
        self.zem?.addChild(temp6)
        temp1.position=CGPoint(x: -800, y: 120)
        temp1.zPosition=32
        temp2.position=CGPoint(x: -780, y: 140)
        temp2.zPosition=13
        temp3.position=CGPoint(x: -500, y: 122)
        temp3.zPosition=14
        strasiak?.position=CGPoint(x: 150, y: 99)
        strasiak?.zPosition=14
        strasiak?.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 30, height: 100))
        strasiak?.physicsBody?.isDynamic=false
        strasiak?.name="Strasiak"
        temp5.position=CGPoint(x: -140, y: 109)  //170
        temp5.zPosition=14
        temp5.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 85, height: 90)) //spravit ine   w95 h 90
        temp5.physicsBody?.isDynamic=false
        temp5.physicsBody?.restitution=0
        temp5.physicsBody?.categoryBitMask = wallCategory
        temp6.position=CGPoint(x: -226, y: 80)    //84
        temp6.zPosition=14
        temp6.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width: 120, height: 32))
        temp6.physicsBody?.isDynamic=false
        temp6.physicsBody?.restitution=0
        temp6.physicsBody?.categoryBitMask = wallCategory
        
        
        pridatOblaky()
        pridatOblaky()
        
        hranicaL=SKSpriteNode()
        hranicaL?.size=CGSize(width: 8, height: 200)
        hranicaL?.position=CGPoint(x: -1270, y: 80)
        hranicaL?.color=UIColor.white
        hranicaL?.zPosition=102
        hranicaL?.physicsBody=SKPhysicsBody(rectangleOf: hranicaL!.size)
        hranicaL?.physicsBody?.isDynamic=false
        hranicaL?.isHidden=true
        self.addChild(hranicaL!)
        hranicaP=SKSpriteNode()
        hranicaP?.size=CGSize(width: 8, height: 200)
        hranicaP?.position=CGPoint(x: 210, y: 80)
        hranicaP?.color=UIColor.white
        hranicaP?.zPosition=102
        hranicaP?.physicsBody=SKPhysicsBody(rectangleOf: hranicaP!.size)
        hranicaP?.physicsBody?.isDynamic=false
        hranicaP?.isHidden=true
        self.addChild(hranicaP!)
        posunutHrad=SKSpriteNode()
        posunutHrad?.size=CGSize(width: 4, height: 320)
        posunutHrad?.position=CGPoint(x: -920, y: 140)
        posunutHrad?.color=UIColor.white
        posunutHrad?.alpha=0
        posunutHrad?.zPosition=102
        posunutHrad?.physicsBody=SKPhysicsBody(rectangleOf: posunutHrad!.size)
        posunutHrad?.physicsBody?.isDynamic=false
        posunutHrad?.physicsBody?.collisionBitMask=0
        posunutHrad?.isHidden=false
        posunutHrad?.name="MoveCastle"
        self.addChild(posunutHrad!)
        spodnaZatva=SKSpriteNode()
        spodnaZatva?.size=CGSize(width: 300, height: 4)
        spodnaZatva?.position=CGPoint(x: -610, y: -2)
        spodnaZatva?.color=UIColor.white
        spodnaZatva?.zPosition=102
        spodnaZatva?.physicsBody=SKPhysicsBody(rectangleOf: spodnaZatva!.size)
        spodnaZatva?.physicsBody?.isDynamic=false
        spodnaZatva?.physicsBody?.affectedByGravity=false
        spodnaZatva?.isHidden=true
        self.addChild(spodnaZatva!)
        
        
        //self.setScale(0.44)
        self.position=CGPoint(x: 0, y: -100) //-- 368 polka y scene

        for i in 0...4 {
            if i==0 {
                //poschodia.append(Poschodie(type: 1, vchodL: levelHeight % 2 == 0 ? true:false, pairRoom: levelHeight % 2 == 0 ? true:false))
                poschodia.append(Poschodie(type: 1, vchodL: true, pairRoom: levelHeight % 2 == 0 ? true:false,zakrytRoom: false))
                //poschodia.append(Poschodie(type: zamiesaneVsetkyBoss[zamiesaneCount], vchodL: true, pairRoom: levelHeight % 2 == 0 ? true:false,zakrytRoom: false))
            } else {
                //poschodia.append(Poschodie(type: Int.random(in: 16...16), vchodL: poschodia[level-1].vychodNaPravo ? true:false, pairRoom: levelHeight % 2 == 0 ? false:true,zakrytRoom: false))
                poschodia.append(Poschodie(type: zamiesaneVsetkyBoss[zamiesaneCount], vchodL: poschodia[level-1].vychodNaPravo ? true:false, pairRoom: levelHeight % 2 == 0 ? true:false,zakrytRoom: false))
                
                zamiesaneCount=zamiesaneCount + 1
                zamiesaneOdpocitat -= 1
            }
            self.addChild(poschodia[i])
            //poschodia[i].position=CGPoint(x: self.position.x, y: (112 * CGFloat(i)))
            
            if i==1 && poschodia[i].typeOfRoom != 2 {
                poschodia[i].podlahy[0].texture=atlis1.textureNamed("Podlaha_hore")
                
                
            }
            poschodia[i].position=CGPoint(x: self.position.x, y: CGFloat(vyskaVPixeloch))
            vyskaVPixeloch=vyskaVPixeloch+Int64(poschodia[i].getVyska())
            
            level=level+1
            levelHeight=levelHeight+1
            
            //vyskaVPixeloch=vyskaVPixeloch+112   //ak ratame na zacaitok zakladnu vysku 336, inak zmenit
            
        }
    }
    //--novy algoritmus
    func mixFloorsAndBoss(boss:Int) -> Array<Int> {
        let skuska=HradAlgorithm()
        var x=skuska.getLevelsToBoss(nextBoss: boss)
        let kons=[4,2,2,2,(boss+45),2,2,2]
        x = x + kons
        return x
    }
    
    func mixTenFloors() -> Array<Int> {
        //let temp = [20,21,22,23,24,25,26,27,28,29] // zaklad
        //let temp = [60,61,62,63,64,65,65,64,63,62]    //zak hard
        //let temp = [26,27,28,29,30,31,32,33,34,35]    //rebrik
        //let temp = [26,27,28,29,30,31,32,33,34,35]  //reb hard
        
        //let skuska=HradAlgorithm()
        //var x=skuska.getLevelsToBoss(nextBoss: 1)
        //print("Terra\(x)")
        
        let tesit=Int.random(in: 11...11)
        let temp = [tesit,tesit,tesit,tesit,tesit,tesit,tesit,tesit,tesit,tesit]
        //let temp = [10,11,12,13,14,15,16,17,18,19]
        //return temp.shuffled()
        return temp
    }
    
    func bossFloors(boss:Int) -> Array<Int> {
        let kons=[4,2,2,2,48,2,2,2]   //boss
        return kons
    }
    /*
    
    func addOblak(poX:Int,poY:Int) {
        var oblacik=Oblaky(texture: nil, color: nil, size: nil, posunutPoY: 0)
        self.addChild(oblacik)
        oblacik.position=CGPoint(x: 0, y: 0)
    }
 */
    
    func moveUp(typ:posunutHore) {
        if currentLevel == 0 {
            let goUp2 = SKAction.move(by: CGVector(dx: 0, dy: 30), duration: 0.8)   //12
            //goUp2.timingMode = .easeOut
            goUp2.timingMode = .easeInEaseOut
            self.run(goUp2)
        }
        
        if typ == .normal {
            let goUp = SKAction.move(by: CGVector(dx: 0, dy: -(poschodia[currentLevel].getVyska()) * 1.0), duration: 0.8)    //-336,-252 male 2/8
            goUp.timingMode = .easeInEaseOut
            
            let first = SKAction.move(by: CGVector(dx: 0, dy: -(poschodia[currentLevel].getVyska()) * 1.0), duration: 1.2)  //1.4
            first.timingMode = .easeInEaseOut
            let wait = SKAction.wait(forDuration: 0.0) //0.2
            let seq = SKAction.sequence([wait,first])
            
            self.addFloor2() //addFloor2()
            
            self.run(seq)
            //self.run(goUp)
            
            if currentLevel != 0 {
                let temp=poschodia[currentLevel].stenaVstupDvere
                self.run(.wait(forDuration: 0.4), completion: { //0.8
                    self.poschodia[self.currentLevel].steny[temp].zatvoritDvere()
                    self.poschodia[self.currentLevel].zatvoritDvere(vstupne: true)
                })
                if currentLevel > 1 {
                    let temp2=poschodia[currentLevel-1].stenaVystupDvere
                    poschodia[currentLevel-1].steny[temp2].zatvoritDvere()
                    self.poschodia[self.currentLevel].zatvoritDvere(vstupne: true)
                }
            }
            
        } else if typ == .zKlebaPolo {
            
            let goUp = SKAction.move(by: CGVector(dx: 0, dy: (-112 * 4)-30), duration: 3)    //-336,-252 male 2/8
            goUp.timingMode = .easeInEaseOut
            
            let first = SKAction.move(by: CGVector(dx: 0, dy: (-112 * 4)-30), duration: 3)
            
            first.timingMode = .easeInEaseOut
            let wait = SKAction.wait(forDuration: 0.2)
            let seq = SKAction.sequence([wait,first])
            self.addFloor2()
            self.run(seq,completion: {
                self.addFloor2()
                self.addFloor2()
                //--pridame
                self.nextBoss += 1
                self.zamiesaneVsetkyBoss=self.mixFloorsAndBoss(boss: self.nextBoss)
                self.zamiesaneOdpocitat=self.zamiesaneVsetkyBoss.count
                self.zamiesaneCount=0
                //--------
                
                self.addFloor2()
                self.bossFight(tahsie: false)
                let trm = self.poschodia[self.currentLevel-1].vychodNaPravo
                self.poschodia[self.currentLevel].steny[trm ? 0 : 1].zatvoritDvere()
                
            })
            /*
                let temp=poschodia[currentLevel].stenaVstupDvere
                self.run(.wait(forDuration: 0.5), completion: { //0.8
                    //self.poschodia[self.currentLevel].steny[temp].zatvoritDvere()
                })
             */
        } else if typ == .zKlenbyHore {
            self.zabilBossaPosunutHrad = false
            let inyBossVyska=112*7+83   //bolo+56
            let normalBossVyska=112*7
            let first = SKAction.move(by: CGVector(dx: 0, dy: (-(justKilledBoss==3 ? inyBossVyska : normalBossVyska)) + 142), duration: 3)   //7
            
            first.timingMode = .easeInEaseOut
            let wait = SKAction.wait(forDuration: 0.2)
            let seq = SKAction.sequence([wait,first])
            self.addFloor2()
            self.run(.wait(forDuration: 1),completion: {
                self.addFloor2()
                self.addFloor2()
            })
            self.run(seq,completion: {
                self.addFloor2()
                let trm = self.poschodia[self.currentLevel-1].vychodNaPravo
                self.poschodia[self.currentLevel].steny[trm ? 1 : 0].zatvoritDvere()
            })
            justKilledBoss += 1
        } else if typ == .naKlenbuRebrik {
            let first = SKAction.move(by: CGVector(dx: 0, dy: -112*1), duration: 2)    //112*2
            first.timingMode = .easeInEaseOut
            let wait = SKAction.wait(forDuration: 0.2)
            let seq = SKAction.sequence([wait,first])
            //self.addFloor()
            self.run(seq,completion: {
                //self.addFloor()
            })
        }
        
    }
    
    func presunRytier(ryt:Player3,typ:posunutHore) {
        
        var rytierIdeZPrava:Bool=false
        ryt.zablokovaneAkcie=true
        ryt.characterCancelMove(left: true)
        ryt.characterCancelMove(left: false)
        ryt.removeAllActions()
        //ryt.movingLeftB=false
        //ryt.movingRightB=false
        ryt.isHidden=true   //poschodia[currentLevel].typ == .prizemie ? -94 : 0
        //let rytX=ryt.position.x
        
        if typ == .normal {
            print("##Current level - \(currentLevel)")
            if currentLevel == 0 {
                rytierIdeZPrava = false
            } else {
                rytierIdeZPrava = poschodia[currentLevel].vychodNaPravo ? true : false
            }

            ryt.run(.moveTo(x: rytierIdeZPrava ? 94 : -94, duration: 0),completion: {  //bolo 94:-94
                if rytierIdeZPrava {
                    ryt.xScale = 1
                } else {
                    ryt.xScale = -1
                }
            })
            ryt.run(.moveBy(x: 0, y: CGFloat(poschodia[currentLevel].posunutPlayerY), duration: 0))
            //--
            /*
            ryt.run(.moveBy(x: poschodia[currentLevel].typ == .prizemie ? -94 : 0 , y: poschodia[currentLevel].getVyska(), duration: 0), completion: {    //112
                if self.levelHeight % 2 == 0 {
                    ryt.xScale = -1
                } else {
                    ryt.xScale = 1
                }
            })
             */
            self.run(.wait(forDuration: 0.4), completion: {  // 0.5
                //print("Rytier je slobodny")
                ryt.isHidden=false
                //ryt.characterMove(left: self.levelHeight % 2 == 0 ? false : true)
                ryt.characterMove(left: rytierIdeZPrava ? true : false)
                self.run(.wait(forDuration: 0.1), completion: {
                    ryt.removeAllActions()
                    ryt.characterCancelMove(left: rytierIdeZPrava ? true : false)
                    ryt.zablokovaneAkcie=false
                    if ryt.movingLeftB && !ryt.movingRightB {
                        print("§ LEFT")
                        ryt.characterMove(left: true)
                    } else if ryt.movingRightB {
                        print("§ RIGHT")
                        ryt.characterMove(left: false)
                    }
                })
            })
            
        } else if typ == .zKlebaPolo {
            rytierIdeZPrava = poschodia[currentLevel].vychodNaPravo ? true : false
            ryt.run(.moveTo(x: rytierIdeZPrava ? 94 : -94, duration: 0),completion: {
                if rytierIdeZPrava {
                    ryt.xScale = 1
                } else {
                    ryt.xScale = -1
                }
            })
            ryt.run(.moveBy(x: 0, y: 112*4, duration: 0)) //112*4

            self.run(.wait(forDuration: 3.4), completion: {  // 0.5
                //print("Rytier je slobodny")
                ryt.isHidden=false
                //ryt.characterMove(left: self.levelHeight % 2 == 0 ? false : true)
                ryt.characterMove(left: rytierIdeZPrava ? true : false)
                self.run(.wait(forDuration: 0.1), completion: {
                    ryt.removeAllActions()
                    ryt.characterCancelMove(left: rytierIdeZPrava ? true : false)
                    ryt.zablokovaneAkcie=false
                    
                    if ryt.movingLeftB && !ryt.movingRightB {
                        print("§ LEFT")
                        ryt.characterMove(left: true)
                    } else if ryt.movingRightB {
                        print("§ RIGHT")
                        ryt.characterMove(left: false)
                    }
                })
            })
        } else if typ == .zKlenbyHore {
            rytierIdeZPrava = poschodia[currentLevel].vychodNaPravo ? false : true  //true:false
            ryt.run(.moveTo(x: rytierIdeZPrava ? 94 : -94, duration: 0),completion: {
                if rytierIdeZPrava {
                    ryt.xScale = 1
                } else {
                    ryt.xScale = -1
                }
            })
            ryt.run(.moveBy(x: 0, y: 112*4 + (justKilledBoss == 3 ?  50 : 0), duration: 0)) //112*4 bolo 28

            self.run(.wait(forDuration: 3.4), completion: {  // 0.5
                //print("Rytier je slobodny")
                ryt.isHidden=false
                //ryt.characterMove(left: self.levelHeight % 2 == 0 ? false : true)
                ryt.characterMove(left: rytierIdeZPrava ? true : false)
                self.run(.wait(forDuration: 0.1), completion: {
                    ryt.removeAllActions()
                    ryt.characterCancelMove(left: rytierIdeZPrava ? true : false)
                    ryt.zablokovaneAkcie=false
                    
                    self.childNode(withName: "TemporaryStena")?.removeFromParent()  //vymaze sa predchadzajuce pred tym nez nove pride/ aby nezaplnovalo pamat
                    let temp=SKSpriteNode(color: UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: 2, height: 80))
                    temp.physicsBody=SKPhysicsBody(rectangleOf: temp.size)
                    temp.physicsBody?.restitution = 0
                    temp.physicsBody?.isDynamic = false
                    self.addChild(temp)
                    let spos=self.poschodia[self.currentLevel].position
                    temp.position=CGPoint(x: spos.x + (rytierIdeZPrava ? 103 : -103), y: spos.y + 40)
                    temp.name="TemporaryStena"
                    
                    
                    if ryt.movingLeftB && !ryt.movingRightB {
                        print("§ LEFT")
                        ryt.characterMove(left: true)
                    } else if ryt.movingRightB {
                        print("§ RIGHT")
                        ryt.characterMove(left: false)
                    }
                })
            })
        }
    }
    
    func pridatOblaky() {
        //oblakyVyska = oblakyVyska+posunutPoY
        oblaky.append(Oblaky(texture: nil, color: nil, size: nil, posunutPoY: oblakyVyska, posunutPoX: 0, prve: true))
        oblaky.append(Oblaky(texture: nil, color: nil, size: nil, posunutPoY: oblakyVyska, posunutPoX: 0, prve: false))
        self.addChild(oblaky[oblaky.count-2])
        self.addChild(oblaky[oblaky.count-1])
        oblaky[oblaky.count-2].move()
        oblaky[oblaky.count-1].move2()
        oblakyVyska = oblakyVyska+500
    }
    
    func bossFight(tahsie:Bool) {
        bossFightSpusteny=true
        
        let sucPoschodie=self.poschodia[self.currentLevel]
        
        let shakeTower=SKAction.repeat(.sequence([.moveBy(x: 0, y: -18, duration: 0.04),.moveBy(x: 0, y: 18, duration: 0.04)]), count: 10)
        let shakeTowerSlowly=SKAction.repeat(.sequence([.moveBy(x: 0, y: -12, duration: 0.04),.moveBy(x: 0, y: 12, duration: 0.04)]), count: 2)
        let fullShake=SKAction.sequence([shakeTowerSlowly,shakeTower,shakeTowerSlowly])
        //prvy otras
        self.run(.wait(forDuration: 2.6), completion: {
            self.run(fullShake,completion: {
                self.run(.wait(forDuration: 0.2), completion: {
                    sucPoschodie.bossKamene(typ: self.justKilledBoss+45,tahsie:tahsie)
                    self.run(.wait(forDuration: tahsie ? 6 : 4.2), completion: {  //7/6-4
                        //sucPoschodie.odstranitKamene()
                        print("Mrtvy hrac \(!self.mrtvyHrac) and popadali? \(self.poschodia[self.currentLevel].popadaliKamene)")
                        if !self.mrtvyHrac && self.poschodia[self.currentLevel].popadaliKamene {
                            sucPoschodie.bossSet?.pridat(cislo: sucPoschodie.typeOfRoom)
                            if sucPoschodie.bossSet?.cisloBoss == 47 {
                                self.run(.wait(forDuration: 4),completion: {
                                    
                                    if !self.mrtvyHrac {
                                        if tahsie {
                                            self.run(.wait(forDuration: 2),completion: {
                                                sucPoschodie.boss?.jumpHard(fromRight: true)
                                                self.bossFightSpusteny=false
                                            })
                                        } else {
                                            sucPoschodie.boss?.jumpEasy(fromRight: false)
                                        }
                                    }
                                })
                            } else {
                                self.bossFightSpusteny=false
                            }
                        }
                    })
                })
            })
        })
    }
    func killedBoss() {
        let sucPoschodie=self.poschodia[self.currentLevel]
        let shakeTower=SKAction.repeat(.sequence([.moveBy(x: 0, y: -20, duration: 0.04),.moveBy(x: 0, y: 20, duration: 0.04)]), count: 12)
        let shakeTowerSlowly=SKAction.repeat(.sequence([.moveBy(x: 0, y: -14, duration: 0.04),.moveBy(x: 0, y: 14, duration: 0.04)]), count: 2)
        let fullShake=SKAction.sequence([shakeTowerSlowly,shakeTower,shakeTowerSlowly])
        
        
        sucPoschodie.childNode(withName: "boss")?.removeFromParent()
        sucPoschodie.bossSet!.odstranit(cislo: (sucPoschodie.typeOfRoom))
        sucPoschodie.bossSet!.pridatPlosinyNaKonci()
        sucPoschodie.odstranitKamene()
        self.zabilBossaPosunutHrad = true
        self.run(fullShake,completion: {
            self.run(.wait(forDuration: 0.6),completion: {
                sucPoschodie.cPozadie[0].run(.fadeOut(withDuration: 0.4))
                sucPoschodie.podlahy[1].run(.fadeOut(withDuration: 0.4))
                sucPoschodie.podlahy[1].removeFromParent()
                self.moveUp(typ: .naKlenbuRebrik)
                sucPoschodie.rebriky[0].run(.moveBy(x: 0, y: -56, duration: 1),completion: {   //-112
                    sucPoschodie.rebriky[0].setPhysics(on: true)
                })
            })
        })
        
    }
    
}
