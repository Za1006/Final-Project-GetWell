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

class MediaPlayerViewController: UIViewController
{

    @IBOutlet weak var timeSegmentedControl: UISegmentedControl!
    @IBOutlet var meditationCountdown: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    //  @IBOutlet var playPauseButton: UIButton!
    
    let avQueuePlayer = AVQueuePlayer()
    var songs = Array<Song>()
    var currentSong: Song?
    var nowPlaying: Bool = false
    
    var timer: NSTimer?
    var originalCount = 0
    var timerCount = 0
    
    var whichSegment = 0
    
    var flashTimer: NSTimer?
    var flashCount = 0
    var flashing = true
    
    var timesTapped = 0
    
//    var shuffleMode: MPMusicShuffleMode?
    
    var delegate: MainViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       //plusButton.hidden = true
        
        originalCount = 300
        meditationCountdown.text = "5:00"
        
        setupAudioSession()
        configurePlaylist()
        loadCurrentSong()

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
            meditationCountdown.text = "5:00"
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
        
        if flashCount > 15
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
    }
    
    @IBAction func skipForwardTapped(sender: UIButton)
    {
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
        timesTapped = timesTapped + 1
        if timesTapped % 2 == 1
        {
            avQueuePlayer.seekToTime(CMTimeMakeWithSeconds(0.0, 1))
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
    
    func configurePlaylist()
    {
        let mindpower = Song(title: "Mind Power", artist: "Benjamin Tissot", filename: "betterdaysahead", albumArtwork: "BetterDaySound")
        songs.append(mindpower)
        currentSong = mindpower
        
        let mindpowerAff = Song(title: "Mind Power Affirmation", artist: "Benjamin Tissot", filename: "mindPowerAffirmation", albumArtwork: "MindPowerImg")
        songs.append(mindpowerAff)
        
        let autum = Song(title: "Fall", artist: "Benjamin Tissot", filename: "leaveswind", albumArtwork: "WindLeavessSound")
        songs.append(autum)
        //currentSong = mindpower

        let tomorrow = Song(title: "The Future", artist: "Benjamin Tissot", filename: "mytomorrow", albumArtwork: "TomorrowSound")
        songs.append(tomorrow)
        
        let beach = Song(title: "Sea Shore", artist: "Benjamin Tissot", filename: "thebeautifulbeach", albumArtwork: "BeachSound")
        songs.append(beach)
        
        let rain = Song(title: "Rain", artist: "Benjamin Tissot", filename: "rainy", albumArtwork: "RainSound")
        songs.append(rain)
        
        let snow = Song(title: "Winter", artist: "Benjamin Tissot", filename: "coldsnowstorm", albumArtwork: "SnowStormSound")
        songs.append(snow)
        
        let roof = Song(title: "Roof Top", artist: "Benjamin Tissot", filename: "rainOntheRooftop", albumArtwork: "RoofTopSound")
        songs.append(roof)
        
        let relax = Song(title: "Calm", artist: "Benjamin Tissot", filename: "relaxingnovember", albumArtwork: "RelaxingSound")
        songs.append(relax)
        
        let pouring = Song(title: "Drench", artist: "Benjamin Tissot", filename: "heavywetrain", albumArtwork: "HeavyRainSound")
        songs.append(pouring)
        
        let lush = Song(title: "Lush", artist: "Benjamin Tissot", filename: "busygreenforest", albumArtwork: "ForestSound")
        songs.append(lush)
        
        let stream = Song(title: "Soft Creek", artist: "Benjamin Tissot", filename: "gentlewetcreek", albumArtwork: "CreekSound")
        songs.append(stream)
        
        let heaven = Song(title: "Rage", artist: "Benjamin Tissot", filename: "thunderlight", albumArtwork: "ThunderSound")
        songs.append(heaven)
        
        let tweets = Song(title: "Happy", artist: "Benjamin Tissot", filename: "littlebirds", albumArtwork: "BirdsSound")
        songs.append(tweets)
        
        
    }
    
    func loadCurrentSong()
    {
        avQueuePlayer.removeAllItems()
        if let song = currentSong
        {
            song.playerItem.seekToTime(CMTimeMakeWithSeconds(0.0, 1))
            avQueuePlayer.insertItem(song.playerItem, afterItem: nil)
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
            avQueuePlayer.play()
        }
        else
        {
            //            playPauseButton.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            avQueuePlayer.pause()
        }
    }
    
    @IBAction func resetPressed(sender: UIButton!)
    {

        if whichSegment == 0
        {
            originalCount = 300
        }
        if whichSegment == 1
        {
            originalCount = 600
        }
        if whichSegment == 2
        {
            originalCount = 900
        }
        if whichSegment == 3
        {
            originalCount = 1200
        }
      
        stopTimer()
        loadCurrentSong()
        startTimer()
    }
    
    

}
