//
//  ViewController.swift
//  Jardim Irene
//
//  Created by Bruno Rocca on 31/07/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var matchdayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reader = FirebaseReader()
        //chamando funções com completion para sincronizar com o load do Firebase
        reader.getMatchesInfo(completion: { matchday, matchesList in
            reader.getTeamsInfo(completion: { teamsList in
                
                print("print da alegria: ", matchday)
                self.matchdayLabel.text = "\(matchday)"
                //print("teste2: ", matchesList)
                print("teste3: ", teamsList)
            })
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func observeSingle(){
        let ref = Database.database().reference()
        
        ref.child("BrazilSerieA").child("teams").child("1765").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            let name = value?["name"] as? String ?? ""
            let points = value?["points"] as? Int
            print("name:", name)
            print(points!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

