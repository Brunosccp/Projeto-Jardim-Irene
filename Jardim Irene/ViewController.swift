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
        reader.getMatchesInfo(completion: { matchday, count in
            // WHEN you get a callback from the completion handler,
            print("printa da alegria: ", matchday)
            self.matchdayLabel.text = "\(matchday)"
            print("teste2: ", count)
            
            
        })
        

        
        //reader.getMatches(league: "BrazilSerieA", matchday: 17)
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

