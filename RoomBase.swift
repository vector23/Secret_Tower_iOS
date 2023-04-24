//
//  RoomBase.swift
//  Rytier
//
//  Created by Juraj Kebis on 19/06/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//

import Foundation
import SpriteKit


class PoschodieZaklad:SKNode {
    var typ:typPoschodia        //--klasika,dvojity,jeden a pol
    var numRoom:Int     //--cislo,izby
    var vyskaIzby:CGFloat=0
    var vychodNaRovnakejStrane:Bool=false
    var vychodNaPravo:Bool=false
    var naRebrikuBolBoss:Bool=false
    var zakritRoom:Bool //--funguje iba na klasiku
    
    var podlahy=[Podlaha]()
    var pozadie=[Pozadie]()
    var prizemie=[Prizemie]()   //prizemie
    var cPozadie=[CistePozadie]()   //ciste pozadie
    var brana=[Brana]()
    var steny=[Stena]()
    var plosiny=[Plosina]()
    var rebriky=[Rebrik]()
    var stlpy=[Stlp]()
    var bossFace=[BossFace]()
    var elevator:Elevator
    var leftWall:SKSpriteNode
    var rightWall:SKSpriteNode
    var leftWall2:SKSpriteNode
    var rightWall2:SKSpriteNode
    var vstWall:Int=0   //1-leftWall,2-rightWall,3-leftWall2,4-rightWall2
    var vysWall:Int=0
    
    var stenaVstupDvere:Int=0
    var stenaVystupDvere:Int=0
    
    var posunutPlayerY:Int=112    //--na elevator ked stupi tak kolko sa ma posunut hore
    
    let atlas=SKTextureAtlas(named: "CistePodlazie")
    
