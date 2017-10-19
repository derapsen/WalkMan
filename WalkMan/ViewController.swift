//
//  ViewController.swift
//  WalkMan
//
//  Created by AppCircle on 2017/07/19.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import MediaPlayer

class ViewController: UIViewController, MPMediaPickerControllerDelegate
{
    //var player = MPMusicPlayerController()
    var audioManager: AudioManager = AudioManager.sharedManager
    
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblSong: UILabel!
    
    @IBOutlet weak var btnPause: UIBarButtonItem!
    @IBOutlet weak var btnPlay: UIBarButtonItem!
    @IBOutlet weak var btnStop: UIBarButtonItem!
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var scrubSlider: UISlider!
    
    func changeScrub()
    {
        self.scrubSlider.value = Float(self.audioManager.player.currentPlaybackTime)
        if (self.scrubSlider.value >= Float(self.rangeSlider.upperValue))
        {
            self.barStatusStop()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if (self.audioManager.mediaItem != nil)
        {
            self.Setting()
        }

        var timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changeScrub), userInfo: nil, repeats: true)

        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
        self.btnStop.isEnabled = false
        self.rangeSlider.alpha = 1
        self.rangeSlider.isEnabled = true
        self.scrubSlider.isEnabled = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
     *
     *  曲情報から各部品の設定を行う
     *
     */
    func Setting()
    {
        updateSongInformationUI(mediaItem: self.audioManager.mediaItem!)
        // 再生範囲スライダーの最小値・最大値
        self.rangeSlider.minimumValue = 0
        self.rangeSlider.maximumValue = (self.audioManager.mediaItem?.playbackDuration)!
        // 再生範囲スライダーの下限値・上限値
        self.rangeSlider.lowerValue = 0
        self.rangeSlider.upperValue = (self.audioManager.mediaItem?.playbackDuration)!
        
        self.audioManager.ChangeStartTime(start: self.rangeSlider.lowerValue)
        self.audioManager.ChangeEndTime(end: self.rangeSlider.upperValue)
        
        // 再生位置スライダーの最小値・最大値
        self.scrubSlider.minimumValue = 0
        self.scrubSlider.maximumValue = Float((self.audioManager.mediaItem?.playbackDuration)!)
        // 再生位置スライダーのつまみの初期位置
        self.scrubSlider.value = 0
        
        // 音楽の再生位置を再生範囲スライダーの下限値にする
        self.audioManager.player.currentPlaybackTime = self.rangeSlider.lowerValue
    }
    
