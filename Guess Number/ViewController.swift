//
//  ViewController.swift
//  Guess Number
//
//  Created by Min Hu on 2023/9/19.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // 主畫面
    @IBOutlet weak var player1NameTextField: UITextField! // 玩家一名字的 Text Field
    
    @IBOutlet weak var arrow1: UIImageView! // 指示輪到玩家一猜數字的箭頭 Image View
    
    @IBOutlet weak var segmentedControl1: UISegmentedControl! // 玩家一選顯圖：女孩/男孩圖片
    
    @IBOutlet weak var player2NameTextField: UITextField! // 玩家二名字的 Text Field
    
    @IBOutlet weak var arrow2: UIImageView! // 指示輪到玩家二猜數字的箭頭 Image View
    
    @IBOutlet weak var segmentedControl2: UISegmentedControl! // 玩家二選顯圖：女孩/男孩圖片
    
    @IBOutlet weak var score1ImageView: UIImageView! // 玩家一的勝利回合計分
    
    @IBOutlet weak var score2ImageView: UIImageView! // 玩家二的勝利回合計分
 
    
    @IBOutlet weak var numberShowLabel: UILabel! // 中央顯示玩家猜的數字的區塊
    
    @IBOutlet weak var rangeLabel: UILabel!  // 在猜數字區塊下緣，顯示數字範圍或警告提示的文字 Label
    
    // 玩家輸一回合的畫面
    @IBOutlet var ViewOfLose: UIView! // 整個畫面 View
    
    @IBOutlet weak var losePicImageView: UIImageView! // 輸家顯圖 Image View
    
    @IBOutlet weak var loserNameLabel: UILabel! // 輸家名字

    // 玩家獲勝畫面
    @IBOutlet var ViewOfWinner: UIView! // 整個畫面 View
    
    @IBOutlet weak var winPicImageView: UIImageView! // 贏家顯圖 Image View
   
    @IBOutlet weak var winnerNameLabel: UILabel! // 贏家名字
    
    var inputNumber = "" // 玩家輸入的數字，型別為 String
    var number = 0 // App 亂數出的終極密碼
    var littleNumber = 1 // 猜數字範圍的最小值，初始為 1
    var bigNumber = 99 // 猜數字範圍的最大值，初始為 99
    let soundplayer = AVPlayer() // 創建音效播放器
    
    // 載入 Controller View 的初始設定
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetGame()
    }
    
    // 重設遊戲
    func resetGame(){
        // 隱藏失敗或勝利畫面
        ViewOfLose.isHidden = true
        ViewOfWinner.isHidden = true
        // 箭頭回到玩家一旁邊
        arrow1.isHidden = false
        arrow2.isHidden = true
        // 重新亂數
        number = Int.random(in: 1...99)
        print(number)
        // 顯示最初範圍
        rangeLabel.text = "1 - 99 猜個數字"
        // 回合歸 0
        score1ImageView.image = UIImage(named: "number_0")
        score2ImageView.image = UIImage(named: "number_0")
        // 失敗或勝利畫面中的勝者敗者名稱清空
        winnerNameLabel.text = ""
        loserNameLabel.text = ""
    }

    // 點按數字鍵
    @IBAction func clickNumberButton(_ sender: UIButton) {
        // 使用 Binding Optional 檢查 titleLabel 是否有文字
        if let numberString = sender.titleLabel?.text{
            // 如果輸入的字串長度小於 2
            if inputNumber.count < 2 {
                // soundplayer 替換為普通按鍵音效
                let clickNumberSoundUrl = Bundle.main.url(forResource: "shooting-sound", withExtension: "mp3")!
                let clickNumberSoundPlayerItem = AVPlayerItem(url: clickNumberSoundUrl)
                soundplayer.replaceCurrentItem(with: clickNumberSoundPlayerItem)
                // 將剛輸入的數字加到 inputNumber 中
                inputNumber += numberString
                // 更新中央顯示已輸入數字的區塊
                numberShowLabel.text = inputNumber
            // 如果輸入的字串長度大於等於 2
            }else{
                // soundplayer 替換為錯誤音效
                let clickNumberSoundUrl = Bundle.main.url(forResource: "negative", withExtension: "mp3")!
                let clickNumberSoundPlayerItem = AVPlayerItem(url: clickNumberSoundUrl)
                soundplayer.replaceCurrentItem(with: clickNumberSoundPlayerItem)
                // 顯示警告：最多兩位數
                rangeLabel.text = "最多兩位數！"
            }
        }
        soundplayer.play() // 播放音效
    }
    // 點按 reset 鍵清空已輸入的數字
    @IBAction func resetNumber(_ sender: UIButton) {
        // 清除鍵音效
        let clickResetSoundUrl = Bundle.main.url(forResource: "select-sound", withExtension: "mp3")!
        let clickResetSoundPlayerItem = AVPlayerItem(url: clickResetSoundUrl)
        soundplayer.replaceCurrentItem(with: clickResetSoundPlayerItem)
        soundplayer.play()
        // 清空內容
        inputNumber = ""
        numberShowLabel.text = inputNumber
        // 繼續顯示範圍
        rangeLabel.text = "\(littleNumber) - \(bigNumber) 猜個數字"
    }
    // 點按 OK 鍵
    @IBAction func clickOK(_ sender: UIButton) {
        // 設定 OK 鍵音效
        let clickOKSoundUrl = Bundle.main.url(forResource: "select-sound", withExtension: "mp3")!
        let clickOKSoundPlayerItem = AVPlayerItem(url: clickOKSoundUrl)
        soundplayer.replaceCurrentItem(with: clickOKSoundPlayerItem)
        
        print(inputNumber)// 列印亂數數字後台可見
        // 如果有輸入數字（沒輸入數字沒有任何反應，只會聽到點擊音效）
        if inputNumber != ""{
            let inputIntNumber = Int(inputNumber) // 將輸入本為 String 的數字轉變為 Int
            // 如果輸入的數字小於等於最大數值並且大於等於最小數值
            if inputIntNumber! <= bigNumber && inputIntNumber! >= littleNumber{
                // 如果輸入的數字小於這次遊戲答案數字 number
                if inputIntNumber! < number{
                    // 如果輸入的數字等於最小數值
                    if inputIntNumber! == littleNumber{
                        // 最小數值 + 1
                        littleNumber += 1
                    }else{// 如果輸入的數字不等於最小數值
                        // 最小數值 = 輸入數值
                        littleNumber = inputIntNumber!
                    }
                    // 更新數字範圍
                    rangeLabel.text = "\(littleNumber) - \(bigNumber) 猜個數字"
                    // 交換箭頭位置
                    if arrow1.isHidden == true{ // 如果箭頭沒指著玩家一
                        arrow1.isHidden = false // 玩家一改為顯示
                        arrow2.isHidden = true  // 玩家二改為隱藏
                    }else{ // 如果箭頭指著玩家一
                        arrow1.isHidden = true // 玩家一改為隱藏
                        arrow2.isHidden = false // 玩家二改為顯示
                    }
                    
                    // 如果輸入的數字大於這次遊戲答案數字 number
                }else if inputIntNumber! > number{
                    // 如果輸入的數字等於最大數值
                    if inputIntNumber! == bigNumber{
                        // 最大數值 - 1
                        bigNumber -= 1
                    }else{ // 如果輸入的數字不等於最大數值
                        // 最大數值 = 輸入數值
                        bigNumber = inputIntNumber!
                    }
                    // 更新數字範圍
                    rangeLabel.text = "\(littleNumber) - \(bigNumber) 猜個數字"
                    // 交換箭頭位置
                    if arrow1.isHidden == true{ // 如果箭頭沒指著玩家一
                        arrow1.isHidden = false // 玩家一改為顯示
                        arrow2.isHidden = true // 玩家二改為隱藏
                    }else{ // 如果箭頭指著玩家一
                        arrow1.isHidden = true // 玩家一改為隱藏
                        arrow2.isHidden = false // 玩家二改為顯示
                    }
                    // 如果輸入的數字等於這次遊戲答案數字 number
                }else if inputIntNumber! == number{
                    littleNumber = 1 // 最小數字回歸為 1
                    bigNumber = 99 // 最大數字回歸為 99
                    // 若玩家一輸且玩家二贏0回合
                    if arrow1.isHidden == false && score2ImageView.image == UIImage(named: "number_0"){
                        // 更改為失敗音效
                        let loseSoundUrl = Bundle.main.url(forResource: "wrong-buzzer", withExtension: "mp3")!
                        let loseSoundPlayerItem = AVPlayerItem(url: loseSoundUrl)
                        soundplayer.replaceCurrentItem(with: loseSoundPlayerItem)
                        // 如果玩家選擇 Girl
                        if segmentedControl1.selectedSegmentIndex == 0{
                            //輸家圖像換成女孩
                            losePicImageView.image = UIImage(named: "pose_lose_girl")
                            // 如果玩家選擇 Boy
                        }else if segmentedControl1.selectedSegmentIndex == 1{
                            //輸家圖像換成男孩
                            losePicImageView.image = UIImage(named: "pose_lose_boy")
                        }
                        // 玩家二的計分板數字更新為 1
                        score2ImageView.image = UIImage(named: "number_1")
                        // 顯示玩家輸一回合的畫面
                        ViewOfLose.isHidden = false
                        // 如果玩家一沒有填寫名字
                        if player1NameTextField.text == ""{
                            // 則顯示輸家名字為 Player 1
                            loserNameLabel.text = "Player 1"
                        }else{ // 如果玩家一有填寫名字
                            // 則顯示輸家名字為玩家一填寫的名字
                            loserNameLabel.text = player1NameTextField.text
                        }
                        // 交換箭頭位置
                        if arrow1.isHidden == true{
                            arrow1.isHidden = false
                            arrow2.isHidden = true
                        }else{
                            arrow1.isHidden = true
                            arrow2.isHidden = false
                        }
                        // 玩家一輸且玩家二贏1回合
                    }else if arrow1.isHidden == false && score2ImageView.image == UIImage(named: "number_1"){
                        let winSoundUrl = Bundle.main.url(forResource: "success-fanfare-trumpets", withExtension: "mp3")!
                        let winSoundPlayerItem = AVPlayerItem(url: winSoundUrl)
                        soundplayer.replaceCurrentItem(with: winSoundPlayerItem)
                        if segmentedControl2.selectedSegmentIndex == 0{
                            winPicImageView.image = UIImage(named: "pose_win_girl")
                        }else if segmentedControl2.selectedSegmentIndex == 1{
                            winPicImageView.image = UIImage(named: "pose_win_boy")
                        }
                        score2ImageView.image = UIImage(named: "number_2")
                        // 顯示玩家獲勝畫面
                        ViewOfWinner.isHidden = false
                        if player2NameTextField.text == ""{
                            winnerNameLabel.text = "Player 2"
                        }else{
                            winnerNameLabel.text = player2NameTextField.text
                        }
                        // 玩家二輸且玩家一贏0回合
                    }else if arrow2.isHidden == false && score1ImageView.image == UIImage(named: "number_0"){
                        let loseSoundUrl = Bundle.main.url(forResource: "wrong-buzzer", withExtension: "mp3")!
                        let loseSoundPlayerItem = AVPlayerItem(url: loseSoundUrl)
                        soundplayer.replaceCurrentItem(with: loseSoundPlayerItem)
                       
                        if segmentedControl2.selectedSegmentIndex == 0{
                            losePicImageView.image = UIImage(named: "pose_lose_girl")
                        }else if segmentedControl2.selectedSegmentIndex == 1{
                            losePicImageView.image = UIImage(named: "pose_lose_boy")
                        }
                        score1ImageView.image = UIImage(named: "number_1")
                        ViewOfLose.isHidden = false
                        if player2NameTextField.text == ""{
                            loserNameLabel.text = "Player 2"
                        }else{
                            loserNameLabel.text = player2NameTextField.text
                        }
                        if arrow1.isHidden == true{
                            arrow1.isHidden = false
                            arrow2.isHidden = true
                        }else{
                            arrow1.isHidden = true
                            arrow2.isHidden = false
                        }
                        // 玩家二輸且玩家一贏1回合
                    }else if arrow2.isHidden == false && score1ImageView.image == UIImage(named: "number_1"){
                        let winSoundUrl = Bundle.main.url(forResource: "success-fanfare-trumpets", withExtension: "mp3")!
                        let winSoundPlayerItem = AVPlayerItem(url: winSoundUrl)
                        soundplayer.replaceCurrentItem(with: winSoundPlayerItem)
                        if segmentedControl1.selectedSegmentIndex == 0{
                            winPicImageView.image = UIImage(named: "pose_win_girl")
                        }else if segmentedControl1.selectedSegmentIndex == 1{
                            winPicImageView.image = UIImage(named: "pose_win_boy")
                        }
                        score1ImageView.image = UIImage(named: "number_2")
                        ViewOfWinner.isHidden = false
                        if player1NameTextField.text == ""{
                            winnerNameLabel.text = "Player 1"
                        }else{
                            winnerNameLabel.text = player1NameTextField.text
                        }
                    }
                }
                inputNumber = "" // 清空輸入的數字
                numberShowLabel.text = inputNumber // 將清空的數字更新到顯示欄中，顯示欄更新為沒數字
                // 如果輸入的數字大於最大數值或小於最小數值
            }else{
                // 設置錯誤音效
                let outOfRangeSoundUrl = Bundle.main.url(forResource: "negative", withExtension: "mp3")!
                let ourOfRangeSoundPlayerItem = AVPlayerItem(url: outOfRangeSoundUrl)
                soundplayer.replaceCurrentItem(with: ourOfRangeSoundPlayerItem)
                // 顯示超出範圍警告
                rangeLabel.text = "超出 \(littleNumber) - \(bigNumber) 範圍！"
                // 清空數字欄
                inputNumber = ""
                numberShowLabel.text = inputNumber
                
            }
        }
        soundplayer.play() // 播放音效
    }
    // 點按開啟下一回合
    @IBAction func clickNextRound(_ sender: UIButton) {
        let clickNewGameSoundUrl = Bundle.main.url(forResource: "select-sound", withExtension: "mp3")!
        let clickNewGameSoundPlayerItem = AVPlayerItem(url: clickNewGameSoundUrl)
        soundplayer.replaceCurrentItem(with: clickNewGameSoundPlayerItem)
        soundplayer.play()
        ViewOfLose.isHidden = true // 隱藏玩家輸一回合的畫面
        number = Int.random(in: 1...99)
        print(number)
        rangeLabel.text = "1 - 99 猜個數字"
        winnerNameLabel.text = ""
        loserNameLabel.text = ""
    }
    // 點按開啟下一次遊戲（呼叫重設遊戲）
    @IBAction func clickNewGame(_ sender: UIButton) {
        let clickNewGameSoundUrl = Bundle.main.url(forResource: "select-sound", withExtension: "mp3")!
        let clickNewGameSoundPlayerItem = AVPlayerItem(url: clickNewGameSoundUrl)
        soundplayer.replaceCurrentItem(with: clickNewGameSoundPlayerItem)
        soundplayer.play()
        resetGame()
    }
    
    // 玩家一選擇顯圖
    @IBAction func chooseGender1(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            losePicImageView.image = UIImage(named: "pose_lose_girl")
            winPicImageView.image = UIImage(named: "pose_win_girl")
        } else if sender.selectedSegmentIndex == 1{
            losePicImageView.image = UIImage(named: "pose_lose_boy")
            winPicImageView.image = UIImage(named: "pose_win_boy")
        }
    }
    // 玩家二選擇顯圖
    @IBAction func chooseGender2(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            losePicImageView.image = UIImage(named: "pose_lose_girl")
            winPicImageView.image = UIImage(named: "pose_win_girl")
        } else if sender.selectedSegmentIndex == 1{
            losePicImageView.image = UIImage(named: "pose_lose_boy")
            winPicImageView.image = UIImage(named: "pose_win_boy")
        }
    }
}

