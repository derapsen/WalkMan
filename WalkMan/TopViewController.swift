//
//  TopViewController.swift
//  WalkMan
//
//  Created by AppCircle on 2017/07/30.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import CoreMotion

class TopViewController: UIViewController
{
    @IBOutlet weak var lblSelectName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    
    // メンバー変数でないと動作しないので注意
    let pedometer = CMPedometer()
    
    var audioManager: AudioManager = AudioManager.sharedManager
    var isPlay: Bool = false
    var isTimer: Bool = false
    var isStep: Bool = false
    
    var timer: Timer?
    
    var steps: Int = 0
    var distance: Double = 0
    var speed: Double = 0
    
    func checkpedo()
    {
        if (self.steps == 0)
        {
            self.audioManager.player.play()
        }
        else
        {
            if (self.speed <= 0)
            {
                self.audioManager.player.pause()
            }
        }
        
        if (self.audioManager.player.currentPlaybackTime >= self.audioManager.endTime!)
        {
            self.audioManager.player.currentPlaybackTime = self.audioManager.startTime!
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.btnPlay.layer.cornerRadius = 40
        
        self.btnEdit.isEnabled = true
        self.btnEdit.alpha = 1.0
        
        if (self.audioManager.mediaItem?.playbackDuration == nil)
        {
            self.lblSelectName.text = "曲を選択してください"
            self.btnPlay.isEnabled = false
        }
        else
        {
            self.lblSelectName.text = self.audioManager.mediaItem?.title ?? "不明な曲"
            self.btnPlay.isEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
     *
     *  曲編集ボタン処理
     *
     */
    @IBAction func tapEdit(_ sender: Any)
    {
        self.audioManager.player.pause()
        performSegue(withIdentifier: "goEdit", sender: nil)
    }

    /*
     *
     *  曲再生ボタン処理
     *
     */
    @IBAction func tapPlay(_ sender: UIButton)
    {
        if (self.audioManager.mediaItem != nil)
        {
            self.btnPlay.isEnabled = true
            self.isPlay = !self.isPlay
            if (self.isPlay)
            {
                self.startStepCounting()
                self.audioManager.player.currentPlaybackTime = self.audioManager.startTime!
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkpedo), userInfo: nil, repeats: true)
                self.timer?.fire()
                self.isTimer = true
                sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                sender.setTitle("II", for: UIControlState.normal)
                self.btnEdit.isEnabled = false
                self.btnEdit.alpha = 0.6
            }
            else
            {
                self.pedometer.stopUpdates()
                self.isTimer = false
                self.timer?.invalidate()
                sender.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
                sender.setTitle("▶︎", for: UIControlState.normal)
                self.btnEdit.isEnabled = true
                self.btnEdit.alpha = 1.0
            }
        }
        else
        {
            self.pedometer.stopUpdates()
            self.btnPlay.isEnabled = false
        }
    }
    
    func startStepCounting() {
        // CMPedometerが利用できるか確認
        if CMPedometer.isStepCountingAvailable() {
            // 計測開始
            self.pedometer.startUpdates(from: NSDate() as Date, withHandler: {
                [unowned self] data, error in
                DispatchQueue.main.async(execute: {
                    if(error == nil){
                        //let lengthFormatter = LengthFormatter()
                        // 歩数
                        self.steps = data?.numberOfSteps as! Int
                        // 距離
                        self.distance = (data?.distance?.doubleValue)!
                        // 速さ
                        let time = data?.endDate.timeIntervalSince((data?.startDate)!)
                        self.speed = self.distance / time!
                        
                        
                    }
                })
            })
        }
    }
}
