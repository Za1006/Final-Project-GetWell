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
    @IBOutlet var songTitleLabel: UILabel!
    //  @IBOutlet var artistLabel: UILabel!
    //    @IBOutlet var playPauseButton: UIButton!

    
    let avQueuePlayer = AVQueuePlayer()
    var songs = Array<Song>()
    var currentSong: Song?
    var nowPlaying: Bool = false
    
    var timer: NSTimer?
    var originalCount = 300
    
    
    var shuffleMode: MPMusicShuffleMode?
    
    var delegate: MainViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupAudioSession()
        configurePlaylist()
        loadCurrentSong()

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func segmentedIndexTapped(sender: UISegmentedControl)
    {
        
        
        if sender.selectedSegmentIndex == 0
        {
            startTimer()
            originalCount = 300
            meditationCountdown.text = "5:00"
            setupAudioSession()
            loadCurrentSong()
            togglePlayback(true)
            
        }
        else if sender.selectedSegmentIndex == 1
        {
            startTimer()
            originalCount = 600
            meditationCountdown.text = "10:00"
            setupAudioSession()
            loadCurrentSong()
            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 2
        {
            startTimer()
            originalCount = 900
            meditationCountdown.text = "15:00"
            setupAudioSession()
            loadCurrentSong()
            togglePlayback(true)
        }
        else if sender.selectedSegmentIndex == 3
        {
            startTimer()
            originalCount = 1200
            meditationCountdown.text = "20:00"
            setupAudioSession()
            loadCurrentSong()
            togglePlayback(true)
        }
        
        
    }
    
    func startTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateUI", userInfo: nil, repeats: true)
        updateUI()
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    func updateUI()
    {
        originalCount = originalCount - 1
        let newMinuteCount = originalCount/60
        let newSecondCount = originalCount%60
        meditationCountdown.text = String("\(newMinuteCount):\(newSecondCount)")
        
        
        if originalCount == 0
        {
            stopTimer()
            setNotification()
            
        }
    }
    
    func setNotification()
    {
        if originalCount == 0
        {
            let soundURL = NSBundle.mainBundle().URLForResource("sessionOver", withExtension: "m4a")!
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL,&soundID)
            AudioServicesPlayAlertSound(soundID)
            
        }
    }
    
    @IBAction func playPauseTapped(sender: UIButton)
    {
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
        togglePlayback(true)
    }
    
    @IBAction func skipBackTapped(sender: UIButton)
    {
        avQueuePlayer.seekToTime(CMTimeMakeWithSeconds(0.0, 1))
        if !nowPlaying
        {
            togglePlayback(true)
            
        }
    }
    
    func configurePlaylist()
    {
        let acoustic = Song(title: "Acoustic Breeze", artist: "Benjamin Tissot", filename: "acousticbreeze")
        songs.append(acoustic)
        currentSong = acoustic
        
        let betterdays = Song(title: "Better Days", artist: "Benjamin Tissot", filename: "betterdays")
        songs.append(betterdays)
        
        let deepblue = Song(title: "Deep Blue", artist: "Benjamin Tissot", filename: "deepblue")
        songs.append(deepblue)
        
        let enigmatic = Song(title: "Enigmatic", artist: "Benjamin Tissot", filename: "enigmatic")
        songs.append(enigmatic)
        
        let november = Song(title: "November", artist: "Benjamin Tissot", filename: "november")
        songs.append(november)
        
        
        let relaxing = Song(title: "Relaxing", artist: "Benjamin Tissot", filename: "relaxing")
        songs.append(relaxing)
        
        
        let sadday = Song(title: "Sadday", artist: "Benjamin Tissot", filename: "sadday")
        songs.append(sadday)
        
        
        let slowmotion = Song(title: "Slowmotion", artist: "Benjamin Tissot", filename: "slowmotion")
        songs.append(slowmotion)
        
        
        let tomorrow = Song(title: "Tomorrow", artist: "Benjamin Tissot", filename: "tomorrow")
        songs.append(tomorrow)
    }
    
    func loadCurrentSong()
    {
        avQueuePlayer.removeAllItems()
        if let song = currentSong
        {
            song.playerItem.seekToTime(CMTimeMakeWithSeconds(0.0, 1))
            avQueuePlayer.insertItem(song.playerItem, afterItem: nil)
            //                        songTitleLabel.text? = song.title
            //                        artistLabel.text? = song.artist
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  


}
