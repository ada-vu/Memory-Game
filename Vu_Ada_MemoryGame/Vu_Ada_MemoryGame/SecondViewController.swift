//
//  SecondViewController.swift
//  Vu_Ada_MemoryGame
//
//  Created by Cryndex on 11/26/17.
//  Copyright © 2017 Period One. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    //text field to retrieve the names of the players
    @IBOutlet weak var playerOneTextField: UITextField!
    @IBOutlet weak var playerTwoTextField: UITextField!
    
    //func to segue from the menu to the game with the condition that both text fields are filled
    @IBAction func enter(_ sender: Any) {
        if playerOneTextField.text != "" && playerTwoTextField.text != "" {
            performSegue(withIdentifier: "toGame", sender: self)
        }
    }
    
    //pass the information from the menu to the game and then segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pass the information of player ones name
        let firstViewController = segue.destination as! ViewController
        firstViewController.name = playerOneTextField.text!
        
        //pass information of player two name
        let firstController = segue.destination as! ViewController
        firstController.name2 = playerTwoTextField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
