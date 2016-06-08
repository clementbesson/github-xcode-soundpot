//
//  HistorySongViewController.swift
//  SoundPot
//
//  Created by Clement Besson on 6/8/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//
import UIKit
import Parse
import MediaPlayer

class HistorySongViewController: UIViewController {
    // MARK: Properties
    var selectedSong = PFObject(className: "Messages")
    
    @IBOutlet weak var trackLabel: UITextView!
    @IBOutlet weak var artistLabel: UITextView!
    @IBOutlet weak var albumLabel: UITextView!
    @IBOutlet weak var coverView: UIImageView!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        trackLabel.text = String(self.selectedSong.objectForKey("track")!)
        artistLabel.text = String(self.selectedSong.objectForKey("artist")!)
        albumLabel.text = String(self.selectedSong.objectForKey("album")!)
        //let imageFile = selectedSong.objectForKey("artwork")
        //let imageUrl = NSURL(string: imageFile.url)
        //let image = UIImage()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }
}