    init(typ:typPoschodia,vstupDvereL:Bool,numRoom:Int,zakrytRoom:Bool) {
        self.typ=typ
        self.zakritRoom=zakrytRoom
        if numRoom != 29 && numRoom != 31{
            vychodNaRovnakejStrane=false
        } else {
            vychodNaRovnakejStrane=true
        }
        elevator=Elevator(texture: nil, color: nil, size: nil, posunutPoY: 0, posunutPoX: 0)
        leftWall=SKSpriteNode(color: .red, size: CGSize(width: 1, height: 100))
        rightWall=SKSpriteNode(color: .red, size: CGSize(width: 1, height: 100))
        leftWall.zPosition=34
        rightWall.zPosition=34
        leftWall.position=CGPoint(x: -102, y: 50)
        rightWall.position=CGPoint(x: 102, y: 50)
        
        leftWall2=SKSpriteNode(color: .red, size: CGSize(width: 1, height: 100))
        rightWall2=SKSpriteNode(color: .red, size: CGSize(width: 1, height: 100))
        leftWall2.zPosition=34
        rightWall2.zPosition=34
        leftWall2.position=CGPoint(x: -102, y: 50)
        rightWall2.position=CGPoint(x: 102, y: 50)
        self.numRoom=numRoom
        super.init()
        
        leftWall.isHidden=true
        rightWall.isHidden=true
        leftWall2.isHidden=true
        rightWall2.isHidden=true

        //  zakladna podlaha v izbe
        if typ != .prizemie && typ != .ciste {
            putPodlaha(dlzka: nil, doVysky: 0, posunutPoX: 0)
        }
        //  switch na zistenie typu izby
        switch self.typ {
        case .bossRoom:
            putPozadie(male: false, vyskaPredch: 0)
            putPozadie(male: false, vyskaPredch: 112)
            putPozadie(male: false, vyskaPredch: 224)
            //putPozadie(male: false, vyskaPredch: 336)
            putStenu(typ: !vstupDvereL ? .lCista : .lNormal, vyskaPredch: 0)
            putStenu(typ: !vstupDvereL ? .pNormal : .pCista, vyskaPredch: 0)
            putStenu(typ: .lCista, vyskaPredch: 112)
            putStenu(typ: .pCista, vyskaPredch: 112)
            putStenu(typ: .lCista, vyskaPredch: 224)
            putStenu(typ: .pCista, vyskaPredch: 224)
            //putStenu(typ: .lCista, vyskaPredch: 336)
            //putStenu(typ: .pCista, vyskaPredch: 336)
            vstWall = !vstupDvereL ? 1 : 2
            leftWall.position.y=170
            leftWall.size.height=340
            rightWall.position.y=170
            rightWall.size.height=340
            leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 170), to: CGPoint(x: 0, y: -170))
            rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 170), to: CGPoint(x: 0, y: -170))
            self.addChild(leftWall)
            self.addChild(rightWall)
            
            if self.numRoom != 48 {
                putPozadie(male: false, vyskaPredch: 336)
                putStenu(typ: .klenbaCela, vyskaPredch: 336)
                putBrana(vyskaPredch: 336, typ: .dvere, posunutPoX: 0)
                //putPlosina(doVysky: 328, posunutPoX: 0, typ: .xxxl)
                putElevator(poY: 336, poX: 0)
                elevator.physicsBody?.categoryBitMask = dverePressCategory
                vychodNaPravo = false
                if numRoom != 48 {
                    putRebrik(doVysky: 336, posunutPoX: 0, typ: .small)    //224    xl
                    rebriky[0].setPhysics(on: false)
                }
                putCistePozadie(vyskaPredch: 336)
                putPodlaha(dlzka: nil, doVysky: 336, posunutPoX: 0)
                podlahy[1].texture=atlas.textureNamed("Podlaha_hore")
                podlahy[1].zPosition=32

            }
            
            
            switch self.numRoom {
            case 46:
                print("Hel")
                // 1
                /*
                putPlosina(doVysky: 50, posunutPoX: 60, typ: .small)    //48
                putPlosina(doVysky: 50, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 108, posunutPoX: 60, typ: .small)   //104
                putPlosina(doVysky: 108, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: 60, typ: .small)   //160
                putPlosina(doVysky: 166, posunutPoX: -60, typ: .small)
                 */
                //putPlosina(doVysky: 224, posunutPoX: 0, typ: .large)    //216
                //-----ZLE vsetky plosiny musia do bossSetup
            case 47:
                print("nothing")
                //putPlosina(doVysky: 216, posunutPoX: 0, typ: .large)
            case 48:
                putStlp(vyskaPredch: 0, posunutPoX: 0)
                
                putPozadie(male: true, vyskaPredch: 336)
                putStenu(typ: .lMalaCista, vyskaPredch: 336)
                putStenu(typ: .pMalaCista, vyskaPredch: 336)
                
                putPozadie(male: false, vyskaPredch: 420)   //-28
                putStenu(typ: .klenbaCela, vyskaPredch: 420)
                putBrana(vyskaPredch: 420, typ: .dvere, posunutPoX: 0)
                //putPlosina(doVysky: 412, posunutPoX: 0, typ: .xxxl)
                putElevator(poY: 420, poX: 0)
                elevator.physicsBody?.categoryBitMask = dverePressCategory
                vychodNaPravo = false
                putRebrik(doVysky: 420, posunutPoX: 0, typ: .small)    //224
                rebriky[0].setPhysics(on: false)
                putCistePozadie(vyskaPredch: 420)
                
                putPodlaha(dlzka: nil, doVysky: 420, posunutPoX: 0)
                podlahy[1].texture=atlas.textureNamed("Podlaha_hore")
                podlahy[1].zPosition=32
 
                
            case 49:    //spravit
                print("hel")
                /*
                putPlosina(doVysky: 50, posunutPoX: 0, typ: .xxl)
                putPlosina(doVysky: 108, posunutPoX: 88, typ: .small)
                putPlosina(doVysky: 108, posunutPoX: -88, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: 88, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: -88, typ: .small)
                putPlosina(doVysky: 224, posunutPoX: 0, typ: .large)
                 */
            case 50:
                print("Hel")
                /*
                putPlosina(doVysky: 50, posunutPoX: 88, typ: .small)
                putPlosina(doVysky: 50, posunutPoX: -88, typ: .small)
                putPlosina(doVysky: 108, posunutPoX: 0, typ: .large)
                putPlosina(doVysky: 166, posunutPoX: 88, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: -88, typ: .small)
                putPlosina(doVysky: 224, posunutPoX: 0, typ: .large)
                 */
            case 51:
                print("Hel")
                /*
                putPlosina(doVysky: 50, posunutPoX: 60, typ: .small)
                putPlosina(doVysky: 50, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 108, posunutPoX: 0, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: 60, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 224, posunutPoX: 0, typ: .medium)
                */
            case 52:
                print("OOo hel no")
                /*
                putPlosina(doVysky: 50, posunutPoX: 60, typ: .small)
                putPlosina(doVysky: 50, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 108, posunutPoX: 60, typ: .small)
                putPlosina(doVysky: 108, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: 88, typ: .small)
                putPlosina(doVysky: 166, posunutPoX: -88, typ: .small)
                putPlosina(doVysky: 224, posunutPoX: 0, typ: .medium)
                */
            default:
                putPlosina(doVysky: 52, posunutPoX: 60, typ: .small)    //48
                putPlosina(doVysky: 52, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 112, posunutPoX: 60, typ: .small)   //104
                putPlosina(doVysky: 112, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 172, posunutPoX: 60, typ: .small)   //160
                putPlosina(doVysky: 172, posunutPoX: -60, typ: .small)
                putPlosina(doVysky: 232, posunutPoX: 0, typ: .large)    //216
                
                print("L")
            }
            if self.numRoom == 48 {
                putFace(poX: 0, poY: 180,typ:numRoom-45)
            } else if self.numRoom == 51 {
                putFace(poX: 0, poY: 124,typ:numRoom-45)
            } else {
                putFace(poX: 0, poY: 160,typ:numRoom-45)
            }
        case .klasika:
            putPozadie(male: false, vyskaPredch: 0)
            putStenu(typ: .lNormal, vyskaPredch: 0)
            putStenu(typ: .pNormal, vyskaPredch: 0)
            leftWall.position.y=76
            leftWall.size.height=40
            rightWall.position.y=76
            rightWall.size.height=40
            leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: 0, y: -20))
            rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: 0, y: -20))
            self.addChild(leftWall)
            self.addChild(rightWall)
            vstWall = !vstupDvereL ? 1 : 2
            vysWall = !vstupDvereL ? 2 : 1
            putElevator(poY: 0, poX: !vstupDvereL ? 130 : -130)
            stenaVstupDvere = !vstupDvereL ? 0 : 1
            stenaVystupDvere = !vstupDvereL ? 1 : 0
            vychodNaPravo = !vstupDvereL ? true : false
            if zakritRoom {
                putCistePozadie(vyskaPredch: 0)
            }
            break
        case .dvojty:
            //virtualna zem pri hornych dverach aby sa neprepadol hrac dole
            let temp=SKSpriteNode(color: UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: 20, height: 2))
            temp.physicsBody=SKPhysicsBody(rectangleOf: temp.size)
            temp.physicsBody?.restitution = 0
            temp.physicsBody?.isDynamic = false
            self.addChild(temp)
            temp.position=CGPoint(x: !vstupDvereL ? -110 : 110, y: 110)
            
            putPozadie(male: false, vyskaPredch: 0)
            putPozadie(male: false, vyskaPredch: 112)
            //vyska steny je bud 336 alebo 252
            putStenu(typ: !vstupDvereL ? .lNormal : .lCista, vyskaPredch: 0)
            putStenu(typ: !vstupDvereL ? .pCista : .pNormal, vyskaPredch: 0)
            putStenu(typ: !vstupDvereL ? .lNormal : .lCista, vyskaPredch: 112)
            putStenu(typ: !vstupDvereL ? .pCista : .pNormal, vyskaPredch: 112)
            leftWall.position.y = !vstupDvereL ? 76 : 100
            leftWall.size.height = !vstupDvereL ? 40 : 200
            rightWall.position.y = !vstupDvereL ? 100 : 76
            rightWall.size.height = !vstupDvereL ? 200 : 40
            leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: !vstupDvereL ? 20 : 100), to: CGPoint(x: 0, y: !vstupDvereL ? -20 : -100))
            rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: !vstupDvereL ? 100 : 20), to: CGPoint(x: 0, y: !vstupDvereL ? -100 : -20))
            self.addChild(leftWall)
            self.addChild(rightWall)
            if !vstupDvereL {
                leftWall2.position.y = 188
                leftWall2.size.height = 40
                leftWall2.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: 0, y: -20))
                self.addChild(leftWall2)
            } else {
                rightWall2.position.y = 188
                rightWall2.size.height = 40
                rightWall2.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: 0, y: -20))
                self.addChild(rightWall2)
            }
            vstWall = !vstupDvereL ? 1 : 2
            vysWall = !vstupDvereL ? 3 : 4
            
            switch self.numRoom {
            case 36:
                putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -45 : 45,typ: .xxl)
                putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? 70 : -70,typ: .small)
                putPlosina(doVysky: 48, posunutPoX: !vstupDvereL ? 45 : -45,typ: .small)
            case 37:
                putPlosina(doVysky: 104, posunutPoX: 0,typ: .max)
                putRebrik(doVysky: 0, posunutPoX: !vstupDvereL ? 70 : -70, typ: .xl)
            case 38:
                putPlosina(doVysky: 48, posunutPoX: !vstupDvereL ? 60 : -60,typ: .large)    // y50
                putPlosina(doVysky: 104, posunutPoX: 0,typ: .small)
                putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? 90 : -90,typ: .small)
                putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -90 : 90,typ: .small)
            default:
                print("Hovadina na druhu")
            }
            //putPlosina(doVysky: 50, posunutPoX: !vstupDvereL ? 45 : -45,typ: .large)
            //putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -46 : 46,typ: .xxl)
            putElevator(poY: 112, poX: !vstupDvereL ? -130 : 130)
            stenaVstupDvere = !vstupDvereL ? 0 : 1
            stenaVystupDvere = !vstupDvereL ? 2 : 3
            vychodNaPravo = !vstupDvereL ? false : true  //skusim obidve true
            break
        //--jeden rebrik uroven 2
        case .jedenRebrik:
            let temp=SKSpriteNode(color: UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0), size: CGSize(width: 20, height: 2))
            temp.physicsBody=SKPhysicsBody(rectangleOf: temp.size)
            temp.physicsBody?.restitution = 0
            temp.physicsBody?.isDynamic = false
            self.addChild(temp)
            
            putPozadie(male: false, vyskaPredch: 0)
            putPozadie(male: false, vyskaPredch: 112)
            //vyska steny je bud 336 alebo 252
            switch self.numRoom {
            case 26,27,28,33,34,35,71:
                temp.position=CGPoint(x: !vstupDvereL ? -110 : 110, y: 110) //toto je jedno, len aby to nezavadzalo
                putStenu(typ: .lNormal, vyskaPredch: 0)
                putStenu(typ: .pNormal, vyskaPredch: 0)
                putStenu(typ: .lMalaCista, vyskaPredch: 112)
                putStenu(typ: .pMalaCista, vyskaPredch: 112)
                leftWall.position.y = 120
                leftWall.size.height = 128
                rightWall.position.y = 120
                rightWall.size.height = 128
                leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 64), to: CGPoint(x: 0, y: -64))
                rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 64), to: CGPoint(x: 0, y: -64))
                self.addChild(leftWall)
                self.addChild(rightWall)
                vstWall = !vstupDvereL ? 1 : 2
                vysWall = !vstupDvereL ? 2 : 1
                putElevator(poY: 0, poX: !vstupDvereL ? 130 : -130)
                stenaVstupDvere = !vstupDvereL ? 0 : 1
                stenaVystupDvere = !vstupDvereL ? 1 : 0
                self.posunutPlayerY=212
                vychodNaPravo = !vstupDvereL ? true : false
                switch self.numRoom {
                case 26,33:
                    //putPlosina(doVysky: 122, posunutPoX: !vstupDvereL ? 70 : -70,typ: .small)
                    putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -76 : 76,typ: .medium)
                    putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? 76 : -76,typ: .medium)
                    putRebrik(doVysky: 0,posunutPoX:!vstupDvereL ? -70 : 70,typ:.xl)
                case 27,34:
                    putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -22 : 22,typ: .xxxl)
                    putRebrik(doVysky: 0,posunutPoX:!vstupDvereL ? -70 : 70,typ:.xl)
                case 28,35,71:
                    putPlosina(doVysky: 108, posunutPoX: !vstupDvereL ? -22 : 22,typ: .xxxl)
                    putPlosina(doVysky: 50, posunutPoX: !vstupDvereL ? -34 : 34,typ: .small)
                    putStlp(vyskaPredch: 0, posunutPoX: 0)
                default:
                    print("Dovi")
                }
            case 29,31,32,78,73,74,75,76:
                temp.position=CGPoint(x: !vstupDvereL ? -110 : 110, y: 110)
                putStenu(typ: !vstupDvereL ? .lNormal : .lCista, vyskaPredch: 0)
                putStenu(typ: !vstupDvereL ? .pCista : .pNormal, vyskaPredch: 0)
                putStenu(typ: !vstupDvereL ? .lMalaNormal : .lMalaCista, vyskaPredch: 112)
                putStenu(typ: !vstupDvereL ? .pMalaCista : .pMalaNormal, vyskaPredch: 112)
                leftWall.position.y = !vstupDvereL ? 83 : 90
                leftWall.size.height = !vstupDvereL ? 54 : 180
                rightWall.position.y = !vstupDvereL ? 90 : 83
                rightWall.size.height = !vstupDvereL ? 180 : 54
                leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: !vstupDvereL ? 27 : 90), to: CGPoint(x: 0, y: !vstupDvereL ? -27 : -90))
                rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: !vstupDvereL ? 90 : 27), to: CGPoint(x: 0, y: !vstupDvereL ? -90 : -27))
                self.addChild(leftWall)
                self.addChild(rightWall)
                if !vstupDvereL {
                    leftWall2.position.y = 178
                    leftWall2.size.height = 20
                    self.addChild(leftWall2)
                    leftWall2.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 10), to: CGPoint(x: 0, y: -10))
                } else {
                    rightWall2.position.y = 178
                    rightWall2.size.height = 20
                    self.addChild(rightWall2)
                    rightWall2.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 10), to: CGPoint(x: 0, y: -10))
                }
                vstWall = !vstupDvereL ? 1 : 2
                vysWall = !vstupDvereL ? 3 : 4
                switch self.numRoom {
                case 29,31,73,74,75,76:
                    putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -22 : 22,typ: .xxxl)
                    //putPlosina(doVysky: 36, posunutPoX: !vstupDvereL ? 88 : -88,typ: .small)
                    putPlosina(doVysky: 52, posunutPoX: !vstupDvereL ? 88 : -88,typ: .small)
                case 32,78:
                    putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? 0 : 0,typ: .max)
                    putRebrik(doVysky: 0,posunutPoX:!vstupDvereL ? 70 : -70,typ:.xl)
                default:
                    putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? -22 : 22,typ: .xxxl)
                    //putPlosina(doVysky: 36, posunutPoX: !vstupDvereL ? 88 : -88,typ: .small)
                    putPlosina(doVysky: 52, posunutPoX: !vstupDvereL ? 88 : -88,typ: .small)
                    
                }
                putElevator(poY: 112, poX: !vstupDvereL ? -130 : 130)
                vychodNaPravo = !vstupDvereL ? false : true
                stenaVstupDvere = !vstupDvereL ? 0 : 1
                stenaVystupDvere = !vstupDvereL ? 2 : 3
            case 30,72,77:
                temp.position=CGPoint(x: !vstupDvereL ? 110 : -110, y: 110)
                putStenu(typ: !vstupDvereL ? .lNormal : .lCista, vyskaPredch: 0)
                putStenu(typ: !vstupDvereL ? .pCista : .pNormal, vyskaPredch: 0)
                putStenu(typ: !vstupDvereL ? .lMalaCista : .lMalaNormal, vyskaPredch: 112)
                putStenu(typ: !vstupDvereL ? .pMalaNormal : .pMalaCista, vyskaPredch: 112)
                leftWall.position.y = !vstupDvereL ? 121 : 54
                leftWall.size.height = !vstupDvereL ? 130 : 110
                rightWall.position.y = !vstupDvereL ? 54 : 121
                rightWall.size.height = !vstupDvereL ? 110 : 130
                leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: !vstupDvereL ? 65 : 55), to: CGPoint(x: 0, y: !vstupDvereL ? -65 : -55))
                rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: !vstupDvereL ? 55 : 65), to: CGPoint(x: 0, y: !vstupDvereL ? -55 : -65))
                self.addChild(leftWall)
                self.addChild(rightWall)
                if !vstupDvereL {
                    rightWall2.position.y = 178
                    rightWall2.size.height = 20
                    self.addChild(rightWall2)
                    rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 10), to: CGPoint(x: 0, y: -10))
                } else {
                    leftWall2.position.y = 178
                    leftWall2.size.height = 20
                    self.addChild(leftWall2)
                    leftWall2.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 10), to: CGPoint(x: 0, y: -10))
                }
                vstWall = !vstupDvereL ? 1 : 2
                vysWall = !vstupDvereL ? 4 : 3
                
                putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? 0 : 0,typ: .max)
                putRebrik(doVysky: 0,posunutPoX:!vstupDvereL ? 70 : -70,typ:.xl)
                putElevator(poY: 112, poX: !vstupDvereL ? 130 : -130)
                vychodNaPravo = !vstupDvereL ? true : false
                stenaVstupDvere = !vstupDvereL ? 0 : 1
                stenaVystupDvere = !vstupDvereL ? 3 : 2
            default:
                temp.position=CGPoint(x: !vstupDvereL ? 110 : -110, y: 110)
                putStenu(typ: !vstupDvereL ? .lNormal : .lCista, vyskaPredch: 0)
                putStenu(typ: !vstupDvereL ? .pCista : .pNormal, vyskaPredch: 0)
                putStenu(typ: !vstupDvereL ? .lMalaCista : .lMalaNormal, vyskaPredch: 112)
                putStenu(typ: !vstupDvereL ? .pMalaNormal : .pMalaCista, vyskaPredch: 112)
                putPlosina(doVysky: 104, posunutPoX: !vstupDvereL ? 0 : 0,typ: .max)
                putRebrik(doVysky: 0,posunutPoX:!vstupDvereL ? 20 : -20,typ:.xl)
                putElevator(poY: 112, poX: !vstupDvereL ? 130 : -130)
                vychodNaPravo = !vstupDvereL ? true : false
                stenaVstupDvere = !vstupDvereL ? 0 : 1
                stenaVystupDvere = !vstupDvereL ? 3 : 2
                
            }
            
            break
        case .prizemie:
            putPrizemie(vyskaPredch: 0)
            putElevator(poY: 0, poX: 0)
            elevator.physicsBody?.categoryBitMask = dverePressCategory
            vychodNaPravo = false
        case .ciste:
            putCistePozadie(vyskaPredch: 0)
            vychodNaPravo = !vstupDvereL ? true : false
        case .klenbaCele:
            putPozadie(male: false, vyskaPredch: 0)
            putStenu(typ: .klenbaCela, vyskaPredch: 0)
            putBrana(vyskaPredch: 0, typ: .dvere, posunutPoX: 0)
            podlahy[0].texture=atlas.textureNamed("Podlaha_hore")
            //podlahy[0].removeFromParent()   //test 53
            putPlosina(doVysky: -8, posunutPoX: 0, typ: .xxxl)
            putElevator(poY: 0, poX: 0)
            elevator.physicsBody?.categoryBitMask=dverePressCategory
            vychodNaPravo = false
            //putRebrik(doVysky: -100, posunutPoX: 0, typ: .xl)    //test 53
            
        case .klenbaPolo:
            putPozadie(male: false, vyskaPredch: 0)
            putStenu(typ: !vstupDvereL ? .lNormal : .klenbaL, vyskaPredch: 0)
            putStenu(typ: !vstupDvereL ? .klenbaP : .pNormal, vyskaPredch: 0)
            putBrana(vyskaPredch: 0, typ: .dvere, posunutPoX: !vstupDvereL ? 40 : -40)
            putElevator(poY: 0, poX: !vstupDvereL ? 40 : -40)
            elevator.physicsBody?.categoryBitMask=dverePressCategory
            vychodNaPravo = true
            vychodNaPravo = !vstupDvereL ? true : false
            //putPodlaha(dlzka: nil, doVysky: 0, posunutPoX: 0)
            stenaVstupDvere = !vstupDvereL ? 0 : 1
            stenaVystupDvere = -1
            
            if !vstupDvereL {
                leftWall.position.y = 76
                leftWall.size.height = 40
                leftWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: 0, y: -20))
                self.addChild(leftWall)
            } else {
                rightWall.position.y = 76
                rightWall.size.height = 40
                rightWall.physicsBody=SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 20), to: CGPoint(x: 0, y: -20))
                self.addChild(rightWall)
            }
            vstWall = !vstupDvereL ? 1 : 2
        }
        
        controlVyska()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func controlVyska() {
        switch typ {
        case .ciste, .prizemie, .klenbaCele, .klenbaPolo:
            vyskaIzby=112
        case .klasika:
            vyskaIzby=steny[0].zaklad.size.height
        case .jedenRebrik, .dvojty:
            vyskaIzby=steny[0].zaklad.size.height + steny[2].zaklad.size.height
        case .bossRoom:
            let x:CGFloat = steny[0].zaklad.size.height + steny[2].zaklad.size.height + steny[4].zaklad.size.height
            let y:CGFloat = steny[6].zaklad.size.height + (numRoom==48 ? steny[8].zaklad.size.height : 0)
            vyskaIzby = x + y
        }
        print("Boss-\(numRoom)")
        print("Control vyska \(vyskaIzby)")
    }
    func getVyska() -> CGFloat{
        return vyskaIzby
    }
    func vychodNaPravoF() -> Bool {
        return vychodNaPravo
    }
    
    func zatvoritDvere(vstupne:Bool) {
        switch vstupne ? vstWall : vysWall {
        case 0:
            print("Nothing")
        case 1:
            leftWall.run(.moveBy(x: 0, y: -20, duration: 0.5))
        case 2:
            rightWall.run(.moveBy(x: 0, y: -20, duration: 0.5))
        case 3:
            leftWall2.run(.moveBy(x: 0, y: -20, duration: 0.5))
        case 4:
            rightWall2.run(.moveBy(x: 0, y: -20, duration: 0.5))
        default:
            print("Nist")
        }

    }
    
    
    
    //-----------
    //----PUT----
    
    private func
        putPlosina(doVysky:Int,posunutPoX:Int,typ:typPlosina) {
        plosiny.append(Plosina(texture: nil, color: nil, size: nil, doVysky: doVysky,posunutPoX:posunutPoX,typ:typ))
        plosiny[plosiny.count-1].name="Plos\(plosiny.count-1)"
        self.addChild(plosiny[plosiny.count-1])
    }
    
    private func putPozadie(male:Bool,vyskaPredch:Int) {
        pozadie.append(Pozadie(texture: nil, color: nil, size: nil, male: male, vyskaPredch: vyskaPredch))
        self.addChild(pozadie[pozadie.count-1])
    }
    
    private func putStenu(typ:stenyTyp,vyskaPredch:Int) {
        steny.append(Stena(typ:typ, vyskaPredch: vyskaPredch))
        self.addChild(steny[steny.count-1])
    }
    
    private func putPodlaha(dlzka:Int?,doVysky:Int,posunutPoX:Int) {
        podlahy.append(Podlaha(texture: nil, color: nil, size: nil, dlzka: dlzka, doVysky: doVysky, posunutPoX: posunutPoX))
        self.addChild(podlahy[podlahy.count-1])
    }
    
    private func putRebrik(doVysky:Int, posunutPoX:Int,typ:typRebrik) {
        rebriky.append(Rebrik(texture: nil, color: nil, size: nil, doVysky:doVysky, posunutPoX:posunutPoX,typ:typ))
        self.addChild(rebriky[rebriky.count-1])
    }
    
    private func putCistePozadie(vyskaPredch:Int) {
        cPozadie.append(CistePozadie(texture: nil, color: nil, size: nil, vyskaPredch: vyskaPredch))
        self.addChild(cPozadie[cPozadie.count-1])
    }
    
    private func putPrizemie(vyskaPredch:Int) {
        prizemie.append(Prizemie(texture: nil, color: nil, size: nil, vyskaPredch: vyskaPredch))
        self.addChild(prizemie[prizemie.count-1])
    }
    
    private func putBrana(vyskaPredch:Int,typ:typDvere,posunutPoX:Int) {
        brana.append(Brana(texture: nil, color: nil, size: nil, vyskaPredch: vyskaPredch, typ: typ,posunutPoX:posunutPoX))
        self.addChild(brana[brana.count-1])
    }
    
    private func putStlp(vyskaPredch:Int,posunutPoX:Int) {
        stlpy.append(Stlp(texture: nil, color: nil, size: nil, vyskaPredch: vyskaPredch, posunutPoX:posunutPoX))
        self.addChild(stlpy[stlpy.count-1])
    }
    private func putElevator(poY:Int,poX:Int) {
        self.elevator.changePos(x: 0 + poX, y: 20 + poY)
        self.addChild(elevator)
    }
    private func putFace(poX:Int,poY:Int,typ:Int) {
        bossFace.append(BossFace(texture: nil, color: nil, size: nil, posunutPoX: poX, posunutPoY: poY, typ: typ))
        self.addChild(bossFace[bossFace.count-1])
    }
    
}
