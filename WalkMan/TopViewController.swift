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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.Setting()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func Setting()
    {
        self.btnPlay.layer.cornerRadius = 40
        
        if (self.audioManager.mediaItem?.playbackDuration == nil)
        {
            self.btnPlay.isEnabled = false
        }
        else
        {
            self.btnPlay.isEnabled = true
        }
    }
    
    /*
     *
     *  曲編集ボタン処理
     *
     */
    @IBAction func tapEdit(_ sender: Any)
    {
        self.audioManager.player.pause()
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
                sender.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                sender.setTitle("II", for: UIControlState.normal)
                self.btnEdit.isEnabled = false
                self.btnEdit.alpha = 0.6
            }
            else
            {
                sender.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
                sender.setTitle("▶︎", for: UIControlState.normal)
                self.btnEdit.isEnabled = true
                self.btnEdit.alpha = 1.0
            }
        }
        else
        {
            self.btnPlay.isEnabled = false
        }
    }
}
