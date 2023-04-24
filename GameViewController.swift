//
//  GameViewController.swift
//  Rytier
//
//  Created by Juraj Kebis on 17/03/2020.
//  Copyright © 2020 Juraj Kebis. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController, SKSceneDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            
            if let scene = SKScene(fileNamed: "GameScene") {    //GameScene FinishTowerScene
                //scene.scaleMode = .aspectFill
                scene.scaleMode = .aspectFit
                view.presentScene(scene)
                scene.delegate=self
                //view.showsFPS = true
                //view.showsNodeCount = true
                //view.showsPhysics = true
                view.ignoresSiblingOrder = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) { //kvoli erroru ignoreRenderSyncInLayoutSubviews is NO
        NotificationCenter.default.addObserver(self, selector: #selector(doMencu), name: NSNotification.Name(rawValue: "segue3") as NSNotification.Name, object: nil)    // neviem este poriadne ako funguje ale je to nieco ako delegat, takze gamescene cez neho vola funkciu na tejto urovni
        NotificationCenter.default.addObserver(self, selector: #selector(restartGame), name: NSNotification.Name(rawValue: "segueRestart") as NSNotification.Name, object: nil)
    }
    
    @objc func doMencu() {
        //self.dismiss(animated: true, completion: nil)   // zrusime tuto VC
        performSegue(withIdentifier: "unwindBackToM", sender: self) //GoBackToTheShadow
        //self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)    // pouziva sa na zrusenie vsetkeho a vratenie na root, hlavnu VC, neviem ci to uplne funguje
    }
    @objc func restartGame() {
        if let view = self.view as? SKView {
                   if let scene = SKScene(fileNamed: "GameScene") {
                       scene.scaleMode = .aspectFill
                       view.presentScene(scene)
                       scene.delegate=self
                       //view.showsFPS = true
                       //view.showsNodeCount = true
                       //view.showsPhysics = true
                       view.ignoresSiblingOrder = true
                   }
               }
    }
    
    override var prefersStatusBarHidden: Bool {
      return true
    }
    
    func comesFromBackground()
    {
        print("Comes from background")
        let skView: SKView = self.view as! SKView
        let scene = skView.scene as! GameScene
        if scene.diedForDelegate || scene.rytierJePodHradom {
            scene.isPaused=true
        } else {
            scene.pausingScene()
            scene.comesFromBackground = true
        }
    }
    
    
}

