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
    
    @IBOutlet weak var btnUpDown: UIBarButtonItem!
    @IBOutlet weak var btnDown: InvertedTriangleButton!
    @IBOutlet weak var btnUp: TriangleButton!
    
    var audioManager: AudioManager = AudioManager.sharedManager
    var isUpDown: Bool = false
    
    
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

    }
    
    
    /*
     *
     *  UPボタン処理
     *
     */
    @IBAction func UPTapAction(_ sender: Any)
    {
        performSegue(withIdentifier: "goEdit", sender: "UP")
    }
    
    /*
     *
     *  DOWNボタン処理
     *
     */
    @IBAction func DOWNTapAction(_ sender: Any)
    {
        performSegue(withIdentifier: "goEdit", sender: "DOWN")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "goEdit"
        {
            let editViewController = segue.destination as! EditViewController
            editViewController.typeUPDOWN = sender as! String
            
            if (editViewController.typeUPDOWN == "UP")
            {
                editViewController.viewBackground.backgroundColor = self.UIColorFromRGB(rgbValue: 0xFFA000)
            }
            else
            {
                editViewController.viewBackground.backgroundColor = self.UIColorFromRGB(rgbValue: 0x00B8FA)
            }
            editViewController.topNavi.title = editViewController.typeUPDOWN
        }
    }
    
    /*
     *
     *  UIColorHEX処理
     *
     */
    func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor
        (
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /*
     *
     *  上り下り計測処理
     *
     */
    @IBAction func upDownAction(_ sender: Any)
    {
        print("hoge")
        if (self.audioManager.mediaItem != nil)
        {
            self.btnUpDown.isEnabled = true
            self.isUpDown = !self.isUpDown
            if (self.isUpDown)
            {
                self.btnUpDown.image = UIImage(named: "standing-up-man")
            }
            else
            {
                self.btnUpDown.image = UIImage(named: "stairs")
            }
        }
        else
        {
            self.btnUpDown.isEnabled = false
        }
    }
}
