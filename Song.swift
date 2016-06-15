//
//  Song.swift
//  SoundPot
//
//  Created by Clement Besson on 6/7/16.
//  Copyright © 2016 Clement Besson. All rights reserved.
//

import UIKit
import MediaPlayer

class Song {
    // MARK: Properties
    var track: String = ""
    var artist: String = ""
    var album: String = ""
    var artworkImage: MPMediaItemArtwork
    
    // MARK: Initialization
    init?(track: String, artist: String, album: String, artworkImage: MPMediaItemArtwork ) {
        // Initialize stored properties.
        self.track = track
        self.artist = artist
        self.album = album
        self.artworkImage = artworkImage
    }
}