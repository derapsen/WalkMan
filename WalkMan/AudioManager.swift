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
