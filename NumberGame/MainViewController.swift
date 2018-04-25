//
//  MainViewController.swift
//  NumberGame
//
//  Created by Chi-Che Hsieh on 2018/4/6.
//  Copyright © 2018年 ppquitmax. All rights reserved.
//

import UIKit
import GameplayKit

let randomDistribution = GKRandomDistribution(lowestValue: 0, highestValue: 2)
let pcRandomNumber = GKRandomDistribution(lowestValue: 0, highestValue: 4)

enum GameStatus {
    case gameStart
    case gamePeterTurn
    case gamePCTurn
    case gameResult
}

var gameStatus = GameStatus.gameStart
var numberOfPeter:Int = 0
var numberOfPC:Int = 0

var pcWinCount:Int = 0
var peterWinCount:Int = 0

class MainViewController: UIViewController {
    @IBOutlet weak var mainUILabel: UILabel!
    @IBOutlet weak var myUIImage: UIImageView!
    @IBOutlet weak var pcUIImage: UIImageView!
    @IBOutlet weak var pcnumberImage: UIImageView!
    @IBOutlet weak var peternumberImage: UIImageView!
    
    @IBOutlet weak var selectUISegmentControl: UISegmentedControl!
    @IBOutlet weak var oderUISegmentControl: UISegmentedControl!
    @IBOutlet weak var checkUIButton: UIButton!
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        checkUIButton.isEnabled = true
        
