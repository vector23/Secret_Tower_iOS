//
//  GameScene.swift
//  Rytier
//
//  Created by Juraj Kebis on 17/03/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//

import SpriteKit
import UIKit
import AudioToolbox
import AVFoundation

var updateFromGame:Bool=false

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var zvuky:Zvuky
    
    var comesFromBackground:Bool=false
    var diedForDelegate:Bool=false
    var cantTouch:Bool=false
    var rytierJePodHradom:Bool=true
    
    var startingShade:SKSpriteNode?
    var hrad:Hrad
    var kopce:Kopce?
    var hory:Hory?
    var rytier:Player3
    var rytierDeath:PlayerDeath?
    var rytierPosBeforeDeath:CGPoint?
    var rytierWasRevived:Int=0
    var blackScreen:SKSpriteNode?
    
    var mincaPlus:SKLabelNode?
    
    var pocetMinci:SKLabelNode?
    var mincaRotAnim:[SKTexture]=[]
    var mincaLeskAnim:[SKTexture]=[]
    let atlasMenu=SKTextureAtlas(named: "Menu")
    let atlasMinca=SKTextureAtlas(named: "MincaMenu")
    let atlasGameB=SKTextureAtlas(named: "GameButtons")
    var atlasRytN=SKTextureAtlas(named: "Nohy1")
    var atlasRytT=SKTextureAtlas(named: "Telo1")
    var atlasPausDeath=SKTextureAtlas(named: "PauseOrDeath")
    
    var mincaRotuje:Bool=false
    var minceSuUkazane:Bool=false
    var jeNajvyssieSkore:Bool=false
    var score:SKLabelNode?
    var srdce:SrdceBoss?
    var numeroMince:Int=UserDefaults.standard.integer(forKey: "CoinsAbsolute")
    //var deathScreen:EndGame?
    var reset:Bool=false
    var resetRebrik:Bool=false
    var strokeTextAttributes = [
             NSAttributedString.Key.strokeColor : UIColor.black,
             NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 1, green: 0.95, blue: 0.82, alpha: 1),
             NSAttributedString.Key.strokeWidth : -4.0,
             NSAttributedString.Key.font : UIFont(name: "Kebis_Numbers_BIT", size: 160)!]
             as [NSAttributedString.Key : Any]
    var minceTextAttributes = [
             NSAttributedString.Key.strokeColor : UIColor(displayP3Red: 1, green: 0.95, blue: 0.82, alpha: 1),
             NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 1, green: 0.95, blue: 0.82, alpha: 1),
             NSAttributedString.Key.strokeWidth : 0.0,
             NSAttributedString.Key.font : UIFont(name: "Kebis_Numbers_BIT", size: 40)!]
             as [NSAttributedString.Key : Any]
    var textTutorial:SKLabelNode?
    var showTopBar:Bool=false
    
    //--ovladanie
    var controlis:SKNode?
    var left:SKSpriteNode?
    var right:SKSpriteNode?
    var jump:SKSpriteNode?
    var shoot:SKSpriteNode?
    var medzi:SKSpriteNode?
    
    var loadingScreen:SKNode?
    var loadMec:SKSpriteNode?
    
    var topBar:SKNode?
    var pauseButton:SKSpriteNode?
    var mincen:SKSpriteNode?
    var mincenL:SKSpriteNode?
    var mPocet:SKLabelNode?
    //--pause menu
    var pauseM:SKNode?
    var hlavne:SKNode?
    var settingsP:SKNode?
    var tabulaP:SKSpriteNode?
    var resumeB:SKSpriteNode?
    var resumeT:SKLabelNode?
    var resumeTPos:CGPoint?
    var settingsB:SKSpriteNode?
    var optionsT:SKLabelNode?
    var optionsTPos:CGPoint?
    var restartB:SKSpriteNode?
    var restartT:SKLabelNode?
    var restartTPos:CGPoint?
    var menuB:SKSpriteNode?
    var menuT:SKLabelNode?
    var menuTPos:CGPoint?
    var backB:SKSpriteNode?
    var backIm:SKSpriteNode?
    var backImPos:CGPoint?
    var musicB:SKSpriteNode?
    var audioB:SKSpriteNode?
    var musicIm:SKSpriteNode?
    var audioIm:SKSpriteNode?
    var musicImPos:CGPoint?
    var audioImPos:CGPoint?
    var musicT:SKLabelNode?
    var audioT:SKLabelNode?
    //cierne pozadie
    var blackBac:SKSpriteNode?
    //--continue
    var continueT:SKNode?
    var xButton:SKSpriteNode?
    var tabulisRevive:SKSpriteNode?
    var buttonRevive:SKSpriteNode?
    var payCoinsB:SKSpriteNode?
    var labelPayC:SKSpriteNode?
    var labelPayCPos:CGPoint?
    //--death
    var deathScreen:SKNode?
    var normalScore:SKNode?
    var highScore:SKNode?
    var hrob:SKSpriteNode?
    var backH:SKSpriteNode?
    var retryH:SKSpriteNode?
    var scoreH:SKLabelNode?
    var HscoreH:SKLabelNode?
    var HScoreLabel:SKLabelNode?
    var scoreHigh:SKLabelNode?
    var HighScoreLabel:SKLabelNode?
    //--buy
    var buyTable:SKNode?
    var cancelBuy:SKSpriteNode?
    var smallBuy:SKSpriteNode?
    var mediumBuy:SKSpriteNode?
    var largeBuy:SKSpriteNode?
    
    var zablokovatTouch:Bool=false
    var dvereArePressing:Bool=false
    var dvereBlocked:Bool=false
    var mrtvyHrac:Bool=false
    var killedPlayer:Bool=false//--toto len aby 2krat po sebe sa rychlo nespustila death funkcia
    var enemyFirStr:String=""   //--zapametat si meno enemy na ktorej mam mec
    var enemyFirCis:String=""
    var enemySecStr:String=""
    var enemySecCis:String=""
    var rytierNaPlamen:Ohen?
    var rytierNaOheni:Bool=false
    var rytierNaPich:Pasca?
    var rytierNaPasci:Bool=false
    
    
    // MARK: OVERRIDE INIT
    override init() {
        zvuky=Zvuky()
        hrad = Hrad()
        hrad.createHrad()
        rytier=Player3(texture: nil, color: .white, size: nil, pos: CGPoint(x:-170, y: 15),revive: false, skin: UserDefaults.standard.integer(forKey: "PickedSkinAbsolute")+1)  // povodna position -70, 15
        super.init()
        self.addChild(hrad)
        //hrad?.setScale(0.35)    //---0.45
        hrad.addChild(rytier)
        mrtvyHrac=false
        self.hrad.mrtvyHrac=false
        
    }
    required init?(coder aDecoder: NSCoder) {
        zvuky=Zvuky()
        hrad = Hrad()
        hrad.createHrad()
        rytier=Player3(texture: nil, color: .white, size: nil, pos: CGPoint(x:-170, y: 15),revive: false, skin: UserDefaults.standard.integer(forKey: "PickedSkinAbsolute")+1)  // povodna position -70, 15
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        self.addChild(hrad)
        hrad.addChild(rytier)
        mrtvyHrac=false
        self.hrad.mrtvyHrac=false
    }
    
    // MARK: DID MOVE
    override func didMove(to view: SKView) {
        setBackgroundColor()
        //self.scaleMode=.fill
        print(self.size)
        //----ZAKLADNE----
        
        self.view?.isMultipleTouchEnabled=true
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -4.7)
        
        controlis = self.childNode(withName: "Controls")
        controlis?.zPosition = 81
        
        //----OVLADANIE----
        left = self.controlis!.childNode(withName: "Left") as? SKSpriteNode
        right = self.controlis!.childNode(withName: "Right") as? SKSpriteNode
        jump = self.controlis!.childNode(withName: "Up") as? SKSpriteNode
        shoot = self.controlis!.childNode(withName: "Shoot") as? SKSpriteNode
        medzi = self.controlis?.childNode(withName: "Medzi") as? SKSpriteNode
        controlis?.isHidden=true
        
        //---loading screen---
        loadingScreen = self.childNode(withName: "LoadingScreen")
        loadMec = self.loadingScreen?.childNode(withName: "LoadMec") as? SKSpriteNode
        loadMec?.run(.repeat(.rotate(byAngle: CGFloat(-(3.14)*2), duration: 0.8), count: 3), completion: {
            self.loadingScreen?.isHidden=true
        })
        
        topBar = self.childNode(withName: "TopBar")
        pauseButton = self.topBar?.childNode(withName: "Pause") as? SKSpriteNode
        pauseButton?.name = "PauseB"
        mincen = self.topBar?.childNode(withName: "Minca") as? SKSpriteNode
        mincen?.name="Minca"
        mincenL = self.topBar?.childNode(withName: "MLesk") as? SKSpriteNode
        mincenL?.name="MLesk"
        mPocet = self.topBar?.childNode(withName: "PocetM") as? SKLabelNode
        mPocet?.run(.fadeOut(withDuration: 0))
        mPocet?.attributedText=NSMutableAttributedString(string: String(numeroMince), attributes: minceTextAttributes)
        /*
        mPocet?.fontName="Kebis_Numbers_BIT"
        mPocet?.fontSize=54
        mPocet?.fontColor = SKColor.black
        mPocet?.text=String(numeroMince)
        */
        //mPocet.zPosition=103
        
        //----PAUSE----
        pauseM=self.childNode(withName: "PauseMenu")
        tabulaP=self.pauseM?.childNode(withName: "TabP") as? SKSpriteNode
        tabulaP?.name="TabulaPause"
        settingsP=self.pauseM?.childNode(withName: "Settings")
        hlavne=self.pauseM?.childNode(withName: "Hlavne")
        resumeB=self.hlavne?.childNode(withName: "Resume") as? SKSpriteNode
        resumeB?.name="ResumeB"
        resumeT=self.resumeB?.childNode(withName: "ResumeText") as? SKLabelNode
        resumeT?.name="ResumeText"
        resumeTPos=resumeT?.position
        resumeT?.fontName="Kebis_BIT-Regular"
        resumeT?.fontColor=UIColor.black
        resumeT?.fontSize=28
        resumeT?.xScale=0.9
        resumeT?.text=NSLocalizedString("Resume", comment: "")
        settingsB=self.hlavne?.childNode(withName: "Options") as? SKSpriteNode
        settingsB?.name="Options"
        optionsT=self.settingsB?.childNode(withName: "OptionsText") as? SKLabelNode
        optionsT?.name="OptionsText"
        optionsTPos=optionsT?.position
        optionsT?.fontName="Kebis_BIT-Regular"
        optionsT?.fontColor=UIColor.black
        optionsT?.fontSize=26
        optionsT?.xScale=0.8
        optionsT?.text=NSLocalizedString("Options", comment: "")
        restartB=self.hlavne?.childNode(withName: "Restart") as? SKSpriteNode
        restartB?.name="Restart"
        restartT=self.restartB?.childNode(withName: "RestartText") as? SKLabelNode
        restartT?.name="RestartText"
        restartTPos=restartT?.position
        restartT?.fontName="Kebis_BIT-Regular"
        restartT?.fontColor=UIColor.black
        restartT?.fontSize=26
        restartT?.xScale=0.8
        restartT?.text=NSLocalizedString("Restart", comment: "")
        menuB=self.hlavne?.childNode(withName: "Menu") as? SKSpriteNode
        menuB?.name="Menu"
        menuT=self.menuB?.childNode(withName: "MenuText") as? SKLabelNode
        menuT?.name="MenuText"
        menuTPos=menuT?.position
        menuT?.fontName="Kebis_BIT-Regular"
        menuT?.fontColor=UIColor.black
        menuT?.fontSize=28
        menuT?.xScale=1
        menuT?.text=NSLocalizedString("Menu", comment: "")
        backB=self.settingsP?.childNode(withName: "Back") as? SKSpriteNode
        backB?.name="Back"
        backIm=self.backB?.childNode(withName: "Backs") as? SKSpriteNode
        backIm?.name="Backs"
        backImPos=backIm?.position
        musicB=self.settingsP?.childNode(withName: "Music") as? SKSpriteNode
        musicB?.name="Music"
        musicIm=self.musicB?.childNode(withName: "Musics") as? SKSpriteNode
        musicIm?.name="Musics"
        musicImPos=musicIm?.position
        audioB=self.settingsP?.childNode(withName: "Audio") as? SKSpriteNode
        audioB?.name="Audio"
        audioIm=self.audioB?.childNode(withName: "Volume") as? SKSpriteNode
        audioIm?.name="Volume"
        audioImPos=audioIm?.position
        musicT=self.settingsP?.childNode(withName: "MusicText") as? SKLabelNode
        musicT?.name="MusicText"
        musicT?.fontName="Kebis_BIT-Regular"
        musicT?.fontColor=UIColor.black
        musicT?.fontSize=24
        musicT?.xScale=1
        audioT=self.settingsP?.childNode(withName: "AudioText") as? SKLabelNode
        audioT?.name="AudioText"
        audioT?.fontName="Kebis_BIT-Regular"
        audioT?.fontColor=UIColor.black
        audioT?.fontSize=24
        audioT?.xScale=1
        musicIm?.texture=atlasMenu.textureNamed(UserDefaults.standard.bool(forKey: "MusicOn") ? "MusicYes" : "MusicNo")
        musicT?.text = UserDefaults.standard.bool(forKey: "MusicOn") ? NSLocalizedString("MusicOn", comment: "") : NSLocalizedString("MusicOff", comment: "")
        audioIm?.texture=atlasMenu.textureNamed(UserDefaults.standard.bool(forKey: "AudioOn") ? "Volume" : "VolumeNo")
        audioT?.text = UserDefaults.standard.bool(forKey: "AudioOn") ? NSLocalizedString("AudioOn", comment: "") : NSLocalizedString("AudioOff", comment: "")
        
        pauseM?.isHidden=true
        //---BLACK---
        blackScreen=self.childNode(withName: "BlackScreen") as? SKSpriteNode
        blackScreen?.run(.wait(forDuration: 0.2),completion: {
            self.blackScreen?.run(.fadeOut(withDuration: 0.3))
        })
        //----CONTI----
        continueT=self.childNode(withName: "Continue")
        continueT?.isHidden=true
        xButton=self.continueT?.childNode(withName: "X") as? SKSpriteNode
        xButton?.name="X"
        payCoinsB=self.continueT?.childNode(withName: "PayCoins") as? SKSpriteNode
        payCoinsB?.name="PayCoins"
        labelPayC=self.payCoinsB?.childNode(withName: "TextPay") as? SKSpriteNode
        labelPayC?.name="TextPay"
        labelPayCPos=labelPayC?.position
        tabulisRevive=self.continueT?.childNode(withName: "TabCon") as? SKSpriteNode
        tabulisRevive?.name="TabCon"
        //----END----
        deathScreen=self.childNode(withName: "DeathScreen")
        normalScore=self.deathScreen?.childNode(withName: "NormalScore")
        highScore=self.deathScreen?.childNode(withName: "HighestScore")
        hrob=self.deathScreen?.childNode(withName: "Hrob") as? SKSpriteNode
        backH=self.deathScreen?.childNode(withName: "BackH") as? SKSpriteNode
        backH?.name="BackH"
        retryH=self.deathScreen?.childNode(withName: "RetryH") as? SKSpriteNode
        retryH?.name="RetryH"
        scoreH=self.normalScore?.childNode(withName: "ScoreH") as? SKLabelNode
        scoreH?.name="ScoreH"
        HscoreH=self.normalScore?.childNode(withName: "HScoreH") as? SKLabelNode
        HscoreH?.name="HScoreH"
        HScoreLabel=self.normalScore?.childNode(withName: "HighScoreLabel") as? SKLabelNode
        HScoreLabel?.name="HighScoreLabel"
        scoreH?.fontName="Kebis_Numbers_BIT"
        scoreH?.fontColor=UIColor.black
        scoreH?.fontSize=124
        //scoreH?.xScale=0.6
        HscoreH?.fontName="Kebis_Numbers_BIT"
        HscoreH?.fontColor=UIColor.black
        HscoreH?.fontSize=40
        //HscoreH?.xScale=0.6
        HScoreLabel?.fontName="Kebis_BIT-Regular"
        HScoreLabel?.fontColor=UIColor.black
        HScoreLabel?.fontSize=18
        //HScoreLabel?.xScale=0.6
        
        scoreHigh=self.highScore?.childNode(withName: "ScoreHigh") as? SKLabelNode
        HighScoreLabel=self.highScore?.childNode(withName: "HighScoreLabel2") as? SKLabelNode
        scoreHigh?.fontName="Kebis_Numbers_BIT"
        scoreHigh?.fontColor=UIColor.black
        scoreHigh?.fontSize=124
        
        //scoreHigh?.attributedText=NSMutableAttributedString(string: "", attributes: strokeTextAttributes)
        HighScoreLabel?.fontName="Kebis_BIT-Regular"
        HighScoreLabel?.fontColor=UIColor.black
        HighScoreLabel?.fontSize=28
        
        //--buy
        buyTable=self.childNode(withName: "BuyMince")
        buyTable?.name="BuyMince"
        cancelBuy=self.buyTable?.childNode(withName: "CancelBuy") as? SKSpriteNode
        cancelBuy?.name="CancelBuy"
        smallBuy=self.buyTable?.childNode(withName: "BuyS") as? SKSpriteNode
        smallBuy?.name="BuyS"
        mediumBuy=self.buyTable?.childNode(withName: "BuyM") as? SKSpriteNode
        mediumBuy?.name="BuyM"
        largeBuy=self.buyTable?.childNode(withName: "BuyL") as? SKSpriteNode
        largeBuy?.name="BuyL"
        buyTable?.isHidden=true
        
        //--BLACK
        blackBac=self.childNode(withName: "BlackBac") as? SKSpriteNode
        blackBac?.isHidden=true
        
        
        setTexturesForMinca()
        mincaLeskAction() // (radsej vypnut lebo rekurzia) uz nie
        setScore()
        //mincePocet()
        
        initKopceHory()
        
        //--schovat top bar
        topBar?.run(.moveBy(x: 0, y: 160, duration: 0))
        
        // ----  SET GAME  ----
        switch UserDefaults.standard.string(forKey: "ZaciatokHry") {
        //-- tutorial
        //-----------
        //-- 3 fazy / prva: v
        case "\(ZaciatokHry.tutorial)":
            rytierJePodHradom=true
            textTutorial=SKLabelNode(text: "MOVE RIGHT AND LEFT")
            textTutorial?.fontName="Kebis_BIT-Regular"
            textTutorial?.fontSize=26
            textTutorial?.fontColor = .white
            self.addChild(textTutorial!)
            textTutorial?.position.x = 0
            textTutorial?.position.y = 140
            textTutorial?.zPosition = 120
            textTutorial?.isHidden=true
            textTutorial?.run(.wait(forDuration: 5),completion: {
                self.textTutorial?.isHidden=false
                self.textTutorial?.run(.wait(forDuration: 3),completion: {
                    //self.textTutorial?.isHidden=true
                })
            })
            
            let zoomInAction = SKAction.scale(to: 1.1, duration: 0)
            zoomInAction.timingMode = .easeOut
            let movCas = SKAction.moveBy(x: 100, y: 0, duration: 2)
            movCas.timingMode = .easeOut
            hrad.run(zoomInAction)  //zoom in
            rytier.run(.moveBy(x: -1040, y: 0, duration: 0))
            hrad.run(.moveBy(x: 1100, y: 0, duration: 0))   //1446
            hrad.run(movCas)
            hrad.run(.wait(forDuration: 3),completion: {
                self.rytier.characterMove(left: false)
                self.rytier.run(.wait(forDuration: 1),completion: {
                    self.rytier.characterCancelMove(left: false)
                    self.rytier.run(.wait(forDuration: 0.6),completion: {
                        self.jump?.isHidden=true
                        self.shoot?.isHidden=true
                        self.controlis?.isHidden=false
                        self.hrad.hranicaL?.run(.moveBy(x: 88, y: 0, duration: 0))
                    })
                })
                /*
                self.hrad.run(.moveBy(x: -1000, y: 0, duration: 6),completion: {
                    self.topBar?.run(.moveBy(x: 0, y: -160, duration: 0.8))
                })
                */
            })
            dvereBlocked=true
            print("Tutorial")
        case "\(ZaciatokHry.normal)":
            rytierJePodHradom=false
            rytier.position.x = -80
            self.rytier.xScale = -1
            hrad.hranicaL?.run(.moveTo(x: -210, duration: 0))
            self.run(.wait(forDuration: 0.0),completion: {
                let down=SKAction.moveBy(x: 0, y: -160, duration: 0.5)
                down.timingMode = .easeOut
                self.topBar?.run(down)
                self.controlis?.run(.fadeOut(withDuration: 0))
                self.controlis?.isHidden=false
                self.controlis?.run(.fadeIn(withDuration: 0))
            })
            rytier.position.y=rytier.position.y+112
            
            rytier.isHidden=false
            rytier.characterMove(left: false)
            self.run(.wait(forDuration: 0.01), completion: {
                self.rytier.removeAllActions()
                self.rytier.characterCancelMove(left:false)
                self.rytier.zablokovaneAkcie=false
            })
            
            self.hrad.addFloor2()
            
            let goUp2 = SKAction.move(by: CGVector(dx: 0, dy: 30), duration: 0)   //12
            self.hrad.run(goUp2)
            
            let first = SKAction.move(by: CGVector(dx: 0, dy: -110 * 1.0), duration: 0.0)  //1.4
            self.hrad.run(first)
            hrad.poschodia[self.hrad.currentLevel].steny[0].zatvoritDvere()
            self.hrad.poschodia[self.hrad.currentLevel].zatvoritDvere(vstupne: true)
            
            self.rytier.onPlosina = false
            self.hrad.score = self.hrad.score + 1
            //self.score?.text="\(self.hrad!.score)"
            self.score?.attributedText = NSMutableAttributedString(string: "\(self.hrad.score)", attributes: strokeTextAttributes)
            rytier.setCollisionPlosina(collisionOn: false) //treba lebo naraza ked pride na druhe poschodie
            dvereArePressing=false
            
            print("Normal")
        case "\(ZaciatokHry.finish)":   //zatial nic
            rytierJePodHradom=true
            hrad.hranicaL?.run(.moveTo(x: -210, duration: 0))
            self.run(.wait(forDuration: 0.6),completion: {
                let down=SKAction.moveBy(x: 0, y: -160, duration: 0.5)
                down.timingMode = .easeOut
                //self.topBar?.run(down)
                self.controlis?.run(.fadeOut(withDuration: 0))
                self.controlis?.isHidden=false
                self.controlis?.run(.fadeIn(withDuration: 0.5))
            })
            
            print("Finish")
        case "\(ZaciatokHry.startNormal)":
            rytierJePodHradom=true
            moveCastle()
        default:
            print("Chyba, nacitat zaciatok hry(GameScene-didMove)")
        }
        //createStartingFade()
        //fadeStart()
        //moveCastle()        //prerobit
        
    }
    func setBackgroundColor() {
        var colorR=0
        var colorG=0
        var colorB=0
        switch UserDefaults.standard.integer(forKey: "PickedSkinAbsolute") {
            case 0:
                colorR=130
                colorG=0
                colorB=0
            case 1:
                colorR=172   //83
                colorG=132   //64
                colorB=67   //32
            case 2:
                colorR=38    //3
                colorG=114   //70
                colorB=83   //50
            case 3:
                colorR=39     //35
                colorG=64     //48
                colorB=119    //84
            case 4:
                colorR=123   //54
                colorG=123
                colorB=123
        default:
            print("p")
        }
        let temp:CGFloat = 1/255
        self.backgroundColor=UIColor(displayP3Red:(temp*CGFloat(colorR)), green: temp*CGFloat(colorG), blue: temp*CGFloat(colorB), alpha: 1)
    }
    func initKopceHory() {
        self.kopce=Kopce(texture: nil, color: .black, size: CGSize(width: 200, height: 100))
        self.addChild(kopce!)
        //self.kopce?.zPosition = -2
        //self.kopce?.size=CGSize(width: (self.kopce?.size.width)!*2, height: (self.kopce?.size.height)!*2)
        //self.kopce?.position=CGPoint(x: -43, y: 0)   //   SPRAVNE ALE CHCEM INE
        self.kopce?.position=CGPoint(x: +43, y: 50)  //43 , -50
        self.hory=Hory(texture: nil, color: .black, size: CGSize(width: 500, height: 736))
        self.addChild(hory!)
        //self.hory?.zPosition = -3
        //self.hory?.size=CGSize(width: (self.hory?.size.width)!/2, height: (self.hory?.size.height)!/2)
        //self.hory?.position=CGPoint(x: -43, y: 0)   //   SPRAVNE ALE CHCEM INE
        self.hory?.position=CGPoint(x: +43, y: 40)   //43 , -20
        
    }
    func mincePocet() {
        self.pocetMinci=SKLabelNode(fontNamed: "Kebis_BIT-Regular")
        self.pocetMinci?.position=CGPoint(x: -300, y: 550)
        self.pocetMinci?.fontSize=80
        self.pocetMinci?.fontColor = SKColor.black
        self.pocetMinci?.text="\(UserDefaults.standard.integer(forKey: "CoinsAbsolute"))"
        self.addChild(pocetMinci!)
        self.pocetMinci?.zPosition=103
    }
    
    func setTexturesForMinca() {
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk1"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk2"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk3"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk4"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk5"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk6"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk7"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk8"))
        mincaLeskAnim.append(atlasMinca.textureNamed( "mlesk9"))
        mincaLeskAnim.append(atlasMinca.textureNamed("mlesk10"))
        
        mincaRotAnim.append(atlasMinca.textureNamed("min1"))
        mincaRotAnim.append(atlasMinca.textureNamed("min2"))
        mincaRotAnim.append(atlasMinca.textureNamed("min3"))
        mincaRotAnim.append(atlasMinca.textureNamed("min4"))
        mincaRotAnim.append(atlasMinca.textureNamed("min5"))
        mincaRotAnim.append(atlasMinca.textureNamed("min6"))
        mincaRotAnim.append(atlasMinca.textureNamed("min7"))
    }
    func mincaLeskAction() {
        
        let group = DispatchGroup()
        group.enter()
        mincenL?.isHidden=false
        self.mincenL?.run(
        SKAction.animate(with: mincaLeskAnim,
                         timePerFrame: 0.04,
                         resize: false,
                         restore: true),
        completion: {
            //self.mincenL?.texture=SKTexture(imageNamed: "mlesk1")
            self.mincenL?.isHidden=true
        })
        self.run(.wait(forDuration: 2), completion: {
            DispatchQueue.main.async {
                group.leave()
            }
        })
        group.notify(queue: .main) {
            self.mincaLeskAction()
        }
    }
    func mincaRotate() {
        if !mincaRotuje {
            mincaRotuje=true
            let temp=SKAction.animate(with: mincaRotAnim,
            timePerFrame: 0.01,
            resize: false,
            restore: true)
            let temp2=SKAction.animate(with: mincaRotAnim,
            timePerFrame: 0.02,
            resize: false,
            restore: true)
            let temp3=SKAction.animate(with: mincaRotAnim,
            timePerFrame: 0.06,
            resize: false,
            restore: true)
            self.mincen?.run(temp,completion: {
                self.mincen?.run(temp,completion: {
                    self.mincen?.run(temp,completion: {
                        self.mincen?.run(temp2,completion: {
                            self.mincen?.run(temp2,completion: {
                                self.mincen?.run(temp3,completion: {
                                    self.mincaRotuje=false
                                })
                            })
                        })
                    })
                })
            })
        }
        
    }
    func setScore() {
        self.score=self.topBar!.childNode(withName: "Score") as? SKLabelNode
        //self.score=SKLabelNode(fontNamed: "Avenir-Medium")
        self.score?.fontName="Kebis_Numbers_BIT"
        //self.score?.position=CGPoint(x: 0, y: 550)
        self.score?.fontSize=140
        self.score?.fontColor = SKColor.black//(displayP3Red: 1.0, green: 0.956, blue: 0.823, alpha: 1)
        self.score?.text="0"
        //skuska --
        self.score?.xScale=0.9
        /*let strokeTextAttributes = [
          NSAttributedString.Key.strokeColor : UIColor.black,
          NSAttributedString.Key.foregroundColor : UIColor.white,
          NSAttributedString.Key.strokeWidth : -5.0,
          NSAttributedString.Key.font : UIFont(name: "Kebis_Numbers_BIT", size: 160)]
          as [NSAttributedString.Key : Any]
         */
        self.score?.attributedText = NSMutableAttributedString(string: "0", attributes: strokeTextAttributes)
        
    }
    
    func createStartingFade() {
        self.startingShade=SKSpriteNode()
        self.startingShade!.size=CGSize(width:self.frame.size.width, height:self.frame.size.height)
        self.startingShade!.color=UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.startingShade!.position=CGPoint(x: 0, y: 0)
        self.startingShade!.zPosition=100
        self.addChild(startingShade!)
        self.startingShade!.zPosition=100
    }
    func fadeStart() {
        let fade = SKAction.fadeOut(withDuration: 1.5)
        startingShade?.run(fade)
    }
    func moveCastle() {
        //---RYTIER--- test
        
        print("ideMover")
        rytier.zablokovaneAkcie=true
        //rytier.physicsBody?.affectedByGravity=false
        hrad.hranicaL?.position.x = -440
        hrad.hranicaL?.physicsBody?.affectedByGravity=false
        rytier.position.x = -300   //-370
        rytier.position.y = 30   //-470
        rytier.run(.wait(forDuration: 1.5),completion: {
            self.rytier.movingRightB=true
            self.rytier.characterMove(left: false)
        })
        rytier.run(.wait(forDuration: 3.2), completion: {
            self.rytier.characterCancelMove(left: false)
            self.rytier.zablokovaneAkcie=false
            //self.rytier?.physicsBody?.affectedByGravity=true
            })
        hrad.hranicaL?.run(.wait(forDuration: 1), completion: {
            self.hrad.hranicaL?.run(.moveTo(x: -210, duration: 2.3), completion: {
                
            })
        })
        
        //--zaciatok bude bez tohto
        /*
        let startLabel=SKLabelNode(text: "GET TO THE TOP!")
        startLabel.fontName="Kebis_BIT-Regular"
        startLabel.fontSize=40
        startLabel.fontColor = .white
        hrad?.addChild(startLabel)
        startLabel.position.x = -300
        startLabel.position.y = 160
        startLabel.zPosition = 120
        startLabel.isHidden=true
        startLabel.run(.wait(forDuration: 2),completion: {
            startLabel.isHidden=false
            startLabel.run(.wait(forDuration: 3),completion: {
                startLabel.isHidden=true
            })
        })
        */
        //let scale = SKAction.scale(to: 0.6, duration: 1.5)  // scale 0.6
        controlis?.isHidden=true
        topBar?.isHidden=true
        hrad.position.x = 0      //290
        hrad.position.y = (hrad.position.y) - 96  //-100
        let moveCwai = SKAction.move(by: CGVector(dx: 0, dy: 96), duration: 2.5)
        moveCwai.timingMode = .easeOut
        //let moveLai = SKAction.move(by: CGVector(dx: -320, dy: 0), duration: 1.3)
        let wait = SKAction.wait(forDuration: 2)
        let seq = SKAction.sequence([moveCwai,wait])
        hrad.run(seq)
        let kopceMove=SKAction.moveBy(x: 0, y: 50, duration: 2.5)
        kopceMove.timingMode = .easeOut
        let horyMove=SKAction.moveBy(x: 0, y: 20, duration: 2.5)
        horyMove.timingMode = .easeOut
        //kopce?.run(kopceMove)
        //hory?.run(horyMove)
        hrad.run(.wait(forDuration: 3.8),completion: {
            self.controlis?.isHidden=false
            self.topBar?.isHidden=false
        })
    }
    
    func resetTexturesPause() {
        resumeB?.texture=atlasPausDeath.textureNamed("But2")
        resumeT?.position = resumeTPos!
        settingsB?.texture=atlasPausDeath.textureNamed("But2")
        optionsT?.position = optionsTPos!
        restartB?.texture=atlasPausDeath.textureNamed("But2")
        restartT?.position = restartTPos!
        menuB?.texture=atlasPausDeath.textureNamed("But2")
        menuT?.position = menuTPos!
        backB?.texture=atlasPausDeath.textureNamed("SMall")
        backIm?.position = backImPos!
        musicB?.texture=atlasPausDeath.textureNamed("SMall")
        audioB?.texture=atlasPausDeath.textureNamed("SMall")
        musicIm?.position = musicImPos!
        audioIm?.position = audioImPos!
    }
    
    //-------------------------------
    //-------------------------------
    //          TOUCH BEGAN
    //-------------------------------
    
    // MARK: TOUCH BEGAN
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //var numTouches:Int=touches.count
        //print("numTouches--\(numTouches)")
        if !zablokovatTouch {
            for touch in touches {
                let location = touch.previousLocation(in: self)
                           let node = self.nodes(at: location).first
                           //kvoli texture
                           switch (node?.name) {
                           case "Left":
                            zmenaTexturOvladanie(tlac: .left, dole: true, all: false)
                                   if rytier.movingRightB==true {
                                       rytier.obidveStranyB=true
                                       rytier.characterCancelMove(left: true)
                                       rytier.characterCancelMove(left: false)
                                   } else {
                                       rytier.movingLeftB=true
                                    if ((rytier.onGround == true || rytier.onRebrik==false) && !rytier.zablokovaneAkcie) {
                                           rytier.characterMove(left: true)
                                       }
                                   }
                               
                               break
                           case "Right":
                            zmenaTexturOvladanie(tlac: .right, dole: true, all: false)
                                   if rytier.movingLeftB==true {
                                       rytier.obidveStranyB=true
                                       rytier.characterCancelMove(left: true)
                                       rytier.characterCancelMove(left: false)
                                   } else {
                                       rytier.movingRightB=true
                                    if ((rytier.onGround == true || rytier.onRebrik==false) && !rytier.zablokovaneAkcie) {
                                            rytier.characterMove(left: false)
                                        //camera?.run(.repeatForever(.moveBy(x: 12, y: 0, duration: 0.1)))
                                       }
                                   }
                               break
                           case "Up":
                            self.rytier.staleSkace=true
                            //print("Double jump left \(self.rytier?.doublejumpLeft)")
                            zmenaTexturOvladanie(tlac: .jump, dole: true, all: false)
                               if rytier.zablokovaneAkcie == false{
                                
                                if !dvereArePressing {
                                    self.run(.wait(forDuration: 0.01),completion: {
                                        self.rytier.setCollisionPlosina(collisionOn: false) //treba nastavit aby nenarazal zo spodu do plosin
                                    })
                                       rytier.movingUp=true
                                       
                                       /*
                                       if (rytier!.onRebrik==true && !rytier!.onGround) {
                                           print("--Na rebriku--")
                                           resetRebrik=true    // kvoli pozicii hraca k rebriku
                                           rytier?.removeAction(forKey: "down")
                                           rytier?.setPhysicLedder(offPhysic:true)
                                           rytier?.climbLedder(up: true, positionX: (hrad?.poschodia[hrad!.currentLevel].rebriky.last?.position.x)!)
                                       } else {
                                           if rytier!.isInTheAir == false {
                                               rytier?.characterJump(rytierAir: false)
                                           }
                                       }*/
                                       if (rytier.onRebrik==true) {    //  && self.rytier?.onPlosina==false
                                               //print("--Na rebriku--")
                                        self.run(.wait(forDuration: 0.01),completion: {
                                            self.resetRebrik=true    // kvoli pozicii hraca k rebriku
                                            self.rytier.removeAction(forKey: "down")
                                            self.rytier.setPhysicLedder(offPhysic:true)
                                            self.rytier.climbLedder(up: true, positionX: (self.hrad.poschodia[self.hrad.currentLevel].rebriky.last?.position.x)!)
                                        })
                                               
                                           } else {
                                            //AudioServicesPlaySystemSound(1519)  //vibracia
                                               if rytier.isInTheAir == false || rytier.doublejumpLeft != 0 {
                                                   rytier.characterJump(rytierAir: false)
                                                rytier.doublejumpLeft -= 1
                                               }
                                           }
                                } else if !dvereBlocked {
                                    
                                    if !showTopBar {
                                        self.run(.wait(forDuration: 0.2),completion: {
                                            let down=SKAction.moveBy(x: 0, y: -160, duration: 0.5)
                                            down.timingMode = .easeOut
                                            self.topBar?.run(down)
                                        })
                                        showTopBar=true
                                        /*
                                        hrad.poschodia[1].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        hrad.poschodia[2].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        hrad.poschodia[3].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        hrad.poschodia[4].cPozadie[0].run(.fadeOut(withDuration: 0.5))
 */
                                    }
                                    self.rytier.onPlosina = false
                                    let temp = self.hrad.poschodia[hrad.currentLevel].sendPlayerLeft
                                    self.rytier.goLeftUp=temp
                                    reset=true
                                    self.hrad.score = self.hrad.score + 1
                                    //self.score?.text="\(self.hrad!.score)"
                                    self.score?.attributedText = NSMutableAttributedString(string: "\(self.hrad.score)", attributes: strokeTextAttributes)
                                    rytier.setCollisionPlosina(collisionOn: false) //treba lebo naraza ked pride na druhe poschodie
                                    dvereArePressing=false
                                }
                                
                               }
                               break
                           // MARK: SHOOT
                           case "Shoot":
                            zmenaTexturOvladanie(tlac: .mec, dole: true, all: false)
                               if rytier.zablokovaneAkcie == false {
                                if !dvereArePressing && !self.rytier.onRebrik {
                                    rytier.attack()
                                     //
                                     if self.rytier.mecNaEnemy {
                                        self.rytier.mecNaEnemy=false
                                        if hrad.currentLevel == 0 {
                                            if hrad.strasiakLifeLeft == 2 {
                                                hrad.strasiak?.texture = SKTexture(imageNamed: "star")
                                            } else if hrad.strasiakLifeLeft == 1 {
                                                hrad.strasiak?.physicsBody=nil
                                                hrad.strasiak?.texture = SKTexture(imageNamed: "sta")
                                            }
                                            hrad.strasiakLifeLeft -= 1
                                            self.rytier.mecNaEnemy=true
                                        }
                                        //--nove pridal
                                        //print("+Cez shoot ide")
                                        //print(enemyFirStr)
                                        //print(enemySecStr)
                                        if enemyFirStr == "Carodejnica" {
                                            let temp=hrad.poschodia[hrad.currentLevel]
                                            temp.bossSet!.odstranitCarodej(at:Int(enemyFirCis)!)
                                            
                                        } else if enemySecStr == "Carodejnica" {
                                            let temp=hrad.poschodia[hrad.currentLevel]
                                            temp.bossSet!.odstranitCarodej(at:Int(enemySecCis)!)
                                        } else if enemyFirStr == "Kostlivec" {
                                            let temp=hrad.poschodia[hrad.currentLevel]
                                            temp.bossSet!.odstranitKost(at: Int(enemyFirCis)!)
                                        } else if enemySecStr == "Kostlivec" {
                                            let temp=hrad.poschodia[hrad.currentLevel]
                                            temp.bossSet!.odstranitKost(at: Int(enemySecCis)!)
                                        } else if enemyFirStr == "Kostik" {
                                            let temp=hrad.poschodia[hrad.currentLevel]
                                            temp.odstranitKost(at: Int(enemyFirCis)!)
                                            hrad.poschodia[hrad.currentLevel].kosti[Int(enemyFirCis)!].removeFromParent()
                                        } else if enemySecStr == "Kostik" {
                                            let temp=hrad.poschodia[hrad.currentLevel]
                                            temp.odstranitKost(at: Int(enemySecCis)!)
                                            hrad.poschodia[hrad.currentLevel].kosti[Int(enemySecCis)!].removeFromParent()
                                        }
                                        
                                        if enemyFirStr == "Kostik" || enemySecStr == "Kostik" {
                                            //hrad.poschodia[hrad.currentLevel].childNode(withName: "Kostik")?.removeFromParent()
                                            
                                        }
                                        if enemyFirStr == "Carodejnik" || enemySecStr == "Carodejnik" {
                                            hrad.poschodia[hrad.currentLevel].childNode(withName: "Carodejnik")?.removeFromParent()
                                        }
                                        enemyFirStr=""
                                        enemyFirCis=""
                                        enemySecStr=""
                                        enemySecCis=""
                                        //---nove koniec
                                        
                                        
                                         hrad.poschodia[hrad.currentLevel].childNode(withName: "enemy")?.removeFromParent()
                                         hrad.poschodia[hrad.currentLevel].bossSet?.childNode(withName: "enemy")?.removeFromParent()
                                         //self.rytier.mecNaEnemy=false
                                     }
                                     if self.rytier.mecNaBoss {
                                        print("Kill the Boss!")
                                         if hrad.poschodia[hrad.currentLevel].boss?.neviditelny == false {
                                            hrad.poschodia[hrad.currentLevel].boss?.hitted()
                                         hrad.poschodia[hrad.currentLevel].boss?.neviditelny = true
                                            if hrad.poschodia[hrad.currentLevel].bossSet?.cisloBoss == 47 {
                                                hrad.poschodia[hrad.currentLevel].boss?.jumpBack()
                                                //--nefunguje
                                            }
                                             self.run(.wait(forDuration: 2.0), completion: {
                                                 self.hrad.poschodia[self.hrad.currentLevel].boss?.neviditelny = false
                                             })
                                         if (hrad.poschodia[hrad.currentLevel].bossLife) > 1 {
                                             hrad.poschodia[hrad.currentLevel].bossLife -= 1
                                            srdce?.uberZivot(naJedna: true)
                                            hrad.poschodia[hrad.currentLevel].odstranitKamene()
                                             rytier.setCollisionPlosina(collisionOn: false)
                                            self.hrad.poschodia[self.hrad.currentLevel].bossSet?.vypustitPlosinaPhysic(pravda: true)
                                             self.run(.wait(forDuration: 2), completion: {
                                                self.hrad.poschodia[self.hrad.currentLevel].bossSet?.vypustitPlosinaPhysic(pravda: false)
                                             })
                                             hrad.poschodia[hrad.currentLevel].bossSet!.odstranit(cislo: (hrad.poschodia[hrad.currentLevel].typeOfRoom))
                                             
                                             self.run(.wait(forDuration: 1.0), completion: {
                                                 self.hrad.bossFight(tahsie: true)
                                             })
                                             
                                             
                                         } else {
                                            //  0 life
                                            srdce?.uberZivot(naJedna: false)
                                            self.run(.wait(forDuration: 1.88),completion: {
                                                self.srdce?.run(.fadeOut(withDuration: 0.4),completion: {
                                                    self.srdce?.removeFromParent()
                                                })
                                            })
                                            hrad.killedBoss()
                                            /*
                                            hrad?.zabilBossaPosunutHrad = true
                                            let sucasPosch=self.hrad?.poschodia[self.hrad!.currentLevel]
                                            sucasPosch?.bossLife -= 1
                                            sucasPosch?.rebriky[0].run(.moveBy(x: 0, y: -112, duration: 1),completion: {
                                                sucasPosch?.rebriky[0].setPhysics(on: true)
                                            })
                                            sucasPosch?.childNode(withName: "boss")?.removeFromParent()
                                            sucasPosch?.bossSet!.odstranit(cislo: (sucasPosch?.typeOfRoom)!)
                                            sucasPosch?.bossSet!.pridatPlosinyNaKonci()
                                            sucasPosch?.odstranitKamene()
                                            hrad?.moveUp(typ: .naKlenbuRebrik)
                                            */
                                         }
                                         }
                                         self.rytier.mecNaBoss=false
                                     }
                                    if self.rytier.mecNaPoklade {
                                        self.rytier.mecNaPoklade=false
                                        if !hrad.poschodia[hrad.currentLevel].poklad!.otvoreny {
                                         pridatMincuAnim(pos: rytier.position, num: 10)
                                         hrad.poschodia[hrad.currentLevel].poklad!.openPoklad()
                                         numeroMince += 10
                                         self.mPocet?.attributedText=NSMutableAttributedString(string: String(numeroMince), attributes: minceTextAttributes)
                                         //print(numeroMince)
                                        }
                                     }
                                     //
                                } else if !dvereBlocked && !self.rytier.onRebrik {
                                    
                                    if !showTopBar {
                                        self.run(.wait(forDuration: 0.2),completion: {
                                            let down=SKAction.moveBy(x: 0, y: -160, duration: 0.5)
                                            down.timingMode = .easeOut
                                            self.topBar?.run(down)
                                        })
                                        showTopBar=true
                                        /*
                                        hrad.poschodia[1].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        hrad.poschodia[2].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        hrad.poschodia[3].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        hrad.poschodia[4].cPozadie[0].run(.fadeOut(withDuration: 0.5))
                                        */
                                    }
                                    if UserDefaults.standard.string(forKey: "ZaciatokHry") == "tutorial" {
                                        UserDefaults.standard.set("normal",forKey: "ZaciatokHry")
                                    } else if UserDefaults.standard.string(forKey: "ZaciatokHry") == "startNormal" {
                                        UserDefaults.standard.set("normal",forKey: "ZaciatokHry")
                                    }
                                    
                                    self.rytier.onPlosina = false
                                    let temp = self.hrad.poschodia[hrad.currentLevel].sendPlayerLeft
                                    self.rytier.goLeftUp=temp
                                    reset=true
                                    self.hrad.score = self.hrad.score + 1
                                    //self.score?.text="\(self.hrad!.score)"
                                    self.score?.attributedText = NSMutableAttributedString(string: "\(self.hrad.score)", attributes: strokeTextAttributes)
                                    rytier.setCollisionPlosina(collisionOn: false) //treba lebo naraza ked pride na druhe poschodie
                                    dvereArePressing=false
                                    rytierJePodHradom=false
                                }
                                }
                               
                               break
                           case "PauseB":
                            //self.isPaused=true
                            
                            pauseM?.xScale=0.9
                            pauseM?.yScale=0.9
                            pauseM?.isHidden=false
                            blackBac?.isHidden=false
                            blackBac?.run(.fadeAlpha(to: 0.6, duration: 0))
                            pauseM?.run(.scale(to: 1, duration: 0.06), completion: {
                                self.speed=0
                                self.hrad.isPaused=true
                                self.rytier.isPaused=true
                                self.controlis?.isPaused=true
                            })
                            
                            break
                           case "Minca","MLesk":
                            mincaRotate()
                            if minceSuUkazane==false {
                                var pocetCifier=1
                                switch numeroMince {
                                case 0..<10:
                                    pocetCifier=1
                                case 10..<100:
                                    pocetCifier=2
                                case 100..<1000:
                                    pocetCifier=3
                                case 1000..<10000:
                                    pocetCifier=4
                                case 10000..<100000:
                                    pocetCifier=5
                                default:
                                    pocetCifier=6
                                }
                                let down=SKAction.moveBy(x: 0, y: -50, duration: 0.3)
                                down.timingMode = .easeInEaseOut
                                let up=SKAction.moveBy(x: 0, y: 50, duration: 0.3)
                                up.timingMode = .easeInEaseOut
                                let temp=SKAction.moveBy(x: CGFloat(0 + 6*pocetCifier), y: 0, duration: 0)
                                temp.timingMode = .easeInEaseOut
                                let temp2=SKAction.moveBy(x: CGFloat(-(0 + 6*pocetCifier)), y: 0, duration: 0)
                                temp2.timingMode = .easeInEaseOut
                                mPocet?.run(.fadeIn(withDuration: 0.3))
                                minceSuUkazane=true
                                mPocet?.run(temp)
                                mPocet?.run(down,completion: {
                                    self.mPocet?.run(.wait(forDuration: 1.5), completion: {
                                        self.mPocet?.run(up,completion: {
                                            self.mPocet?.run(temp2)
                                        })
                                        self.mPocet?.run(.fadeOut(withDuration: 0.3),completion: {
                                            self.minceSuUkazane=false
                                        })
                                    })
                                })
                                
                            }
                            
                           
                            
                            
                           case "ResumeB","ResumeText":
                            resumeB?.texture=atlasPausDeath.textureNamed("But2p")
                            resumeT?.position.y=(resumeT?.position.y)!-8
                           case "Options","OptionsText":
                            settingsB?.texture=atlasPausDeath.textureNamed("But2p")
                            optionsT?.position.y=(optionsT?.position.y)!-8
                           case "Restart","RestartText":
                            restartB?.texture=atlasPausDeath.textureNamed("But2p")
                            restartT?.position.y=(restartT?.position.y)!-8
                           case"Menu","MenuText":
                            menuB?.texture=atlasPausDeath.textureNamed("But2p")
                            menuT?.position.y=(menuT?.position.y)!-8
                           case "Music","Musics":
                            musicB?.texture=SKTexture(imageNamed: "SMallc")
                            musicIm?.position.y = (musicIm?.position.y)!-8
                           case "Audio","Volume":
                            audioB?.texture=SKTexture(imageNamed: "SMallc")
                            audioIm?.position.y = (audioIm?.position.y)!-8
                           case "Back","Backs":
                            backB?.texture=atlasPausDeath.textureNamed("SMallc")
                            backIm?.position.y = (backIm?.position.y)!-8
                           case "X":
                            zablokovatTouch=true
                            self.run(.wait(forDuration: 0.1),completion: {
                                //self.continueT?.run(.moveBy(x:0 ,y: 500, duration: 0))
                                //self.continueT?.isHidden=false
                                let upp = SKAction.moveBy(x: 0, y: 600, duration: 0.46)
                                upp.timingMode = .easeOut
                                let doww = SKAction.moveBy(x: 0, y: -20, duration: 0.2)
                                let down=SKAction.moveBy(x: 0, y: -20, duration: 0.2)
                                let up=SKAction.moveBy(x: 0, y: 520, duration: 0.36)
                                down.timingMode = .easeOut
                                doww.timingMode = .easeIn
                                up.timingMode = .easeIn
                                self.deathScreen?.isHidden=false
                                self.continueT?.run(down,completion: {
                                    self.deathScreen?.run(.wait(forDuration: 0.2), completion: {
                                        self.deathScreen?.run(upp,completion: {
                                            self.HighScoreLabel?.run(.scale(to: 1.1, duration: 0.8),completion: {
                                                self.HighScoreLabel?.run(.scale(to: 0.8, duration: 0.8),completion: {
                                                })
                                            })
                                            self.deathScreen?.run(doww,completion: {
                                            })
                                        })
                                        self.zablokovatTouch=false
                                    })
                                    self.continueT?.run(up,completion: {
                                        self.continueT?.isHidden=true
                                    })
                                })
                            })
                            
                            let defaults=UserDefaults.standard  //---important---
                            if defaults.integer(forKey: "HighScoreAbsolute") < self.hrad.score {
                                jeNajvyssieSkore=true
                                defaults.set(self.hrad.score, forKey: "HighScoreAbsolute")
                            } else {
                                jeNajvyssieSkore=false
                            }
                            defaults.set(self.hrad.score, forKey: "LastGameScoreAbsolute")
                            
                            
                            if jeNajvyssieSkore {
                                highScore?.isHidden=false
                                normalScore?.isHidden=true
                            } else {
                                highScore?.isHidden=true
                                normalScore?.isHidden=false
                            }
                            
                            scoreHigh?.text="\(String(UserDefaults.standard.integer(forKey: "HighScoreAbsolute")))"
                            scoreH?.text="\(String(UserDefaults.standard.integer(forKey: "LastGameScoreAbsolute")))"
                            HscoreH?.text="\(String(UserDefaults.standard.integer(forKey: "HighScoreAbsolute")))"
                            /*
                            DispatchQueue.main.async {  // vdaka tomuto sa zrusia vsetky vlakna v gamescene a teda uz nic nebezi raz ked sa prepne VC, ale moc mi to nefunguje
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segue3") as NSNotification.Name, object: nil)    // funkcny sposob ako zavolat funkciu v nadradenej VC, kvoli performsegue
                            }
                            */
                           case "BackH":
                            backH?.texture=atlasPausDeath.textureNamed("BackPressed")
                            
                           case "RetryH":
                            retryH?.texture=atlasPausDeath.textureNamed("RestartPressed")
                            
                           case "PayCoins","TextPay":
                            payCoinsB?.texture=atlasPausDeath.textureNamed("bp")
                            labelPayC?.position.y=(labelPayC?.position.y)!-8
                            
                           case "CancelBuy":
                            zablokovatTouch=true
                            self.buyTable?.run(.wait(forDuration: 0.2), completion: {
                                let down=SKAction.moveBy(x: 0, y: -20, duration: 0.14)
                                down.timingMode = .easeInEaseOut
                                let up=SKAction.moveBy(x: 0, y: 620, duration: 0.46)
                                up.timingMode = .easeIn
                                self.buyTable?.run(down, completion: {
                                    self.buyTable?.run(up, completion: {
                                        self.buyTable?.isHidden=true
                                        self.zablokovatTouch=false
                                    })
                                })
                            })
                           case "BuyS":
                            print("Buy 200C")
                           case "BuyM":
                            print("Buy 800C")
                           case "BuyL":
                            print("Buy 2000C")
                           case .none:
                               print("Blabla1")
                           case .some(_):
                               print("Blabla2")
                           }
            }
        }
        
        
    }
    // MARK: TOUCH MOVED
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !zablokovatTouch {
            if let touch = touches.first {
                let location = touch.previousLocation(in: self)
                let node = self.nodes(at: location).first
                //if rytier?.zablokovaneAkcie == false {
                if node?.name == "Right"{
                    if rytier.obidveStranyB==true {
                    } else {
                        if rytier.movingLeftB == true {
                            rytier.movingLeftB=false
                            rytier.movingRightB=true
                            if rytier.zablokovaneAkcie == false {
                                rytier.characterCancelMove(left: true)
                                rytier.characterMove(left: false)
                            }
                        }
                    }
                }
                if node?.name == "Left"{
                    if rytier.obidveStranyB==true {
                        
                    } else {
                        if rytier.movingRightB == true {
                            rytier.movingRightB=false
                            rytier.movingLeftB=true
                            if rytier.zablokovaneAkcie == false {
                                rytier.characterCancelMove(left: false)
                                rytier.characterMove(left: true)
                            }
                        }
                    }
                }
                
                
                if node?.name == "OdpadNaButtons" {
                    rytier.removeAllActions()
                    rytier.movingRightB=false
                    rytier.movingLeftB=false
                    rytier.characterCancelMove(left: true)
                    rytier.characterCancelMove(left: false)
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                }
                if node?.name == "TabulaPause" {
                    cantTouch=true
                    resetTexturesPause()
                }
                if node?.name == "TabCon" {
                    payCoinsB?.texture=atlasPausDeath.textureNamed("b")
                    labelPayC?.position=labelPayCPos!
                }
                if node?.name == "Hrob" {
                    backH?.texture=atlasPausDeath.textureNamed("Back")
                    retryH?.texture=atlasPausDeath.textureNamed("Restart")
                }
                //if rytier?.zablokovaneAkcie == false {
                if node?.name == "RightB" {
                    if rytier.movingLeftB == true {
                        rytier.movingLeftB=false
                        rytier.movingRightB=true
                        if rytier.zablokovaneAkcie == false {
                            rytier.characterCancelMove(left: true)
                            rytier.characterMove(left: false)
                        }
                    }
                    rytier.movingLeftB=false
                    //rytier?.characterMove(left: false)
                }
                if node?.name == "LeftB" {
                    if rytier.movingRightB == true {
                        rytier.movingRightB=false
                        rytier.movingLeftB=true
                        if rytier.zablokovaneAkcie == false {
                            rytier.characterCancelMove(left: false)
                            rytier.characterMove(left: true)
                        }
                    }
                    rytier.movingRightB=false
                    //rytier?.characterMove(left: true)
                }
                if node?.name == "UpB" {
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                }
                if node?.name == "MecB" {
                    if rytier.zablokovaneAkcie == false {
                        rytier.characterCancelMove(left: false)
                    }
                    rytier.movingRightB=false
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                }
                
            }
        }
    }
    
    //-------------------------------
    //-------------------------------
    //          TOUCH ENDED
    //-------------------------------
    // MARK: TOUCH ENDED
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !zablokovatTouch {
            for touch in touches {
                let location = touch.previousLocation(in: self)
                let node = self.nodes(at: location).first
                if !cantTouch {
                switch (node?.name) {
                case "Left":
                    zmenaTexturOvladanie(tlac: .left, dole: false, all: false)
                    if rytier.obidveStranyB==true {
                        rytier.obidveStranyB=false
                        if rytier.zablokovaneAkcie == false {
                            rytier.characterMove(left: false)
                        }
                    } else {
                        rytier.characterCancelMove(left: true)
                        rytier.movingLeftB=false
                        zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                    }
                    break
                case "LeftB":
                    rytier.characterCancelMove(left: true)
                    rytier.movingLeftB=false
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                    break
                case "Right":
                    zmenaTexturOvladanie(tlac: .right, dole: false, all: false)
                    if rytier.obidveStranyB==true {
                        rytier.obidveStranyB=false
                        if rytier.zablokovaneAkcie == false {
                            rytier.characterMove(left: true)
                        }
                    } else {
                        rytier.characterCancelMove(left: false)
                        rytier.movingRightB=false
                        zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                    }
                    break
                case "RightB":
                    rytier.characterCancelMove(left: false)
                    rytier.movingRightB=false
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                    break
                case "OdpadNaButtons":
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                case "Up":
                    self.rytier.staleSkace=false
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: false)
                    rytier.movingUp=false
                    if (rytier.onRebrik==true) {
                        rytier.removeAction(forKey: "up")
                        rytier.climbLedder(up: false, positionX: (hrad.poschodia[hrad.currentLevel].rebriky.last?.position.x)!)
                    }
                    if rytier.isInTheAir==true {
                        rytier.removeAction(forKey: "Jump")
                    }
                    break
                case "Shoot":
                    zmenaTexturOvladanie(tlac: .mec, dole: false, all: false)
                    break
                case "Medzi":
                    rytier.removeAllActions()
                    rytier.movingRightB=false
                    rytier.movingLeftB=false
                    rytier.characterCancelMove(left: false)
                    rytier.characterCancelMove(left: true)
                    zmenaTexturOvladanie(tlac: .jump, dole: false, all: true)
                case "TabulaPause":
                    resetTexturesPause()
                    break
                case "ResumeB","ResumeText":
                     pauseM?.isHidden=true
                     pauseM?.xScale=0.9
                     pauseM?.yScale=0.9
                     blackBac?.isHidden=true
                     blackBac?.run(.fadeAlpha(to: 0.0, duration: 0))
                     //self.isPaused=false
                     self.speed=1
                     hrad.isPaused=false
                     rytier.isPaused=false
                     controlis?.isPaused=false
                    resetTexturesPause()
                    break
                case "Options","OptionsText":
                 hlavne?.isHidden=true
                 settingsP?.isHidden=false
                    resetTexturesPause()
                case "Restart","RestartText":
                     self.speed=1
                    let defaults=UserDefaults.standard
                    if defaults.integer(forKey: "HighScoreAbsolute") < self.hrad.score {
                        jeNajvyssieSkore=true
                        defaults.set(self.hrad.score, forKey: "HighScoreAbsolute")
                    } else {
                        jeNajvyssieSkore=false
                    }
                    defaults.set(self.hrad.score, forKey: "LastGameScoreAbsolute")
                    defaults.set(numeroMince, forKey: "CoinsAbsolute")
                    
                     blackScreen?.run(.fadeIn(withDuration:0.2),completion: {
                         DispatchQueue.main.async {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segueRestart") as NSNotification.Name, object: nil)
                         }
                     })
                    resetTexturesPause()
                case"Menu","MenuText":
                     self.speed=1
                    let defaults=UserDefaults.standard  //---important---
                    if defaults.integer(forKey: "HighScoreAbsolute") < self.hrad.score {
                        jeNajvyssieSkore=true
                        defaults.set(self.hrad.score, forKey: "HighScoreAbsolute")
                    } else {
                        jeNajvyssieSkore=false
                    }
                    defaults.set(self.hrad.score, forKey: "LastGameScoreAbsolute")
                    defaults.set(numeroMince, forKey: "CoinsAbsolute")
                    
                     blackScreen?.run(.fadeIn(withDuration:0.2),completion: {
                        updateFromGame=true
                         DispatchQueue.main.async {  // vdaka tomuto sa zrusia vsetky vlakna v gamescene a teda uz nic nebezi raz ked sa prepne VC, ale moc mi to nefunguje
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segue3") as NSNotification.Name, object: nil)    // funkcny sposob ako zavolat funkciu v nadradenej VC, kvoli performsegue
                         }
                     })
                    resetTexturesPause()
                case "Music","Musics":
                     let usTemp = UserDefaults.standard
                     UserDefaults.standard.set(usTemp.bool(forKey: "MusicOn") ? false : true, forKey: "MusicOn")
                     musicIm?.texture=atlasMenu.textureNamed(UserDefaults.standard.bool(forKey: "MusicOn") ? "MusicYes" : "MusicNo")
                     musicT?.text = UserDefaults.standard.bool(forKey: "MusicOn") ? NSLocalizedString("MusicOn", comment: "") : NSLocalizedString("MusicOff", comment: "")
                    resetTexturesPause()
                case "Audio","Volume":
                     let usTemp = UserDefaults.standard
                     UserDefaults.standard.set(usTemp.bool(forKey: "AudioOn") ? false : true, forKey: "AudioOn")
                     audioIm?.texture=atlasMenu.textureNamed(UserDefaults.standard.bool(forKey: "AudioOn") ? "Volume" : "VolumeNo")
                     audioT?.text = UserDefaults.standard.bool(forKey: "AudioOn") ? NSLocalizedString("AudioOn", comment: "") : NSLocalizedString("AudioOff", comment: "")
                    resetTexturesPause()
                case "Back","Backs":
                     hlavne?.isHidden=false
                     settingsP?.isHidden=true
                    resetTexturesPause()
                case "BackH":
                    backH?.texture=atlasPausDeath.textureNamed("Back")
                    blackScreen?.run(.fadeIn(withDuration:0.2),completion: {
                        updateFromGame=true
                        DispatchQueue.main.async {
                           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segue3") as NSNotification.Name, object: nil)    // funkcny sposob ako zavolat funkciu v nadradenej VC, kvoli performsegue
                        }
                    })
                case "RetryH":
                    retryH?.texture=atlasPausDeath.textureNamed("Restart")
                    blackScreen?.run(.fadeIn(withDuration:0.2),completion: {
                        DispatchQueue.main.async {
                           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "segueRestart") as NSNotification.Name, object: nil)
                        }
                    })
                case "PayCoins","TextPay":
                    payCoinsB?.texture=atlasPausDeath.textureNamed("b")
                    labelPayC?.position=labelPayCPos!
                 
                 zablokovatTouch=true
                 var sumaZaplat=20 // :)
                 if rytierWasRevived == 0 {
                     sumaZaplat=20
                     //labelPayC?.texture=SKTexture(imageNamed: "50")
                 } else if rytierWasRevived == 1 {
                     sumaZaplat=50
                     //labelPayC?.texture=SKTexture(imageNamed: "100")
                 } else if rytierWasRevived == 2 {
                     sumaZaplat=100
                     //labelPayC?.texture=SKTexture(imageNamed: "200")
                 } else {
                     sumaZaplat=200
                 }
                 if UserDefaults.standard.integer(forKey: "CoinsAbsolute") < sumaZaplat {
                     print("----20----")
                     self.buyTable?.run(.wait(forDuration: 0.3), completion: {
                         self.buyTable?.isHidden=false
                         let down=SKAction.moveBy(x: 0, y: -620, duration: 0.46)
                         down.timingMode = .easeOut
                         let littleUp=SKAction.moveBy(x: 0, y: 20, duration: 0.1)
                         littleUp.timingMode = .easeIn
                         self.buyTable?.run(down, completion: {
                             self.buyTable?.run(littleUp, completion: {
                                 self.zablokovatTouch=false
                             })
                         })
                     })
                 } else {
                     
                     let xes=UserDefaults.standard.integer(forKey: "CoinsAbsolute")
                     UserDefaults.standard.set(xes-sumaZaplat, forKey: "CoinsAbsolute")
                     numeroMince -= sumaZaplat
                     mPocet?.attributedText=NSMutableAttributedString(string: String(numeroMince), attributes: minceTextAttributes)
                     
                     self.run(.wait(forDuration: 0.1),completion: {
                         //self.continueT?.run(.moveBy(x:0 ,y: 500, duration: 0))
                         //self.continueT?.isHidden=false
                         let down=SKAction.moveBy(x: 0, y: -20, duration: 0.2)
                         let up=SKAction.moveBy(x: 0, y: 520, duration: 0.36)
                         down.timingMode = .easeOut
                         up.timingMode = .easeIn
                         self.continueT?.run(down,completion: {
                             
                             var pocetCifier=1
                             switch self.numeroMince {
                             case 0..<10:
                                 pocetCifier=1
                             case 10..<100:
                                 pocetCifier=2
                             case 100..<1000:
                                 pocetCifier=3
                             case 1000..<10000:
                                 pocetCifier=4
                             case 10000..<100000:
                                 pocetCifier=5
                             default:
                                 pocetCifier=6
                             }
                             
                             let temp2=SKAction.moveBy(x: CGFloat(-(50 + 5*pocetCifier)), y: 0, duration: 0.3)
                             temp2.timingMode = .easeInEaseOut
                             self.mPocet?.run(.fadeOut(withDuration: 0.3))
                             self.mPocet?.run(temp2,completion: {
                             })
                             
                             self.continueT?.run(up,completion: {
                                 self.minceSuUkazane=false
                                 self.labelPayC?.texture=self.atlasPausDeath.textureNamed("20")
                                 if self.rytierWasRevived == 0 {
                                     self.labelPayC?.texture=self.atlasPausDeath.textureNamed("50")
                                 } else if self.rytierWasRevived == 1 {
                                     self.labelPayC?.texture=self.atlasPausDeath.textureNamed("100")
                                 } else {
                                     self.labelPayC?.texture=self.atlasPausDeath.textureNamed("200")
                                 }
                                 self.rytierWasRevived += 1
                                 
                                 self.continueT?.isHidden=true

                                 self.blackBac?.run(.fadeAlpha(to: 0.0, duration: 0.3),completion: {
                                     self.blackBac?.isHidden=true
                                 })
                                 
                                 //len predbezne enemies vymazat
                                 let sucasPosch=self.hrad.poschodia[self.hrad.currentLevel]
                                 if sucasPosch.typ == .bossRoom {
                                     if sucasPosch.bossSet?.odstraneneEle == false {
                                         sucasPosch.bossSet?.odstranit(cislo: (sucasPosch.numRoom))
                                     }
                                     //print("ssssuc-\(sucasPosch?.bossLife)")
                                     self.hrad.bossFight(tahsie:sucasPosch.bossLife == 1 ? true : false)
                                 } else {
                                     sucasPosch.childNode(withName: "enemy")?.removeFromParent()
                                 }

                                 //---
                                 self.rytier=Player3(texture: nil, color: nil, size: nil, pos: self.rytierPosBeforeDeath!,revive: true, skin: UserDefaults.standard.integer(forKey: "PickedSkinAbsolute")+1)
                                 self.hrad.addChild(self.rytier)
                                 //--nastavit plosinu keby bol zraneny bossom
                                 self.rytier.setCollisionPlosina(collisionOn: false)
                                 self.hrad.poschodia[self.hrad.currentLevel].bossSet?.vypustitPlosinaPhysic(pravda: true)
                                  self.run(.wait(forDuration: 2), completion: {
                                     self.hrad.poschodia[self.hrad.currentLevel].bossSet?.vypustitPlosinaPhysic(pravda: false)
                                  })
                                 //--koniec nastavit plosinu keby bol zraneny bossom
                                 
                                 self.rytier.position=self.rytierPosBeforeDeath!
                                 //rytier?.position.y += 10
                                 //self.isPaused=false
                                 self.speed=1
                                 self.hrad.isPaused=false
                                 self.rytier.isPaused=false
                                 self.controlis?.isPaused=false
                                 self.continueT?.isHidden=true
                                 self.zablokovatTouch=false
                                 self.rytierNaOheni=false
                                 self.rytierNaPasci=false
                                 self.run(.wait(forDuration: 2), completion: {
                                     self.mrtvyHrac=false
                                     self.hrad.mrtvyHrac=false
                                     self.hrad.poschodia[self.hrad.currentLevel].hracMrkev = false
                                     //--
                                     self.rytier.physicsBody?.contactTestBitMask = coinCategory | doorCategory | enemyCategory | wallCategory | plosinaCategory | deathCategory | bossCategory | dverePressCategory | pichliaceOhenCategory
                                     self.rytier.physicsBody!.collisionBitMask = wallCategory | plosinaCategory | bossCategory
                                     
                                     self.rytier.seknutie.physicsBody?.contactTestBitMask = enemyCategory | pokladCategory | bossCategory
                                     self.diedForDelegate=false
                                 })
                             })
                         })
                     })
                 }
                    
                case .none:
                    print("Blabla1")
                case .some(_):
                    print("Blabla2")
                }
            }
                cantTouch=false
            }
        }
    }
    
    //-------------------------------
    //-------------------------------
    //          DID BEGIN
    //-------------------------------
    // MARK: DID BEGIN
    func didBegin(_ contact: SKPhysicsContact) {
        let x=contact.bodyB
        let y=contact.bodyA
        if x.node!.name == "rytier" || y.node!.name == "rytier" {
            if x.node!.name == "MoveCastle" || y.node!.name == "MoveCastle" {
                rytierNaOheni=false
                rytierNaPasci=false
                self.textTutorial?.isHidden=true
                hrad.posunutHrad?.isHidden=true
                switch hrad.posunulHradKolko {
                case 0:
                    let movHrad=SKAction.moveBy(x: -400, y: 0, duration: 2.6)
                    movHrad.timingMode = .easeInEaseOut
                    let mov2=SKAction.moveBy(x: 260, y: 0, duration: 2.6)
                    mov2.timingMode = .easeInEaseOut
                    let horyMove = SKAction.moveBy(x: -26, y: 0, duration: 2.6) //-86
                    horyMove.timingMode = .easeInEaseOut
                    let kopceMove = SKAction.moveBy(x: -46, y: 0, duration: 2.6) //-86
                    kopceMove.timingMode = .easeInEaseOut
                    
                    hrad.run(movHrad,completion: {
                        self.hrad.run(.wait(forDuration: 0.5),completion: {
                            self.textTutorial?.isHidden=false
                            self.textTutorial?.fontSize=22
                            self.textTutorial?.text="CLICK TO JUMP \nDOUBLE CLICK TO JUMP HIGHER"
                            self.textTutorial?.numberOfLines=0
                            //self.textTutorial?.preferredMaxLayoutWidth=13
                            self.jump?.isHidden=false
                        })
                    })
                    kopce?.run(kopceMove)
                    hory?.run(horyMove)
                    hrad.hranicaL?.run(mov2)
                    hrad.posunutHrad?.run(.moveBy(x: 380, y: 0, duration: 0),completion: {
                        self.hrad.posunutHrad?.isHidden=false
                    })
                case 1:
                    let movHrad=SKAction.moveBy(x: -400, y: 0, duration: 2.6)
                    movHrad.timingMode = .easeInEaseOut
                    let mov2=SKAction.moveBy(x: 370, y: 0, duration: 2.6)
                    mov2.timingMode = .easeInEaseOut
                    let horyMove = SKAction.moveBy(x: -26, y: 0, duration: 2.6) //-86
                    horyMove.timingMode = .easeInEaseOut
                    let kopceMove = SKAction.moveBy(x: -46, y: 0, duration: 2.6) //-86
                    kopceMove.timingMode = .easeInEaseOut
                    
                    hrad.run(movHrad,completion: {
                        self.hrad.run(.wait(forDuration: 0.5),completion: {
                            self.textTutorial?.isHidden=false
                            self.textTutorial?.text="DESTROY THE BARRIER"
                            self.jump?.isHidden=false
                            self.shoot?.isHidden=false
                        })
                    })
                    kopce?.run(kopceMove)
                    hory?.run(horyMove)
                    hrad.hranicaL?.run(mov2)
                    hrad.posunutHrad?.run(.moveBy(x: 300, y: 0, duration: 0),completion: {
                        self.hrad.posunutHrad?.isHidden=false
                    })
                case 2:
                    let scale=SKAction.scale(to: 1, duration: 3.4)
                    let movHrad=SKAction.moveBy(x: -400, y: 0, duration: 3.4)
                    movHrad.timingMode = .easeInEaseOut
                    let movHradis=SKAction.moveTo(x: 0, duration: 3.4)
                    movHradis.timingMode = .easeInEaseOut
                    let mov2=SKAction.moveBy(x: 330, y: 0, duration: 3.4)
                    mov2.timingMode = .easeInEaseOut
                    let horyMove = SKAction.moveBy(x: -26, y: 0, duration: 3.4) //-86
                    horyMove.timingMode = .easeInEaseOut
                    let kopceMove = SKAction.moveBy(x: -46, y: 0, duration: 3.4) //-86
                    kopceMove.timingMode = .easeInEaseOut
                    
                    hrad.run(movHradis,completion: {
                        print("Dvere unlocked")
                        self.dvereBlocked=false
                        self.hrad.run(.wait(forDuration: 2),completion: {
                        })
                    })
                    hrad.run(scale)
                    kopce?.run(kopceMove)
                    hory?.run(horyMove)
                    hrad.hranicaL?.run(mov2)
                    hrad.posunutHrad?.run(.moveBy(x: 300, y: 0, duration: 0),completion: {
                        self.hrad.posunutHrad?.removeFromParent()
                    })

                default:
                    let movHrad=SKAction.moveBy(x: -500, y: 0, duration: 3.0)
                    movHrad.timingMode = .easeInEaseOut
                    let mov2=SKAction.moveBy(x: 450, y: 0, duration: 3.0)
                    mov2.timingMode = .easeInEaseOut
                    let horyMove = SKAction.moveBy(x: -46, y: 0, duration: 3.0) //-86
                    horyMove.timingMode = .easeInEaseOut
                    let kopceMove = SKAction.moveBy(x: -86, y: 0, duration: 3.0) //-86
                    kopceMove.timingMode = .easeInEaseOut
                    
                    hrad.run(movHrad)
                    kopce?.run(kopceMove)
                    hory?.run(horyMove)
                    hrad.hranicaL?.run(mov2)
                    hrad.posunutHrad?.run(.moveBy(x: 450, y: 0, duration: 0),completion: {
                        self.hrad.posunutHrad?.isHidden=false
                    })
                }
                hrad.posunulHradKolko += 1
                
                
                //hrad.posunutHrad?.removeFromParent()
                 
            }
            
            //  mince zbierame
            if y.categoryBitMask == coinCategory {
                if  let i = Int(y.node!.name!) {
                    self.run(.playSoundFileNamed("mincaFinal", waitForCompletion: false))
                    hrad.poschodia[hrad.currentLevel].coinis[i].removeFromParent()
                    //print("Mincee-\(i) y")
                    numeroMince+=1
                    self.mPocet?.attributedText=NSMutableAttributedString(string: String(numeroMince), attributes: minceTextAttributes)
                    //print(numeroMince)
                } else {
                    //print("Bad y")
                }
            }
            if (x.categoryBitMask == coinCategory) {
                if  let i = Int(x.node!.name!) {
                    self.run(.playSoundFileNamed("mincaFinal.m4a", waitForCompletion: false))
                    pridatMincuAnim(pos: (hrad.poschodia[hrad.currentLevel].coinis[i].position), num: 1)
                    hrad.poschodia[hrad.currentLevel].coinis[i].removeFromParent()
                    //print("Mincee-\(i) x")
                    numeroMince+=1
                    self.mPocet?.attributedText=NSMutableAttributedString(string: String(numeroMince), attributes: minceTextAttributes)
                    //print(numeroMince)
                } else {
                    //print("Bad x")
                }
            }
            if y.categoryBitMask == pichliaceOhenCategory || x.categoryBitMask == pichliaceOhenCategory {
                if y.node!.name == "Ohen" {
                    rytierNaOheni=true
                    if rytierNaPlamen == nil {
                        rytierNaPlamen=y.node as? Ohen
                    } else {
                        rytierNaPlamen=y.node as? Ohen
                    }
                }
                if x.node!.name == "Ohen" {
                    rytierNaOheni=true
                    if rytierNaPlamen == nil {
                        rytierNaPlamen=x.node as? Ohen
                    } else {
                        rytierNaPlamen=x.node as? Ohen
                    }
                }
                if x.node!.name == "Pichs" {
                    rytierNaPasci=true
                    if rytierNaPich == nil {
                        rytierNaPich=x.node as? Pasca
                    } else {
                        rytierNaPich=x.node as? Pasca
                    }
                }
                if y.node!.name == "Pichs" {
                    rytierNaPasci=true
                    if rytierNaPich == nil {
                        rytierNaPich=y.node as? Pasca
                    } else {
                        rytierNaPich=y.node as? Pasca
                    }
                }
                
            }
            
            
            //print("y: \(y.categoryBitMask) x: \(x.categoryBitMask)")
            if y.categoryBitMask == wallCategory || x.categoryBitMask == wallCategory{
                //print("Na stenu")
                //print("plosina - plus jedna :)")
                rytier.doublejumpLeft = 2
                //-- toto bolo treba pridat lebo ked dopadava na plosinu ale nad nim este je jedna tak registruje najprv dopad a potom opustenie, mozno to nebude treba v buducnosti ak physic body rytiera bude mensie
                self.run(.wait(forDuration: 0.01),completion: {
                    self.rytier.doublejumpLeft = 2
                })
                rytier.vPoziciSkakania=1
                rytier.onGround = true
                rytier.isInTheAir = false
                //self.rytier!.texture=SKTexture(imageNamed: "rytier_stay")
                //print("Juuuump")
                atlasRytN=SKTextureAtlas(named: "Nohy\(self.rytier.skin)")
                atlasRytT=SKTextureAtlas(named: "Telo\(self.rytier.skin)")
                self.rytier.telo.texture=atlasRytT.textureNamed("\(String(self.rytier.shortcut))s3")
                self.rytier.nohy.texture=atlasRytN.textureNamed("\(String(self.rytier.shortcut))Stay1")
                rytier.removeAction(forKey: "down")
                rytier.removeAction(forKey: "up")
                rytier.setPhysicLedder(offPhysic:false)
                self.rytier.telo.removeAction(forKey: "RebrikAnimTelo")
                
                if rytier.movingLeftB && !rytier.obidveStranyB && !rytier.zablokovaneAkcie {
                    rytier.characterMove(left: true)
                } else if rytier.movingRightB && !rytier.obidveStranyB && !rytier.zablokovaneAkcie {
                    rytier.characterMove(left: false)
                }
            }
            
            if y.categoryBitMask == enemyCategory || x.categoryBitMask == enemyCategory || y.categoryBitMask == deathCategory || x.categoryBitMask == deathCategory || (y.categoryBitMask == bossCategory && self.hrad.poschodia[hrad.currentLevel].boss?.neviditelny == false) || (x.categoryBitMask == bossCategory && self.hrad.poschodia[hrad.currentLevel].boss?.neviditelny == false) {
                
                rytierDied()
                /*
                let sucasPosch=self.hrad.poschodia[self.hrad.currentLevel]
                if killedPlayer==false {
                    self.diedForDelegate=true
                    killedPlayer=true
                    self.run(.wait(forDuration: 0.2),completion: {
                        self.killedPlayer=false
                    })
                    mrtvyHrac=true
                    self.hrad.mrtvyHrac=true
                    sucasPosch.hracMrkev = true
                    if sucasPosch.bossSet != nil {
                        
                        if sucasPosch.bossSet?.firstDeath == false {
                            sucasPosch.bossSet?.firstDeath = true
                            self.run(.wait(forDuration: 5),completion: {
                                sucasPosch.bossSet?.firstDeath = false
                            })
                        }
                    }
                    if self.hrad.poschodia[hrad.currentLevel].bossSet?.cisloBoss == 47 {
                        //print("Killed by 7")
                        self.hrad.poschodia[hrad.currentLevel].boss?.killedPlayer=true
                        self.run(.wait(forDuration: 2),completion: {
                            self.hrad.poschodia[self.hrad.currentLevel].boss?.killedPlayer=false
                        })
                    }
                    zablokovatTouch=true
                    let defaults=UserDefaults.standard  //---important---
                    if defaults.integer(forKey: "HighScoreAbsolute") < self.hrad.score {
                        defaults.set(self.hrad.score, forKey: "HighScoreAbsolute")
                    }   // opravit pretoze to nie je osetrene ak sa revivnem
                    defaults.set(self.hrad.score, forKey: "LastGameScoreAbsolute")
                    defaults.set(numeroMince, forKey: "CoinsAbsolute")
                    rytierPosBeforeDeath=self.rytier.position
                    rytierDeath=PlayerDeath(texture: nil, color: .white, size: CGSize(width: 32, height: 46), typ: self.rytier.skin,otocenyDoLava: self.rytier.otocenyDoLava)
                    self.hrad.addChild(rytierDeath!)
                    rytierDeath?.position=rytierPosBeforeDeath!
                    self.rytier.removeFromParent()
                    
                    blackBac?.alpha=0.0
                    self.run(.wait(forDuration: 0.4),completion: {
                        //self.blackBac?.alpha=0.8
                        self.blackBac?.run(.fadeAlpha(to: 0.8, duration: 0.1))
                    })
                    blackBac?.isHidden=false

                    
                    self.run(.wait(forDuration: 0.8),completion: {

                        self.continueT?.isHidden=false
                        let down=SKAction.moveBy(x: 0, y: -520, duration: 0.36)
                        let littleUp=SKAction.moveBy(x: 0, y: 20, duration: 0.2)
                        littleUp.timingMode = .easeInEaseOut
                        down.timingMode = .easeOut
                        self.continueT?.run(down,completion: {
                            self.continueT?.run(littleUp)
                            self.zablokovatTouch=false
                        })
                        
                    })
                }
                
                */
                
            }
            if y.categoryBitMask == doorCategory || x.categoryBitMask == doorCategory {
                //self.hrad.poschodia[hrad.currentLevel].pichi.last?.deleg=self
                rytierNaOheni=false
                rytierNaPasci=false
                self.rytier.onPlosina = false
                let temp = self.hrad.poschodia[hrad.currentLevel].sendPlayerLeft
                self.rytier.goLeftUp=temp
                reset=true
                self.hrad.score = self.hrad.score + 1
                //self.score?.text="\(self.hrad!.score)"
                self.score?.attributedText = NSMutableAttributedString(string: "\(self.hrad.score)", attributes: strokeTextAttributes)
                rytier.setCollisionPlosina(collisionOn: false) //treba lebo naraza ked pride na druhe poschodie
                
                enemyFirStr=""
                enemyFirCis=""
                enemySecStr=""
                enemySecCis=""
            }
            if y.categoryBitMask == dverePressCategory || x.categoryBitMask == dverePressCategory {
                dvereArePressing=true
                //print("press dvere")
            }
            if y.categoryBitMask == plosinaCategory || x.categoryBitMask == plosinaCategory {
                rytier.vPoziciSkakania=1   //--sarapata, neviem co to tu robi ale nebudem to odstranovat
                let sucasnePosch = hrad.poschodia[hrad.currentLevel]
                
                var plusCislo:CGFloat=0
                if (sucasnePosch.bossSet) != nil {
                    print("+30")
                    plusCislo=30
                }
                
                if (hrad.zabilBossaPosunutHrad) == true {
                    if sucasnePosch.bossSet?.cisloBoss == 48 {
                        //print("plus plosina")
                        print("+48")
                        plusCislo=112+30   //+30
                    } else if sucasnePosch.bossSet != nil{
                        //print("plus plosina2")
                        print("+klasika")
                        plusCislo=112+30
                    }
                }
                
                let ryX = self.convert(rytier.position, from: hrad).y + 40 + plusCislo   //ak je boss tak 70 inak 40
                var fas = ""
                if x.node!.name=="rytier" {
                    fas=y.node!.name!
                } else {
                    fas=x.node!.name!
                }
                //--printi---- este budem potrebovat
                print("Plosina>")
                print(sucasnePosch.childNode(withName: fas)?.frame.origin.y)
                print("Rytier>")
                print(self.convert(rytier.position, from: hrad).y + 40) //140 was good
                //--------
                var temp:CGFloat=0
                //print(fas)
                if (sucasnePosch.typeOfRoom) > 45 && (sucasnePosch.typeOfRoom) < 53 {
                    temp=sucasnePosch.bossSet!.childNode(withName: fas)?.frame.origin.y as! CGFloat
                } else {
                    temp=sucasnePosch.childNode(withName: fas)?.frame.origin.y as! CGFloat
                }
                //------
                
                print("player: \(ryX)")
                print("static_obj: \(temp)")
                
                if (ryX >= temp) {  //--self.rytier?.physicsBody?.velocity.dy > 0
                    print("*Plosina zhora")
                    rytier.setPhysicLedder(offPhysic:false)
                    self.rytier.telo.removeAction(forKey: "RebrikAnimTelo")    //na odstranenie animacie rebrika
                    self.rytier.removeAction(forKey: "up")
                    self.rytier.removeAction(forKey: "down")
                    rytier.doublejumpLeft = 2
                    //-- toto bolo treba pridat lebo ked dopadava na plosinu ale nad nim este je jedna tak registruje najprv dopad a potom opustenie, mozno to nebude treba v buducnosti ak physic body rytiera bude mensie
                    self.run(.wait(forDuration: 0.01),completion: {
                        self.rytier.doublejumpLeft = 2
                    })
                    self.rytier.onRebrik=false          //pridal aby nerobil blbosti ked je na plosine a nad rebrikom
                    self.rytier.onPlosina=true
                    self.rytier.onGround=true
                    self.rytier.isInTheAir = false
                    atlasRytN=SKTextureAtlas(named: "Nohy\(self.rytier.skin)")
                    self.rytier.nohy.texture=atlasRytN.textureNamed("\(String(self.rytier.shortcut))Stay1")
                    rytier.setCollisionPlosina(collisionOn: true)
                    if rytier.movingLeftB && !rytier.obidveStranyB && !rytier.zablokovaneAkcie{
                        rytier.characterMove(left: true)
                    } else if rytier.movingRightB && !rytier.obidveStranyB && !rytier.zablokovaneAkcie {
                        rytier.characterMove(left: false)
                    }
                } else {
                    print("*Plosina zdola")
                    rytier.setCollisionPlosina(collisionOn: false)
                }
                
            }
            if y.categoryBitMask == rebrikCategory || x.categoryBitMask == rebrikCategory {
                //rytier?.onRebrik=true   //toto
                //print("*** rebrik--onPlosina \(rytier?.onPlosina), inTheAir\(rytier?.isInTheAir)")
                if !rytier.onPlosina {     // POZOR TOTO SOM PRIDAL PODMIENKU
                    rytier.onRebrik=true
                    if rytier.isInTheAir==true {
                        resetRebrik=true    // kvoli pozicii hraca k rebriku
                        rytier.setPhysicLedder(offPhysic:true)
                    }
                } else if rytier.onGround {
                    self.rytier.telo.removeAction(forKey: "RebrikAnimTelo")
                }
                
            }
        }
        
        if x.categoryBitMask == mecCategory || y.categoryBitMask == mecCategory {
            if x.node!.name == "Strasiak" || y.node!.name == "Strasiak" {
                
                self.rytier.mecNaEnemy=true
                if rytier.attacking==true {
                    if hrad.strasiakLifeLeft == 2 {
                        hrad.strasiak?.texture = SKTexture(imageNamed: "star")
                    } else if hrad.strasiakLifeLeft == 1 {
                        hrad.strasiak?.physicsBody=nil
                        hrad.strasiak?.texture = SKTexture(imageNamed: "sta")
                    }
                    hrad.strasiakLifeLeft -= 1
                    self.rytier.mecNaEnemy=false
                }
            }
            if y.categoryBitMask == enemyCategory || x.categoryBitMask == enemyCategory {
                //print("Kill enemy")
                self.rytier.mecNaEnemy=true
                
                //print("+Cez didBegin ide")
                let tempy = y.node?.name?.components(separatedBy: " ")
                let tempx = x.node?.name?.components(separatedBy: " ")
                let firty = tempy?[0]
                let firtx = tempx?[0]
                enemyFirStr=firty ?? ""
                enemySecStr=firtx ?? ""
                var secony = ""
                var seconx = ""
                if tempy != nil {
                    if tempy!.count > 1 {
                        secony = (tempy?[1]) as! String
                        enemyFirCis=secony
                    }
                }
                if tempx != nil {
                    if tempx!.count > 1 {
                        seconx = (tempx?[1]) as! String
                        enemySecCis=seconx
                    }
                }
                
                
                if rytier.attacking==true {
                    //--nove pridal
                    
                    if firty == "Carodejnica" {
                        let temp=hrad.poschodia[hrad.currentLevel]
                        temp.bossSet!.odstranitCarodej(at:Int(secony)!)
                    } else if firtx == "Carodejnica" {
                        let temp=hrad.poschodia[hrad.currentLevel]
                        temp.bossSet!.odstranitCarodej(at:Int(seconx)!)
                    } else if firty == "Kostlivec" {
                        let temp=hrad.poschodia[hrad.currentLevel]
                        temp.bossSet!.odstranitKost(at: Int(secony)!)
                    } else if firtx == "Kostlivec" {
                        let temp=hrad.poschodia[hrad.currentLevel]
                        temp.bossSet!.odstranitKost(at: Int(seconx)!)
                    } else if firtx == "Kostik" {
                        let temp=hrad.poschodia[hrad.currentLevel]
                        temp.odstranitKost(at: Int(seconx)!)
                        hrad.poschodia[hrad.currentLevel].kosti[Int(seconx)!].removeFromParent()
                    } else if firty == "Kostik" {
                        let temp=hrad.poschodia[hrad.currentLevel]
                        temp.odstranitKost(at: Int(secony)!)
                        hrad.poschodia[hrad.currentLevel].kosti[Int(secony)!].removeFromParent()
                    }
                    
                    if y.node?.name == "Kostik" || x.node?.name == "Kostik" {
                        hrad.poschodia[hrad.currentLevel].childNode(withName: "Kostik")?.removeFromParent()
                    }
                    if y.node?.name == "Carodejnik" || x.node?.name == "Carodejnik" {
                        hrad.poschodia[hrad.currentLevel].childNode(withName: "Carodejnik")?.removeFromParent()
                    }
                    //---nove koniec
                    
                    hrad.poschodia[hrad.currentLevel].childNode(withName: "enemy")?.removeFromParent()
                    hrad.poschodia[hrad.currentLevel].bossSet?.childNode(withName: "enemy")?.removeFromParent()
                }
                /*
                //--toto treba len na skusku ze sa dotkne bossa
                if y.node!.name=="boss" || x.node!.name=="boss" {
                    self.rytier!.mecNaBoss = true
                    print("Kill the boss!")
                    if rytier?.attacking==true {
                    hrad?.poschodia[hrad!.currentLevel].bossLife -= 1
                    if hrad?.poschodia[hrad!.currentLevel].bossLife == 0 {
                        hrad?.poschodia[hrad!.currentLevel].rebriky[0].run(.moveBy(x: 0, y: -84, duration: 1))
                    }
                }
 */
            }
            
            
            if y.categoryBitMask == bossCategory || x.categoryBitMask == bossCategory {
                self.rytier.mecNaBoss=true
                //print("Kill the boss!")
                if rytier.attacking==true && hrad.poschodia[hrad.currentLevel].boss?.neviditelny == false {
                    hrad.poschodia[hrad.currentLevel].boss?.hitted()
                    hrad.poschodia[hrad.currentLevel].boss?.neviditelny = true
                    self.run(.wait(forDuration: 2.0), completion: {
                        self.hrad.poschodia[self.hrad.currentLevel].boss?.neviditelny = false
                    })
                    hrad.poschodia[hrad.currentLevel].bossLife -= 1
                    if hrad.poschodia[hrad.currentLevel].bossLife == 1 {
                        hrad.poschodia[hrad.currentLevel].odstranitKamene()
                        srdce?.uberZivot(naJedna: true)
                        
                        if hrad.poschodia[hrad.currentLevel].bossSet?.cisloBoss == 47 {
                            hrad.poschodia[hrad.currentLevel].boss?.jumpBack()
                            //--nefunguje
                        }
                        rytier.setCollisionPlosina(collisionOn: false)
                        self.hrad.poschodia[self.hrad.currentLevel].bossSet?.vypustitPlosinaPhysic(pravda: true)
                        self.run(.wait(forDuration: 2), completion: {
                           self.hrad.poschodia[self.hrad.currentLevel].bossSet?.vypustitPlosinaPhysic(pravda: false)
                        })
                        
                        
                        
                        self.run(.wait(forDuration: 1.0), completion: {
                            self.hrad.bossFight(tahsie: true)
                        })
                    }
                    
                    hrad.poschodia[hrad.currentLevel].bossSet!.odstranit(cislo: (hrad.poschodia[hrad.currentLevel].typeOfRoom))
                    if hrad.poschodia[hrad.currentLevel].bossLife == 0 {
                        //  0 life
                        srdce?.uberZivot(naJedna: false)
                        self.run(.wait(forDuration: 1.88),completion: {
                            self.srdce?.run(.fadeOut(withDuration: 0.4),completion: {
                                self.srdce?.removeFromParent()
                            })
                        })
                        hrad.killedBoss()
                        /*
                        hrad?.zabilBossaPosunutHrad=true    //--treba poriesit ked oddide
                        hrad?.poschodia[hrad!.currentLevel].bossSet!.odstranit(cislo: (hrad?.poschodia[hrad!.currentLevel].typeOfRoom)!)
                        hrad?.poschodia[self.hrad!.currentLevel].bossSet!.pridatPlosinyNaKonci()
                        hrad?.poschodia[self.hrad!.currentLevel].odstranitKamene()
                        hrad?.poschodia[hrad!.currentLevel].rebriky[0].run(.moveBy(x: 0, y: -112, duration: 1),completion: {
                            self.hrad?.poschodia[self.hrad!.currentLevel].rebriky[0].setPhysics(on: true)
                        })
                        
                        hrad?.poschodia[hrad!.currentLevel].childNode(withName: "boss")?.removeFromParent()
                        hrad?.moveUp(typ: .naKlenbuRebrik)
                        */
                    }
                }
            }
            if y.categoryBitMask == pokladCategory || x.categoryBitMask == pokladCategory {
                //hrad?.poschodia[hrad!.currentLevel].poklad!.texture=SKTexture(imageNamed: "PokladM2")
                //print("Open poklad")
                self.rytier.mecNaPoklade=true
                if rytier.attacking==true {
                    if !hrad.poschodia[hrad.currentLevel].poklad!.otvoreny {
                        pridatMincuAnim(pos: rytier.position, num: 10)
                        hrad.poschodia[hrad.currentLevel].poklad!.openPoklad()
                        numeroMince += 10
                        self.mPocet?.attributedText=NSMutableAttributedString(string: String(numeroMince), attributes: minceTextAttributes)
                        //print(numeroMince)
                    }
                }
                //--pozor tu mam errory, dotkne sa pokladu z ineho poschodia rytier
            }
        }
        
    }
    
    //-------------------------------
    //          DID END
    //-------------------------------
    // MARK: DID END
    func didEnd(_ contact: SKPhysicsContact) {
        let x=contact.bodyB
        let y=contact.bodyA
        //-----ERROR---- DOLE   found nil while unwrapping
        if x.node?.name == "rytier" || y.node?.name == "rytier" {
            if y.categoryBitMask == rebrikCategory || x.categoryBitMask == rebrikCategory {
                //print("Od rebrika")
                rytier.onRebrik=false
                rytier.setPhysicLedder(offPhysic: false)
                rytier.removeAction(forKey: "up")
                rytier.removeAction(forKey: "down")
                /*
                if rytier!.movingUp{        //test
                    rytier?.characterJump(rytierAir: false) //test
                } */
            }
            
            if y.categoryBitMask == pichliaceOhenCategory || x.categoryBitMask == pichliaceOhenCategory {
                if y.node!.name == "Ohen" {
                    rytierNaOheni=false
                    rytierNaPlamen=nil
                }
                if x.node!.name == "Ohen" {
                    rytierNaOheni=false
                    rytierNaPlamen=nil
                }
                if x.node!.name == "Pichs" {
                    rytierNaPich=nil
                    rytierNaPasci=false
                }
                if y.node!.name == "Pichs" {
                    rytierNaPich=nil
                    rytierNaPasci=false
                }
                
            }
            
            
            if y.categoryBitMask == wallCategory || x.categoryBitMask == wallCategory {
                //print("Von zo steny")
                if rytier.doublejumpLeft == 2 {
                    //print("wall - iba jedna :(")
                    rytier.doublejumpLeft = 1
                }
                rytier.onGround=false
                if (rytier.onRebrik==true) {
                    //print("--Na rebriku--")
                    resetRebrik=true    // kvoli pozicii hraca k rebriku
                    rytier.removeAction(forKey: "down")
                    rytier.removeAction(forKey: "up")
                    rytier.setPhysicLedder(offPhysic:true)
    
                }
            }
            if y.categoryBitMask == plosinaCategory || x.categoryBitMask == plosinaCategory {
                if rytier.doublejumpLeft == 2 {
                    //print("plosina - iba jedna :(")
                    rytier
                        .doublejumpLeft = 1
                }
                rytier.onGround=false
                self.rytier.onPlosina=false
                //self.rytier?.isInTheAir=true    //test-vymazat ked tak
                if (rytier.onRebrik==true) {
                    //print("--Na rebriku--")
                    resetRebrik=true    // kvoli pozicii hraca k rebriku
                    rytier.removeAction(forKey: "down")
                    rytier.removeAction(forKey: "up")
                    rytier.setPhysicLedder(offPhysic:true)

                }
            }
            if y.categoryBitMask == dverePressCategory || x.categoryBitMask == dverePressCategory {
                dvereArePressing=false
            }
            
        }
        if x.node!.name == "mec" || y.node!.name == "mec" {
            if y.categoryBitMask == enemyCategory || x.categoryBitMask == enemyCategory {
                self.rytier.mecNaEnemy=false
                enemyFirStr=""
                enemyFirCis=""
                enemySecStr=""
                enemySecCis=""
                
            }
            if y.categoryBitMask == bossCategory || x.categoryBitMask == bossCategory {
                self.rytier.mecNaBoss=false
            }
            if y.categoryBitMask == pokladCategory || x.categoryBitMask == pokladCategory {
                self.rytier.mecNaPoklade=false

            }
        }
        
    }
    
    func pausingScene() {
        pauseM?.isHidden=false
        blackBac?.isHidden=false
        blackBac?.run(.fadeAlpha(to: 0.6, duration: 0))
        self.speed=0
        //self.isPaused=true
        hrad.isPaused=true
        rytier.isPaused=true
        controlis?.isPaused=true
        //print("SHOT2")
    }
    func justPauseForDeath() {
        self.speed=0
        hrad.isPaused=true
        rytier.isPaused=true
        controlis?.isPaused=true
    }
    
    
    
    
    func rytierDied() {
        self.minceSuUkazane=true
        let sucasPosch=self.hrad.poschodia[self.hrad.currentLevel]
        if killedPlayer==false {
            self.diedForDelegate=true
            killedPlayer=true
            self.run(.wait(forDuration: 2.2),completion: {
                self.killedPlayer=false
            })
            mrtvyHrac=true
            self.hrad.mrtvyHrac=true
            sucasPosch.hracMrkev = true
            if sucasPosch.bossSet != nil {
                
                if sucasPosch.bossSet?.firstDeath == false {
                    sucasPosch.bossSet?.firstDeath = true
                    self.run(.wait(forDuration: 5),completion: {
                        sucasPosch.bossSet?.firstDeath = false
                    })
                }
            }
            if self.hrad.poschodia[hrad.currentLevel].bossSet?.cisloBoss == 47 {
                //print("Killed by 7")
                self.hrad.poschodia[hrad.currentLevel].boss?.killedPlayer=true
                self.run(.wait(forDuration: 2),completion: {
                    self.hrad.poschodia[self.hrad.currentLevel].boss?.killedPlayer=false
                })
            }
            zablokovatTouch=true
            UserDefaults.standard.set(numeroMince, forKey: "CoinsAbsolute")
            
            rytierPosBeforeDeath=self.rytier.position
            rytierDeath=PlayerDeath(texture: nil, color: .white, size: CGSize(width: 32, height: 46), typ: self.rytier.skin,otocenyDoLava: self.rytier.otocenyDoLava)
            self.hrad.addChild(rytierDeath!)
            rytierDeath?.position=rytierPosBeforeDeath!
            self.rytier.removeFromParent()
            
            blackBac?.alpha=0.0
            self.run(.wait(forDuration: 1.0),completion: {
                //self.blackBac?.alpha=0.8
                self.blackBac?.run(.fadeAlpha(to: 0.6, duration: 0.3))
            })
            blackBac?.isHidden=false
            
            if rytierWasRevived >= 1000 {  //ZMENIT NA 4 NASPAT !!!!
                let defaults=UserDefaults.standard  //---important---
                if defaults.integer(forKey: "HighScoreAbsolute") < self.hrad.score {
                    jeNajvyssieSkore=true
                    defaults.set(self.hrad.score, forKey: "HighScoreAbsolute")
                } else {
                    jeNajvyssieSkore=false
                }
                defaults.set(self.hrad.score, forKey: "LastGameScoreAbsolute")
                
                self.run(.wait(forDuration: 1.4),completion: {
                    let upp = SKAction.moveBy(x: 0, y: 600, duration: 0.46)
                    upp.timingMode = .easeOut
                    let down=SKAction.moveBy(x: 0, y: -20, duration: 0.2)
                    let up=SKAction.moveBy(x: 0, y: 520, duration: 0.36)
                    down.timingMode = .easeIn
                    up.timingMode = .easeOut
                    self.deathScreen?.isHidden=false
                    self.deathScreen?.run(upp,completion: {
                        self.HighScoreLabel?.run(.scale(to: 1.1, duration: 0.8),completion: {
                            self.HighScoreLabel?.run(.scale(to: 1.0, duration: 0.8),completion: {
                            })
                        })
                        self.deathScreen?.run(down,completion: {
                        })
                        self.zablokovatTouch=false
                    })
                })
                
                if jeNajvyssieSkore {
                    highScore?.isHidden=false
                    normalScore?.isHidden=true
                } else {
                    highScore?.isHidden=true
                    normalScore?.isHidden=false
                }
                scoreHigh?.text="\(String(UserDefaults.standard.integer(forKey: "HighScoreAbsolute")))"
                scoreH?.text="\(String(UserDefaults.standard.integer(forKey: "LastGameScoreAbsolute")))"
                HscoreH?.text="\(String(UserDefaults.standard.integer(forKey: "HighScoreAbsolute")))"
            } else {
                
                self.run(.wait(forDuration: 1.1),completion: {
                    self.continueT?.isHidden=false
                    let down=SKAction.moveBy(x: 0, y: -520, duration: 0.36)
                    let littleUp=SKAction.moveBy(x: 0, y: 20, duration: 0.2)
                    littleUp.timingMode = .easeInEaseOut
                    down.timingMode = .easeOut
                    
                    //--minca ukazat
                    var pocetCifier=1
                    switch self.numeroMince {
                    case 0..<10:
                        pocetCifier=1
                    case 10..<100:
                        pocetCifier=2
                    case 100..<1000:
                        pocetCifier=3
                    case 1000..<10000:
                        pocetCifier=4
                    case 10000..<100000:
                        pocetCifier=5
                    default:
                        pocetCifier=6
                    }
                    
                    let temp=SKAction.moveBy(x: CGFloat(50 + 5*pocetCifier), y: 0, duration: 0.3)
                    temp.timingMode = .easeInEaseOut
                    self.mPocet?.run(.fadeIn(withDuration: 0.3))
                    self.minceSuUkazane=true
                    self.mPocet?.run(temp,completion: {
                    })
                    //--koniec mince
                    self.continueT?.run(down,completion: {
                        
                        self.continueT?.run(littleUp)
                        self.zablokovatTouch=false
                    })
                    
                })
            }
        }
    }
    
    
    //-kvoli chybe v SpriteKite je toto treba, inak by sa v didBegin nemohli posuvat objekty s PhysicBody
    
    override func update(_ currentTime: TimeInterval) {
        let poschodie = hrad.poschodia[hrad.currentLevel]
        
        if rytierNaOheni==true {
            if (rytierNaPlamen) != nil {
                if rytierNaPlamen?.striela==true {
                    rytierDied()
                    rytierNaOheni=false
                    rytierNaPlamen=nil
                }
            }
        }
        if rytierNaPasci==true {
            if (rytierNaPich) != nil {
                if rytierNaPich?.picha==true {
                    rytierDied()
                    rytierNaPasci=false
                    rytierNaPich=nil
                }
            }
        }
        
        
        if comesFromBackground{
            //print("SHIT")
            pauseM?.isHidden=false
            blackBac?.isHidden=false
            blackBac?.run(.fadeAlpha(to: 0.6, duration: 0))
            comesFromBackground = false
            self.speed=0
            //self.isPaused=true
            hrad.isPaused=true
            rytier.isPaused=true
            controlis?.isPaused=true
            
        }
        
        if poschodie.typ == .bossRoom && (poschodie.bossLife) > 0  && poschodie.childNode(withName: "boss") != nil{
            if (poschodie.childNode(withName: "boss")?.position.x)! < (rytier.position.x) {
                poschodie.childNode(withName: "boss")?.xScale = -1
            } else {
                poschodie.childNode(withName: "boss")?.xScale = 1
            }
            
        }
        if reset {
            //moveKnight(goLeft:self.rytier!.goLeftUp)
            rytier.characterCancelMove(left: true)
            rytier.characterCancelMove(left: false)
            var ps:posunutHore = .normal
            if poschodie.typ == .klenbaPolo {
                ps = .zKlebaPolo
                score?.run(.fadeOut(withDuration: 0.6))
                srdce=SrdceBoss(texture: nil, color: nil, size: nil, nic: true)
                self.addChild(srdce!)
                srdce?.run(.fadeOut(withDuration: 0))
                srdce?.run(.wait(forDuration: 1.6),completion: {
                    self.srdce?.run(.fadeIn(withDuration: 0.6))
                })
                srdce?.position.y=300
                
            } else if poschodie.typ == .bossRoom {
                ps = .zKlenbyHore
                score?.run(.fadeIn(withDuration: 0.6))
                self.srdce?.run(.fadeOut(withDuration: 0.6))
            }
            hrad.presunRytier(ryt: self.rytier, typ: ps)
            hrad.moveUp(typ: ps)
            self.kopce?.moveDown()
            self.hory?.moveDown()
        }
        if resetRebrik {
            rytier.physicsBody?.velocity.dy=0
            rytier.removeAllActions()
            if (rytier.movingUp==true) {
                rytier.climbLedder(up: true, positionX: (poschodie.rebriky.last?.position.x)!)
            } else {
                rytier.climbLedder(up: false, positionX: (poschodie.rebriky.last?.position.x)!)
            }
            /*
            if hrad?.poschodia[hrad!.currentLevel].typ == .bossRoom && hrad?.poschodia[hrad!.currentLevel].naRebrikuBolBoss == false{
                hrad?.poschodia[hrad!.currentLevel].naRebrikuBolBoss=true
                hrad?.moveUp(typ: .naKlenbuRebrik)
            }
            */
        }
        
        resetRebrik=false
        reset=false
    }
 
    
    func moveKnight(goLeft:Bool) {
        self.rytier.nextFloor(goLeftUp: goLeft, posunutHore: (self.hrad.poschodia[hrad.currentLevel].posunutPlayerY))
    }
 
    enum ovladanieTla {
        case left
        case right
        case jump
        case mec
    }
 
    func zmenaTexturOvladanie(tlac:ovladanieTla,dole:Bool,all:Bool) {
        if dole {
            switch tlac {
                case .left:
                    self.left?.texture=atlasGameB.textureNamed("LP")
                    break
                case .right:
                    self.right?.texture=atlasGameB.textureNamed("PP")
                    break
                case .jump:
                    self.jump?.texture=atlasGameB.textureNamed("JumpBS")
                    break
                case .mec:
                    self.shoot?.texture=atlasGameB.textureNamed("MecBS")
                    break
            }
        } else {
            switch tlac {
                case .left:
                    self.left?.texture=atlasGameB.textureNamed("L")
                    break
                case .right:
                    self.right?.texture=atlasGameB.textureNamed("P")
                    break
                case .jump:
                    self.jump?.texture=atlasGameB.textureNamed("JumpB")
                    break
                case .mec:
                    self.shoot?.texture=atlasGameB.textureNamed("MecB")
                    break
            }
        }
        if all {
            self.left?.texture=atlasGameB.textureNamed("L")
            self.right?.texture=atlasGameB.textureNamed("P")
            self.jump?.texture=atlasGameB.textureNamed("JumpB")
            self.shoot?.texture=atlasGameB.textureNamed("MecB")
        }
    }
    func pridatMincuAnim(pos:CGPoint, num:Int) {
        //print("Minca ide?")
        mincaPlus=SKLabelNode(text: "+\(num)")
        mincaPlus?.fontName="Kebis_BIT-Regular"
        mincaPlus?.fontSize=28
        mincaPlus?.fontColor = .black
        mincaPlus?.zPosition=105
        hrad.addChild(mincaPlus!)
        mincaPlus?.position=pos
        let anim=SKAction.moveBy(x: 0, y: 30, duration: 2)
        let fade=SKAction.fadeOut(withDuration: 2)
        mincaPlus?.run(anim)
        mincaPlus?.run(fade,completion: {
            self.mincaPlus?.removeFromParent()
        })
        /*
        let lab=SKLabelNode(text: "as+\(num)")
        lab.fontName="BIT"
        lab.fontSize=60
        lab.fontColor = .black
        lab.zPosition=105
        hrad?.addChild(lab)
        lab.position=pos
        let anim=SKAction.moveBy(x: 0, y: 20, duration: 2)
        let fade=SKAction.fadeOut(withDuration: 2)
        lab.run(anim)
        lab.run(fade,completion: {
            lab.removeFromParent()
        })
        */
    }
}
