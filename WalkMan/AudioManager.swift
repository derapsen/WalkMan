//
//  AudioManager.swift
//  WalkMan
//
//  Created by AppCircle on 2017/07/30.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import MediaPlayer

class AudioManager: NSObject
{
    static let sharedManager = AudioManager()  // singleton
    
    var player = MPMusicPlayerController()
    var mediaItem: MPMediaItem?
    var startTime: Double?
    var endTime: Double?
    
//    var downMediaItem: MPMediaItem?
//    var downStartTime: Double?
//    var downEndTime: Double?
//    
//    var upMediaItem: MPMediaItem?
//    var upStartTime: Double?
//    var upEndTime: Double?
    
    // UserDefaults のインスタンス
    let UD = UserDefaults.standard
    
    let downMediaItemKey: String = "downItem_value"
    let downStartTimeKey: String = "downStart_value"
    let downEndTimeKey: String = "downEnd_value"
    
    let upMediaItemKey: String = "upItem_value"
    let upStartTimeKey: String = "upStart_value"
    let upEndTimeKey: String = "upEnd_value"
    
    private override init()
    {
        self.player = MPMusicPlayerController.systemMusicPlayer()
    }
    
    func ChangeStartTime(start: Double)
    {
        self.startTime = start
    }
    
    func ChangeEndTime(end: Double)
    {
        self.endTime = end
    }
}