        switch selectUISegmentControl.selectedSegmentIndex {
        case 0:
            if gameStatus == .gameStart {
                myUIImage.image = #imageLiteral(resourceName: "sign01")
            } else {
                myUIImage.image = #imageLiteral(resourceName: "order00")
                numberOfPeter = 0
            }
        case 1:
            if gameStatus == .gameStart {
                myUIImage.image = #imageLiteral(resourceName: "sign02")
            } else {
                myUIImage.image = #imageLiteral(resourceName: "order01_1")
                numberOfPeter = 5
            }
        case 2:
            if gameStatus == .gameStart {
                myUIImage.image = #imageLiteral(resourceName: "sign03")
            } else {
                myUIImage.image = #imageLiteral(resourceName: "order02")
                numberOfPeter = 10
            }
        default: break
        }
    }
    
    @IBAction func myButton(_ sender: Any) {
        let pcSignRandom = randomDistribution.nextInt()
        let pcOrderNumber = pcRandomNumber.nextInt()
        
        switch pcSignRandom {
        case 0:
            if gameStatus == .gameStart {
                pcUIImage.image = #imageLiteral(resourceName: "sign01")
            } else {
                pcUIImage.image = #imageLiteral(resourceName: "order00")
                numberOfPC = 0
            }
        case 1:
            if gameStatus == .gameStart {
                pcUIImage.image = #imageLiteral(resourceName: "sign02")
            } else {
                pcUIImage.image = #imageLiteral(resourceName: "order01_2")
                numberOfPC = 5
            }
        case 2:
            if gameStatus == .gameStart {
                pcUIImage.image = #imageLiteral(resourceName: "sign03")
            } else {
                pcUIImage.image = #imageLiteral(resourceName: "order02")
                numberOfPC = 10
            }
        default:
            break
        }
        
        if gameStatus == .gameStart {
            if pcUIImage.image == myUIImage.image{
                mainUILabel.text = "平手"
            } else {
                if myUIImage.image == #imageLiteral(resourceName: "sign01"){
                    if pcUIImage.image == #imageLiteral(resourceName: "sign02") {
                        mainUILabel.text = "電腦先攻"
                        gameStatus = .gamePCTurn
                    }
                    else {
                        mainUILabel.text = "Peter先攻"
                        gameStatus = .gamePeterTurn
                        oderUISegmentControl.isEnabled = true
                    }
                }
                else if myUIImage.image == #imageLiteral(resourceName: "sign02"){
                    if pcUIImage.image == #imageLiteral(resourceName: "sign03") {
                        mainUILabel.text = "電腦先攻"
                        gameStatus = .gamePCTurn
                    }
                    else {
                        mainUILabel.text = "Peter先攻"
                        gameStatus = .gamePeterTurn
                        oderUISegmentControl.isEnabled = true
                    }
                }
                else if myUIImage.image == #imageLiteral(resourceName: "sign03"){
                    if pcUIImage.image == #imageLiteral(resourceName: "sign01") {
                        mainUILabel.text = "電腦先攻"
                        gameStatus = .gamePCTurn
                    }
                    else {
                        mainUILabel.text = "Peter先攻"
                        gameStatus = .gamePeterTurn
                        oderUISegmentControl.isEnabled = true
                    }
                }
                checkUIButton.isEnabled = false
                // Delay time, now + time
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.myUIImage.image = #imageLiteral(resourceName: "order010203")
                    self.pcUIImage.image = #imageLiteral(resourceName: "wait")
                    
                    self.selectUISegmentControl.setTitle("👊👊", forSegmentAt: 0)
                    self.selectUISegmentControl.setTitle("👊🖐️", forSegmentAt: 1)
                    self.selectUISegmentControl.setTitle("🖐️✋", forSegmentAt: 2)
                    
                    self.selectUISegmentControl.selectedSegmentIndex = -1
                }
                
            }
        } else if gameStatus == .gamePCTurn || gameStatus == .gamePeterTurn {
            //mainUILabel.text = "Peter出\(numberOfPeter), PC出\(numberOfPC), 總共\(numberOfPeter+numberOfPC)"
            if gameStatus == .gamePCTurn {
                switch pcOrderNumber {
                case 0:
                    pcnumberImage.image = #imageLiteral(resourceName: "pcNumber00")
                case 1:
                    pcnumberImage.image = #imageLiteral(resourceName: "pcNumber05")
                case 2:
                    pcnumberImage.image = #imageLiteral(resourceName: "pcNumber10")
                case 3:
                    pcnumberImage.image = #imageLiteral(resourceName: "pcNumber15")
                case 4:
                    pcnumberImage.image = #imageLiteral(resourceName: "pcNumber20")
                default:
                    break
                }
                
                mainUILabel.text = "總共\(numberOfPeter+numberOfPC)  PC猜\(pcOrderNumber*5)"
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    if pcOrderNumber*5 == numberOfPeter+numberOfPC {
                        if pcWinCount == 1 {
                            self.mainUILabel.text = "PC猜中兩次 勝出!"
                            self.mainUILabel.textColor = UIColor.red
                            gameStatus = .gameResult
                            self.checkUIButton.titleLabel?.text = "重新開始"
                        } else {
                            self.mainUILabel.text = "PC猜中一次，繼續"
                            pcWinCount += 1
                        }
                    } else {
                        self.mainUILabel.text = "PC沒猜中, 換Peter"
                        self.oderUISegmentControl.isEnabled = true
                        self.oderUISegmentControl.selectedSegmentIndex = -1
                        gameStatus = .gamePeterTurn
                        self.pcnumberImage.image = nil
                        pcWinCount = 0
                    }
                }
                
            } else if gameStatus == .gamePeterTurn {
                if oderUISegmentControl.selectedSegmentIndex == -1 {
                    mainUILabel.text = "請選擇出拳及喊的數字!"
                    pcUIImage.image = #imageLiteral(resourceName: "wait")
                } else {
                    switch oderUISegmentControl.selectedSegmentIndex {
                    case 0:
                        peternumberImage.image = #imageLiteral(resourceName: "peterNumber00")
                    case 1:
                        peternumberImage.image = #imageLiteral(resourceName: "peterNumber05")
                    case 2:
                        peternumberImage.image = #imageLiteral(resourceName: "peterNumber10")
                    case 3:
                        peternumberImage.image = #imageLiteral(resourceName: "peterNumber15")
                    case 4:
                        peternumberImage.image = #imageLiteral(resourceName: "peterNumber20")
                    default:
                        break
                    }
                    
                    mainUILabel.text = "總共\(numberOfPeter+numberOfPC)  Peter猜\(oderUISegmentControl.selectedSegmentIndex*5)"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        if self.oderUISegmentControl.selectedSegmentIndex*5 == numberOfPeter+numberOfPC {
                            if peterWinCount == 1 {
                                self.mainUILabel.text = "Peter猜中兩次 勝出!"
                                self.mainUILabel.textColor = UIColor.red
                                gameStatus = .gameResult
                                self.checkUIButton.titleLabel?.text = "重新開始"
                            } else {
                                self.mainUILabel.text = "Peter猜中一次，繼續"
                                peterWinCount += 1
                            }
                        } else {
                            self.mainUILabel.text = "Peter沒猜中, 換PC"
                            self.oderUISegmentControl.isEnabled = false
                            self.oderUISegmentControl.selectedSegmentIndex = -1
                            gameStatus = .gamePCTurn
                            self.peternumberImage.image = nil
                            peterWinCount = 0
                        }
                    }
                }
            }
        } else if gameStatus == .gameResult {
            pcnumberImage.image = nil
            peternumberImage.image = nil
            myUIImage.image = #imageLiteral(resourceName: "sign010203")
            pcUIImage.image = #imageLiteral(resourceName: "wait")
            mainUILabel.text = "遊戲開始 猜拳決定順序"
            mainUILabel.textColor = UIColor.black
            
            checkUIButton.isEnabled = false
            selectUISegmentControl.selectedSegmentIndex = -1
            oderUISegmentControl.selectedSegmentIndex = -1
            oderUISegmentControl.isEnabled = false
        }
        // satus1
        
        
        //status2
        
        
        

    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oderUISegmentControl.isEnabled = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
