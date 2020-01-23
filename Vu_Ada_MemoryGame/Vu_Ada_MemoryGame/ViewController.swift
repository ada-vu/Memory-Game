//
//  ViewController.swift
//  Vu_Ada_MemoryGame
//
//  Created by Period One on 11/7/17.
//  Copyright © 2017 Period One. All rights reserved.
//

import UIKit

class MatchingCard {
    var button: UIButton!
    var image: UIImage!
    
}

class ViewController: UIViewController {
    
    //labels to prompt user
    @IBOutlet weak var promptText: UILabel!
    @IBOutlet weak var promptNames: UILabel!
    @IBOutlet weak var winnerMessage: UILabel!
    
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var revealAll: UIButton!
    
    @IBOutlet weak var regularMode: UIButton!
    @IBOutlet weak var vs1Mode: UIButton!
    @IBOutlet weak var timerMode: UIButton!
    
    // Timer variables
    var time = 100
    var timer = Timer()
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var timeReset: UIButton!
    
    // Game states
    var currentSecondButton: Bool = false
    var firstButtonPressed: Int = -1
    
    // Buttons
    @IBOutlet var buttons: [UIButton]!
    var matchingCards: [MatchingCard] = []
    
    // Scoring variables
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    
    // Specific scoring var for time mode
    var scoreForTimer = 100
    
    // Specific scoring variables for regular game mode
    var scoreForReg = 1000
    var notMatched = 0
    
    //players: variables used to know which player is playing for the 1 vs 1 game mode
    @IBOutlet weak var players: UILabel!
    var currentSecondPlayer: Bool = false
    var name = String()
    var name2 = String()
    
    // Specific scoring variables for 1 vs 1 game mode
    @IBOutlet weak var playerOneText: UILabel!
    @IBOutlet weak var playerTwoText: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    var playerOneScore = 0
    var playerTwoScore = 0
    var matched = 0
    
    //variable to know when all matches are complete - if total matches equal 8 game complete
    var totalMatches = 0
    
    // populating new matching cards with buttons and images
    func initializeAndRandomize(){
        
        // empty the previously full matching cards array
        matchingCards = []
        
        // Possible cards
        var card: [UIImage] = [#imageLiteral(resourceName: "helloKitty.png"),#imageLiteral(resourceName: "jhope.png"),#imageLiteral(resourceName: "jimin.png"),#imageLiteral(resourceName: "jin.png"),#imageLiteral(resourceName: "jungkook.png"),#imageLiteral(resourceName: "namjoon.png"), #imageLiteral(resourceName: "suga.png"),#imageLiteral(resourceName: "V.png"), #imageLiteral(resourceName: "jhope.png"),#imageLiteral(resourceName: "helloKitty.png"), #imageLiteral(resourceName: "jimin.png"), #imageLiteral(resourceName: "jin.png"), #imageLiteral(resourceName: "jungkook.png"), #imageLiteral(resourceName: "namjoon.png"), #imageLiteral(resourceName: "suga.png"), #imageLiteral(resourceName: "V.png")]
        var upperLimit: UInt32 = 16
        var randomlyGeneratedNum: Int = 0
        
        //loop through all cards to add buttons and images to the cards
        for i in 0...15 {
    
            // create new blank matching card
            let newMatchingCard = MatchingCard()
        
            // gives the new matching card a button
            newMatchingCard.button = buttons[i]
        
            // generates a random number from 0-15
            randomlyGeneratedNum = Int ((arc4random_uniform(upperLimit)))
        
            // sets the image of the new matching cards as a random image
            newMatchingCard.image = card[randomlyGeneratedNum]
        
            card.remove(at: randomlyGeneratedNum)
            upperLimit -= 1
            
            // throw the populated new matching card into matching cards array
            matchingCards.append(newMatchingCard)
        }
    }
    
    // Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //populating new matching cards with buttons and images
        initializeAndRandomize()
        
        //hide all scoring and timer variables from all game modes
        scoreText.isHidden = true
        scoreLabel.isHidden = true
        playerOneText.isHidden = true
        playerTwoText.isHidden = true
        playerOneScoreLabel.isHidden = true
        playerTwoScoreLabel.isHidden = true
        timeLabel.isHidden = true
        start.isHidden = true
        timeReset.isHidden = true
        players.isHidden = true
        reset.isHidden = true
        revealAll.isHidden = true
        
        //welcomes the player who entered their names in menu
        promptNames.text = String(name + " and " + name2)
    }
    
