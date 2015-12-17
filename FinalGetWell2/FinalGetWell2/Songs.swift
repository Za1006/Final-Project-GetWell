//
//  Songs.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import Foundation
import AVFoundation

class Song
{
    
    let title: String
    let artist: String
    let filename: String
    
    let playerItem: AVPlayerItem
    
    init(title: String, artist: String, filename: String)
    {
        self.title = title
        self.artist = artist
        self.filename = filename
        self.playerItem = AVPlayerItem(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: "mp3")!))
    }
}
