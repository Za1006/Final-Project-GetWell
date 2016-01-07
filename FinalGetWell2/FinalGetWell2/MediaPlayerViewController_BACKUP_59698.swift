//
//  MediaPlayerViewController.swift
//  FinalGetWell2
//
//  Created by Elizabeth Yeh on 12/17/15.
//  Copyright © 2015 Keron. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import QuartzCore

var timerCount = 0

class MediaPlayerViewController: UIViewController
{
    
    var song: Song?
    
    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet var meditationCountdown: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //    let avQueuePlayer = AVQueuePlayer()
    var player = AVQueuePlayer()
    var songs = Array<Song>()
    var currentSong: Song?
    var nowPlaying: Bool = false
    
    var timer: NSTimer?
    var originalCount = 0
    
    var whichSegment = 0
    
    var flashTimer: NSTimer?
    var flashCount = 0
    var flashing = true
    
    var timesTapped = 0
    
    
    var delegate: MainViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //        self.navigationController!.navigationBar.topItem!.title = "Cancel"
        
        backButton.enabled = false
        
        pulse(playPauseButton)
        morePulse(playPauseButton)
        
        //plusButton.hidden = true
        
        timerCount = 0
        originalCount = 300
        meditationCountdown.text = "05:00"
        
        setupAudioSession()
        configurePlaylist()
        loadCurrentSong()
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions:.DefaultToSpeaker)
        }
        catch let error as NSError
        {
            print("Failed to set audio session category. Error: \(error)")
        }
        //        let fileNames = ["betterdaysahead", "mindPowerAffirmation", "leaveswind", "mytomorrow", "thebeautifulbeach", "rainy", "coldsnowstorm", "rainOntheRooftop", "relaxingnovember", "heavywetrain", "busygreenforest", "gentlewetcreek", "thunderlight", "littlebirds" ]
        //
        //        let songs = fileNames.map {AVPlayerItem(URL: NSBundle.mainBundle().URLForResource($0 , withExtension: "mp3")!)}
        //        player = AVQueuePlayer(items: songs)
        //        player.actionAtItemEnd = .Advance
        //        player.addObserver(self, forKeyPath: "currentItem", options: [.New, .Initial], context: nil)
        
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)
    {
        if keyPath == "currentItem", let player = object as? AVPlayer, currentItem = player.currentItem?.asset as? AVURLAsset
        {
            songTitleLabel.text = currentItem.URL.lastPathComponent ?? "Unknown"
            
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        togglePlayback(false)
    }
    
    @IBAction func segmentedIndexTapped(sender: UISegmentedControl)
    {
        
        if sender.selectedSegmentIndex == 0
        {
            originalCount = 300
            meditationCountdown.text = "05:00"
            whichSegment = 0
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 1
        {
            originalCount = 600
            meditationCountdown.text = "10:00"
            whichSegment = 1
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 2
        {
            originalCount = 900
            meditationCountdown.text = "15:00"
            whichSegment = 2
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 3
        {
            originalCount = 1200
            meditationCountdown.text = "20:00"
            whichSegment = 3
            //            startTimer()
            //            setupAudioSession()
            //            loadCurrentSong()
            //            togglePlayback(true)
        }
        
    }
    
    func morePulse(button: UIButton)
    {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 3
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1.3
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        button.layer.addAnimation(pulseAnimation, forKey: nil)
    }
    
    func pulse(button: UIButton)
    {
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 3
        pulseAnimation.fromValue = NSNumber(float: 0.7)
        pulseAnimation.toValue = NSNumber(float: 1.3)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        button.layer.addAnimation(pulseAnimation, forKey: "layerAnimation")
    }
    
    
    func startTimer()
    {
        if timerCount % 2 == 0
        {
            timer?.invalidate()
        }
        else
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateUI", userInfo: nil, repeats: true)
            updateUI()
        }
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    func updateUI()
    {
        originalCount = originalCount - 1
        //        let newMinuteCount = originalCount/60
        //        let newSecondCount = originalCount%60
        //        meditationCountdown.text = String("\(newMinuteCount):\(newSecondCount)")
        timerDisplay()
        print(originalCount)
        
        if originalCount == 0
        {
            timer?.invalidate()
            flashTimer = NSTimer
                .scheduledTimerWithTimeInterval(0.2, target: self, selector: "flashLabel" , userInfo: nil, repeats: true)
            playNotification()
        }
    }
    
    func timerDisplay()
    {
        let dFormat = "%02d"
        let newMinuteCount = originalCount/60
        let newSecondCount = originalCount%60
        let s = "\(String(format: dFormat, newMinuteCount)):\(String(format: dFormat, newSecondCount))"
        meditationCountdown.text = s
    }
    
    func flashLabel()
    {
        flashing = !flashing
        if flashing
        {
            meditationCountdown.textColor = UIColor.whiteColor()
        }
        else
        {
            meditationCountdown.textColor = UIColor.yellowColor()
        }
        flashCount++
        
        if flashCount > 100
        {
            flashTimer?.invalidate()
        }
    }
    
    func playNotification()
    {
        let soundURL = NSBundle.mainBundle().URLForResource("SessionOver", withExtension: "m4a")!
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    @IBAction func playPauseTapped(sender: UIButton)
    {
        timerCount = timerCount + 1
        startTimer()
        togglePlayback(!nowPlaying)
        backButton.hidden = false
        backButton.enabled = true
        meditationCountdown.textColor = UIColor.whiteColor()
    }
    
    @IBAction func skipForwardTapped(sender: UIButton)
    {
        meditationCountdown.textColor = UIColor.whiteColor()
        let currentSongIndex = (songs as NSArray).indexOfObject(currentSong!)
        let nextSong: Int
        
        if currentSongIndex + 1 >= songs.count
        {
            nextSong = 0
        }
        else
        {
            nextSong = currentSongIndex + 1
        }
        currentSong = songs[nextSong]
        loadCurrentSong()
        //        togglePlayback(true)
    }
    
    @IBAction func skipBackTapped(sender: UIButton)
    {
        if nowPlaying
        {
            meditationCountdown.textColor = UIColor.whiteColor()
            timesTapped = timesTapped + 1
            
            if timesTapped % 2 == 1
            {
                player.seekToTime(CMTimeMakeWithSeconds(0.0, 1))
            }
            else if timesTapped % 2 == 0
            {
                let currentSongIndex = (songs as NSArray).indexOfObject(currentSong!)
                let nextSong: Int
                if currentSongIndex != 0
                {
                    nextSong = currentSongIndex - 1
                }
                else
                {
                    nextSong = songs.count - 1
                }
                currentSong = songs[nextSong]
                loadCurrentSong()
                togglePlayback(true)
            }
        }
        else
        {
            backButton.enabled = false
        }
        
    }
    
    func configurePlaylist()
    {
        let mindpowerDict: NSDictionary = [
            "title": "Mind Power",
            "artist" : "Benjamin Tissot",
            "filename" : "betterdaysahead",
            "albumArtwork" : "newChillImg"
        ]
        let mindpowerSong = Song(dictionary: mindpowerDict)
        songs.append(mindpowerSong)
        currentSong = mindpowerSong
        
        let mindpowerAffDict: NSDictionary = [
            "title": "Mind Power Affirmation",
            "artist": "Benjamin Tissot",
            "filename": "gwNewMindPower",
            "albumArtwork": "newMindPowerImg"
        ]
        let mindpowerAff = Song(dictionary: mindpowerAffDict)
        songs.append(mindpowerAff)
        
        let autumDict: NSDictionary = [
            "title": "Fall",
            "artist": "Benjamin Tissot",
            "filename": "leaveswind",
            "albumArtwork": "newWindLeavesImg"
        ]
        let autum = Song(dictionary: autumDict)
        songs.append(autum)
        
        let tomorrowDict: NSDictionary = [
            "title": "The Future",
            "artist": "Benjamin Tissot",
            "filename": "mytomorrow",
            "albumArtwork": "newTomorrowImg"
        ]
        let tomorrow = Song(dictionary: tomorrowDict)
        songs.append(tomorrow)
        
        let beachDict: NSDictionary = [
            "title": "Sea Shore",
            "artist": "Benjamin Tissot",
            "filename": "thebeautifulbeach",
            "albumArtwork": "newBeachImg"
        ]
        let beach = Song(dictionary: beachDict)
        songs.append(beach)
        
        let rainDict: NSDictionary = [
            "title": "Rain",
            "artist": "Benjamin Tissot",
            "filename": "rainy",
            "albumArtwork": "newRainImg"
        ]
        let rain = Song(dictionary: rainDict)
        songs.append(rain)
        
        let snowDict: NSDictionary = [
            "title": "Winter",
            "artist": "Benjamin Tissot",
            "filename": "coldsnowstorm",
            "albumArtwork": "newSnowStormImg"
        ]
        let snow = Song(dictionary: snowDict)
        songs.append(snow)
        
        let roofDict: NSDictionary = [
            "title": "Roof Top",
            "artist": "Benjamin Tissot",
            "filename": "rainOntheRooftop",
            "albumArtwork": "newRooftopImg"
        ]
        let roof = Song(dictionary: roofDict)
        songs.append(roof)
        
        let relaxDict: NSDictionary = [
            "title": "Calm",
            "artist": "Benjamin Tissot",
            "filename": "relaxingnovember",
            "albumArtwork": "newRelaxingImg"
        ]
        let relax = Song(dictionary: relaxDict)
        songs.append(relax)
        
        let relaxCalm: NSDictionary = [
            "title": "Calm Affirmation",
            "artist": "Benjamin Tissot",
            "filename": "calmPeace",
            "albumArtwork": "newCalmAffirmation"
        ]
        let calm = Song(dictionary: relaxCalm)
        songs.append(calm)
        
        let pouringDict: NSDictionary = [
            "title": "Drench",
            "artist": "Benjamin Tissot",
            "filename": "heavywetrain",
            "albumArtwork": "newHeavyRain"
        ]
        let pouring = Song(dictionary: pouringDict)
        songs.append(pouring)
        
        let lushDict: NSDictionary = [
            "title": "Lush",
            "artist": "Benjamin Tissot",
            "filename": "busygreenforest",
            "albumArtwork": "newForestImg"
        ]
        let lush = Song(dictionary: lushDict)
        songs.append(lush)
        
        let streamDict: NSDictionary = [
            "title": "Soft Creek",
            "artist": "Benjamin Tissot",
            "filename": "gentlewetcreek",
            "albumArtwork": "newCreekImg"
        ]
        let stream = Song(dictionary: streamDict)
        songs.append(stream)
        
        let heavenDict: NSDictionary = [
            "title": "Rage",
            "artist": "Benjamin Tissot",
            "filename": "thunderlight",
            "albumArtwork": "newThunderImg"
        ]
        let heaven = Song(dictionary: heavenDict)
        songs.append(heaven)
        
        let tweetsDict: NSDictionary = [
            "title": "Happy",
            "artist": "Benjamin Tissot",
            "filename": "littlebirds",
            "albumArtwork": "newBirdsImg"
        ]
        let tweets = Song(dictionary: tweetsDict)
        songs.append(tweets)
        
    }
    
    func loadCurrentSong()
    {
        player.removeAllItems()
        if let song = currentSong
        {
            song.playerItem.seekToTime(CMTimeMakeWithSeconds(0.0, 1))
            player.insertItem(song.playerItem, afterItem: nil)
            songTitleLabel.text = song.title
            //            artistLabel.text? = song.artist
            albumArtwork.image = UIImage(named: song.albumArtworkName)
            
        }
    }
    
    func setupAudioSession()
    {
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted
            {
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                } catch _ {
                }
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch _ {
                }
            }
            else
            {
                print("Audio session could not be configured; user denied permission.")
            }
        })
    }
    
    func togglePlayback(play: Bool)
    {
        nowPlaying = play
        if play
        {
            //            playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            player.play()
        }
        else
        {
            //            playPauseButton.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            player.pause()
        }
    }
    
    @IBAction func resetPressed(sender: UIButton!)
    {
        meditationCountdown.textColor = UIColor.whiteColor()
        
        if whichSegment == 0
        {
            originalCount = 300
            meditationCountdown.text = "05:00"
        }
        if whichSegment == 1
        {
            originalCount = 600
            meditationCountdown.text = "10:00"
        }
        if whichSegment == 2
        {
            originalCount = 900
            meditationCountdown.text = "15:00"
        }
        if whichSegment == 3
        {
            originalCount = 1200
            meditationCountdown.text = "20:00"
        }
        
        stopTimer()
        timerCount = 0
        timesTapped = 1
        loadCurrentSong()
        togglePlayback(false)
        //        startTimer()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if timerCount%2 == 1
        {
            togglePlayback(true)
        }
        if let nav = segue.destinationViewController as? UINavigationController
        {
            if let playlistVC = nav.topViewController as? PlaylistTableViewController
            {
                playlistVC.parent = self
                playlistVC.songs = songs
            }
        }
        
        if let nav = segue.destinationViewController as? UINavigationController
        {
            if let searchVC = nav.topViewController as? MapViewController
            {
                searchVC.parent = self
            }
        }
        
    }
    
    
    
<<<<<<< HEAD
}
=======
}
>>>>>>> origin/SetRemider