    // func used when any button is pressed
    @IBAction func buttonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        //prevent all the other buttons to reveal itself upon clicking, limits to only two buttons
        if firstButtonPressed != -1 && !currentSecondButton {
            return
        }
        
        //create a var to compare the tags of each card
        let buttonNum = button.tag
        
        //assigns a value to the variable of the first button pressed when it is not the second button (so basically the first button)
        if  !currentSecondButton {
            firstButtonPressed = button.tag
        }
        
        //compares the two buttons clicked in the compare function
        compare(buttonNum)
    }
    
    //compares the two buttons clicked and executes code accordingly
    func compare (_ tag: Int) {
        
        //first button pressed
        if !currentSecondButton {
            
            //sets image of the first button and makes it so that that button cannot be clicked twice in a row
            matchingCards[tag].button.isUserInteractionEnabled = false
            matchingCards[tag].button.setImage(matchingCards[tag].image, for: .normal)

        //second button pressed
        } else {
            
            matchingCards[tag].button.setImage(matchingCards[tag].image, for: .normal)
            
            //the same cards
            if matchingCards[firstButtonPressed].button.imageView?.image == matchingCards[tag].button.imageView?.image {
                
                //to know how many matches there are to invaladate the timer when all is matched
                totalMatches += 1
                
                //if currently playing 1 vs 1 mode
                if vs1Mode.isUserInteractionEnabled == false {
                    
                    //player one
                    if !currentSecondPlayer {
                        
                        //var used to exponentially increase the score and that player continues to play
                        matched += 1
                        scoringFor1vs1()
                        players.text = String(name + "'s turn ")
                    
                    //player two
                    } else {
                        matched += 1
                        scoringFor1vs1()
                        players.text = String(name2 + "'s turn ")
                    }
                    
                    //when all matches are found print which player is the winner depending on the score
                    if totalMatches == 8 {
                        winnerMessage.isHidden = false
                        if playerOneScore > playerTwoScore {
                            winnerMessage.text = String(name + " wins")
                        } else if playerOneScore < playerTwoScore {
                            winnerMessage.text = String(name2 + " wins")
                        } else {
                            winnerMessage.text = String("TIE")
                        }
                        
                        revealAll.isHidden = true
                    }
                
                //if currently playing regular mode
                } else if regularMode.isUserInteractionEnabled == false {
                    //var to exponentially decrease score
                    notMatched =  0
                    
                    //when all matches found print winner if the score is still above 0 if below 0 lose
                    if totalMatches == 8 {
                        winnerMessage.isHidden = false
                        winnerMessage.text = String("You win")
                        revealAll.isHidden = true
                    } else if scoreForReg <= 0 {
                        winnerMessage.isHidden =  false
                        winnerMessage.text = String("You lose")
                        for matchingCard in matchingCards {
                            matchingCard.button.isUserInteractionEnabled =  false
                        }
                    }
                    
                //if currently playing timer mode and the all macth then timer invalidate
                } else if timerMode.isUserInteractionEnabled == false {
                    if  totalMatches == 8 {
                        timer.invalidate()
                        scoringForTimer()
                        timeLabel.text =  String("You Win!")
                        revealAll.isHidden = true
                    }
                }
                
                //set image as a checkmark if match complete and allow a delay before setting the image as checkmark
                delay(){
                    self.matchingCards[self.firstButtonPressed].button.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
                    self.matchingCards[tag].button.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
                    
                    //disable the cards once the match is complete
                    self.matchingCards[self.firstButtonPressed].button.isUserInteractionEnabled = false
                    self.matchingCards[tag].button.isUserInteractionEnabled = false
                    
                    //resets first button so that buttons are clickable the next round after a complete match
                    if self.firstButtonPressed != -1 {
                        self.firstButtonPressed = -1
                    }
                }
            
            //not the same cards
            } else {
                
                //if currently playing the regular game mode
                if regularMode.isUserInteractionEnabled == false {
                    
                    //var used to exponentially decrease the score
                    notMatched += 1
                    scoringForReg()
                    //if score below 0 lose
                    if scoreForReg <= 0 {
                        winnerMessage.isHidden =  false
                        winnerMessage.text = String("You lose")
                        for matchingCard in matchingCards {
                            matchingCard.button.isUserInteractionEnabled =  false
                        }
                    }
                    
                //if currently playing the 1 vs 1 game mode
                } else if vs1Mode.isUserInteractionEnabled == false {
                    //if it was first players turn now it'll be second player
                    if !currentSecondPlayer {
                        
                        //resets the exponential scoring, the other player goes
                        matched = 0
                        players.text = String(name2 + "'s turn ")
                    } else {
                        matched = 0
                        players.text = String(name + "'s turn: ")
                    }
                    //switch the players to know when it is which players turn
                    currentSecondPlayer = !currentSecondPlayer
                }
                
                //delay the cards from flipping back and making the cards clickable again
                delay() {
                    self.matchingCards[self.firstButtonPressed].button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
                    self.matchingCards[tag].button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
                    self.matchingCards[self.firstButtonPressed].button.isUserInteractionEnabled = true
                    
                    //make the cards go back to the original game state - this is used so that three cards cannot be clicked all at once
                    if self.firstButtonPressed != -1 {
                        self.firstButtonPressed = -1
                    }
                }
            }
        }
        // switch the first button to second button if it was on first button and vice versa
        currentSecondButton = !currentSecondButton
    }

    //exponential decrease for the regular game mode - lost points is multiplied by how many points are being lost after every not matched
    func scoringForReg () {
        let lostPoints = notMatched * 10
        scoreForReg = scoreForReg - lostPoints
        scoreLabel.text = String(scoreForReg)
    }
    
    //exponential increase for 1 vs 1 - each player has its own count for how many matched they have in a row this is mulitplied to get the accumulated score
    func scoringFor1vs1 () {
        let accumulatedPoints = matched * 5
        if !currentSecondPlayer {
            playerOneScore += accumulatedPoints
            playerOneScoreLabel.text = String(playerOneScore)
        } else {
            playerTwoScore += accumulatedPoints
            playerTwoScoreLabel.text = String(playerTwoScore)
        }
    }
    
    //exponential decrease for timer mode - the score score decreases by a smaller amt as time counts down
    func scoringForTimer () {
        if time == 0 {
            return scoreLabel.text = String(0)
        }
        
        scoreForTimer = ((time * time ) / 100)
        scoreLabel.text = String(scoreForTimer)
    }
    
    //start timer function when pressed start button is hidden
    @IBAction func startPressed(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.timeAction), userInfo: nil, repeats: true)
        start.isHidden =  true
        
        //loop through the cards to make them all cliackable and to set the image as background img
        for matchingCard in matchingCards {
            matchingCard.button.isUserInteractionEnabled =  true
            matchingCard.button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
        }
    }
    
    //reset timer function - when pressed timer stops and time resets back to initial value shows the start button
    @IBAction func resetTimePressed(_ sender: Any) {
        timer.invalidate()
        time = 100
        timeLabel.text = String(time)
        start.isHidden = false
        
        //card can't be pressed unless the start button is pressed
        for matchingCard in matchingCards {
            matchingCard.button.isUserInteractionEnabled =  false
            matchingCard.button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
        }
        
        //populate the cards with buttons and images and shuffle the cards
        initializeAndRandomize()
        
        //reset score
        scoreForTimer = 100
        scoreLabel.text = String(scoreForTimer)
        
        revealAll.isHidden = false
        
        //if the first button is pressed but the second button is not and you want to switch modes this will reset the game states
        if firstButtonPressed != -1 {
            firstButtonPressed = -1
            currentSecondButton = false
        }
        
        totalMatches = 0
    }
    
    // the function for displaying the timer
    @objc func timeAction() {
        time -= 1
        timeLabel.text = String(time)
        scoringForTimer()
        
        //if the time hits 0 print lose and cards can not be clicked
        if time == 0 {
            timer.invalidate()
            timeLabel.text = String("You Lose")
            for matchingCard in matchingCards {
                matchingCard.button.isUserInteractionEnabled =  false
                matchingCard.button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
            }
        }
    }
    
    // new game function - resets everything to scratch
    @IBAction func resetPressed(_ sender: Any) {
        
        // loop through all the cards so that it can't be clicked, set image to default, and hide cards
        for matchingCard in matchingCards {
            matchingCard.button.isUserInteractionEnabled =  false
            matchingCard.button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
            matchingCard.button.isHidden = true
        }
        
        //reveal prompt messages to prompt users
        promptText.isHidden = false
        promptNames.isHidden = false
        promptNames.text = String(name + " and " + name2)
        
        //hide buttons
        reset.isHidden = true
        revealAll.isHidden = true
        
        //modes are not hidden and can be clicked
        regularMode.isHidden = false
        vs1Mode.isHidden = false
        timerMode.isHidden =  false
        regularMode.isUserInteractionEnabled = true
        vs1Mode.isUserInteractionEnabled = true
        timerMode.isUserInteractionEnabled = true
        
        //scoring variables are all hidden for all game modes
        scoreText.isHidden = true
        scoreLabel.isHidden = true
        playerOneText.isHidden = true
        playerTwoText.isHidden = true
        playerOneScoreLabel.isHidden = true
        playerTwoScoreLabel.isHidden = true
        
        //prompt message to know which players turn it is also hidden
        players.isHidden = true
        winnerMessage.isHidden = true
        
        //resets the scoring for regular mode back to its original value
        scoreForReg = 1000
        notMatched = 0
        
        //resets the scoring for 1 vs 1 mode back to original value
        playerOneScore = 0
        playerTwoScore = 0
        playerOneScoreLabel.text = String(playerOneScore)
        playerTwoScoreLabel.text = String(playerTwoScore)
        matched = 0
        
        //resets scoring for timer mode
        scoreForTimer = 100
        
        //resets timer and hides the timer variables
        timer.invalidate()
        time = 100
        timeLabel.text = String(time)
        timeLabel.isHidden = true
        start.isHidden = true
        timeReset.isHidden = true
        
        // reset the shuffle so that its a new deck of shuffled cards
        initializeAndRandomize()
        
        //reset total num of matches
        totalMatches = 0
        
        //if the first button is pressed but the second button is not and you want to switch modes this will reset the game states
        if firstButtonPressed != -1 {
            firstButtonPressed = -1
            currentSecondButton = false
        }
    }
    
    // a give up func to reveal all the cards
    @IBAction func revealAllPressed(_ sender: Any) {
        
        //set the img all at once rather than wait for it to be clicked, and can no longer be clicked
        for matchingCard in matchingCards {
            matchingCard.button.setImage(matchingCard.image, for: .normal)
            matchingCard.button.isUserInteractionEnabled =  false
        }
        //hide button
        revealAll.isHidden = true
        //stop timer
        timer.invalidate()
    }
    
    // regular game mode function for when the regular game mode is pressed
    @IBAction func regularModePressed(_ sender: Any) {
       
        //loop through all the cards so that the cards can be seen and are clickable
        for matchingCard in matchingCards {
            matchingCard.button.isHidden = false
            matchingCard.button.isUserInteractionEnabled =  true
        }
        
        //used for the comparing to know which scoring corresponds to which game mode
        regularMode.isUserInteractionEnabled = false
        
        //hide and reveal certain buttons
        promptText.isHidden = true
        promptNames.isHidden = true
        reset.isHidden = false
        revealAll.isHidden = false
        vs1Mode.isHidden = true
        timerMode.isHidden = true
        
        //hide other scoring variables from other game modes
        playerOneText.isHidden = true
        playerTwoText.isHidden = true
        playerOneScoreLabel.isHidden = true
        playerTwoScoreLabel.isHidden = true
        
        //reveal scoring to see score
        scoreText.isHidden = false
        scoreLabel.isHidden = false
        
        //sets initial value for the player
        scoreForReg = 1000
        scoreLabel.text = String(scoreForReg)
        
    }
    
    @IBAction func vs1ModePressed(_ sender: Any) {
        
        //same loop as for reg mode
        for matchingCard in matchingCards {
            matchingCard.button.isHidden = false
            matchingCard.button.isUserInteractionEnabled =  true
        }
        
        //used for the comparing to know which scoring corresponds to which game mode
        vs1Mode.isUserInteractionEnabled = false
        
        //hide and reveal certain buttons
        promptText.isHidden = true
        promptNames.isHidden = true
        reset.isHidden = false
        revealAll.isHidden = false
        regularMode.isHidden = true
        timerMode.isHidden = true
        
        //hide scoring variables from other game modes
        scoreText.isHidden = true
        scoreLabel.isHidden = true
        playerOneText.isHidden = false
        playerTwoText.isHidden = false
        playerOneScoreLabel.isHidden = false
        playerTwoScoreLabel.isHidden = false
        
        // display the player's score with their name entered in menu
        playerOneText.text = String(name + "'s score")
        playerTwoText.text = String(name2 + "'s score")
        
        //sets initial score for player one and player two scores
        playerOneScore = 0
        playerTwoScore = 0
        playerOneScoreLabel.text = String(playerOneScore)
        playerTwoScoreLabel.text = String(playerTwoScore)
        
        //always prompts player one first
        players.isHidden = false
        players.text = String(name + "'s turn ")
    }
    
    //timer mode game mode function
    @IBAction func timerModePressed(_ sender: Any) {
        
        //same functions as loop for reg mode and 1 vs 1 mode
        for matchingCard in matchingCards {
            matchingCard.button.isHidden = false
            matchingCard.button.isUserInteractionEnabled =  true
        }
        
        //used for the comparing to know which scoring corresponds to which game mode
        timerMode.isUserInteractionEnabled = false
        
        ///hide and reveal certain buttons
        promptText.isHidden = true
        promptNames.isHidden = true
        reset.isHidden = false
        revealAll.isHidden = false
        regularMode.isHidden = true
        vs1Mode.isHidden = true
        
        //sets initial score for player
        scoreForTimer = 100
        scoreLabel.text = String(scoreForTimer)
        
        //hide scoring variables from other game modes
        scoreText.isHidden = false
        scoreLabel.isHidden = false
        playerOneText.isHidden = true
        playerTwoText.isHidden = true
        playerOneScoreLabel.isHidden = true
        playerTwoScoreLabel.isHidden = true
        
        //reveal timer variables
        timeLabel.isHidden = false
        start.isHidden = false
        timeReset.isHidden = false
        
        //all buttons cannot be pressed until the start button (for this game mode) is pressed - prevents user from cheating
        for matchingCard in matchingCards {
            matchingCard.button.isUserInteractionEnabled =  false
            matchingCard.button.setImage(#imageLiteral(resourceName: "wallpaper "), for: .normal)
        }
        
        totalMatches = 0
    }
    
    //func used to delay code for 0.5 secs
    func delay(_ closure:@escaping ()->()) {
        
        //code delayed by 0.5
        let delayTime: Double = 0.5
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delayTime * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