    /*
     *
     *  メディアアイテムピッカーでアイテムを選択完了したときに呼び出される
     *
     */
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)
    {
        // 選択した曲情報がmediaItemCollectionに入っているので、これをplayerにセット。
        //self.player.setQueue(with: mediaItemCollection) //
        self.audioManager.player.setQueue(with: mediaItemCollection)
        
        // 選択した曲から最初の曲の情報を表示
        if let mediaItem = mediaItemCollection.items.first  //
        {
            self.audioManager.mediaItem = mediaItem
            updateSongInformationUI(mediaItem: self.audioManager.mediaItem!)
            // 再生範囲スライダーの最小値・最大値
            self.rangeSlider.minimumValue = 0
            self.rangeSlider.maximumValue = (self.audioManager.mediaItem?.playbackDuration)!
            // 再生範囲スライダーの下限値・上限値
            self.rangeSlider.lowerValue = 0
            self.rangeSlider.upperValue = (self.audioManager.mediaItem?.playbackDuration)!
            
            self.audioManager.ChangeStartTime(start: self.rangeSlider.lowerValue)
            self.audioManager.ChangeEndTime(end: self.rangeSlider.upperValue)
            
            // 再生位置スライダーの最小値・最大値
            self.scrubSlider.minimumValue = 0
            self.scrubSlider.maximumValue = Float((self.audioManager.mediaItem?.playbackDuration)!)
            // 再生位置スライダーのつまみの初期位置
            self.scrubSlider.value = 0
            
            // 音楽の再生位置を再生範囲スライダーの下限値にする
            self.audioManager.player.currentPlaybackTime = self.rangeSlider.lowerValue
        }
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    /*
     *
     *  曲情報を表示する
     *
     */
    func updateSongInformationUI(mediaItem: MPMediaItem)
    {
        // 曲情報表示
        self.lblArtist.text = mediaItem.artist ?? "不明なアーティスト"
        self.lblAlbum.text = mediaItem.albumTitle ?? "不明なアルバム"
        self.lblSong.text = mediaItem.title ?? "不明な曲"
        
        // アートワーク表示
        if let artwork = mediaItem.artwork
        {
            let image = artwork.image(at: self.imgArtwork.bounds.size)
            self.imgArtwork.image = image
        }
        else
        {
            // アートワークがないとき
            self.imgArtwork.image = nil
            self.imgArtwork.backgroundColor = UIColor.gray
        }
    }
    
    /*
     *
     *  選択がキャンセルされた場合に呼ばれる
     *
     */
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController)
    {
        // ピッカーを閉じ、破棄する
        dismiss(animated: true, completion: nil)
    }
    
    /*
     *
     *  選曲ボタンタップ処理
     *
     */
    @IBAction func pick(_ sender: Any)
    {
        // MPMediaPickerControllerのインスタンスを作成
        let picker = MPMediaPickerController()
        // ピッカーのデリゲートを設定
        picker.delegate = self
        // 複数選択を不可にする。（trueにすると、複数選択できる）
        picker.allowsPickingMultipleItems = false
        // ピッカーを表示する
        self.present(picker, animated: true, completion: nil)
    }

    /*
     *
     *  再生ボタンタップ処理
     *
     */
    @IBAction func tapPlay(_ sender: UIBarButtonItem)
    {
        self.barStatusPlay()
    }
    func barStatusPlay()
    {
        self.audioManager.player.play()
        self.rangeSlider.alpha = 0.5
        self.rangeSlider.isEnabled = false
        self.btnPause.isEnabled = true
        self.btnPlay.isEnabled = false
        self.btnStop.isEnabled = true
    }
    
    /*
     *
     *  一時停止ボタンタップ処理
     *
     */
    @IBAction func tapPause(_ sender: UIBarButtonItem)
    {
        self.barStatusPause()
    }
    func barStatusPause()
    {
        self.audioManager.player.pause()
        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
        self.btnStop.isEnabled = true
        self.rangeSlider.alpha = 1
        self.rangeSlider.isEnabled = true
        self.scrubSlider.isEnabled = true
    }
    
    /*
     *
     *  停止ボタンタップ処理
     *
     */
    @IBAction func tapStop(_ sender: UIBarButtonItem)
    {
        self.barStatusStop()
    }
    func barStatusStop()
    {
        self.audioManager.player.pause()
        self.audioManager.player.currentPlaybackTime = self.rangeSlider.lowerValue
        self.scrubSlider.value = Float(self.rangeSlider.lowerValue)
        self.btnPause.isEnabled = false
        self.btnPlay.isEnabled = true
        self.btnStop.isEnabled = false
        self.rangeSlider.alpha = 1
        self.rangeSlider.isEnabled = true
        self.scrubSlider.isEnabled = true
    }
    
    /*
     *
     *  再生範囲スライダーの下限値・上限値の更新
     *
     */
    @IBAction func changeRangeValue(_ sender: RangeSlider)
    {
        if (sender.lowerValue >= Double(self.scrubSlider.value))
        {
            sender.lowerValue = Double(self.scrubSlider.value)
            self.audioManager.ChangeStartTime(start: sender.lowerValue)
        }
        if (sender.upperValue < Double(self.scrubSlider.value))
        {
            sender.upperValue = Double(self.scrubSlider.value)
            self.audioManager.ChangeEndTime(end: sender.upperValue)
        }
        self.audioManager.player.currentPlaybackTime = Double(self.scrubSlider.value)
    }
    
    /*
     *
     *  再生位置スライダーの値の更新時、曲の再生位置も更新
     *
     */
    @IBAction func changeScrubValue(_ sender: UISlider)
    {
        if (sender.value <= Float(self.rangeSlider.lowerValue))
        {
            sender.value = Float(self.rangeSlider.lowerValue)
        }
        if (sender.value > Float(self.rangeSlider.upperValue))
        {
            sender.value = Float(self.rangeSlider.upperValue)
        }
        self.audioManager.player.currentPlaybackTime = Double(sender.value)
    }
    @IBAction func tapMain(_ sender: Any)
    {
        self.audioManager.player.pause()
        self.audioManager.player.currentPlaybackTime = self.audioManager.startTime!
    }
}

