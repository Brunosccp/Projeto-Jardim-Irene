//
//  ViewController.swift
//  Jardim Irene
//
//  Created by Bruno Rocca on 31/07/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var homeInfo: [String] = []
    
    @IBOutlet var tableView: UITableView!
    
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let reader = FirebaseReader()
        //chamando funções com completion para sincronizar com o load do Firebase
        reader.getMatchesInfo(completion: { matchday, matchesList in
            reader.getTeamsInfo(completion: { teamsList in
                
                print("print da alegria: ", matchday)
                //print("teste2: ", matchesList)
                print("teste3: ", teamsList)
                
                //pegando a informação de jogos jogados
                let gamesPlayed = ((teamsList[0]["won"]! as! Int) + (teamsList[0]["draw"]! as! Int) + (teamsList[0]["lost"]! as! Int))
                
                //jogando informações do time da casa
                self.homeInfo.append("\(teamsList[0]["position"]!)")
                self.homeInfo.append("\(teamsList[0]["points"]!)")
                self.homeInfo.append("\(gamesPlayed)")
                self.homeInfo.append("\(teamsList[0]["won"]!)")
                self.homeInfo.append("\(teamsList[0]["draw"]!)")
                self.homeInfo.append("\(teamsList[0]["lost"]!)")
                self.homeInfo.append("\(teamsList[0]["goalsFor"]!)")
                self.homeInfo.append("\(teamsList[0]["goalsAgainst"]!)")
                self.homeInfo.append("\(teamsList[0]["goalDifference"]!)")
                
                //atualizando table view
                self.tableView.reloadData()
            })
            
        })
        
    }
    //retorna a quantidade de células da table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeInfo.count
    }
    //retorna a célula costumizada para a table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ComparationCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ComparationCell
        
        cell.homeLabel.text = self.homeInfo[indexPath.row]
        
        return cell
    }
    //retorna o tamanho de célula
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
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

