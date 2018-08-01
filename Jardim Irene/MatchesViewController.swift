//
//  MatchesViewController.swift
//  Jardim Irene
//
//  Created by Bruno Rocca on 01/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var homeTeam: [String] = []
    var homeImage: [UIImage] = []
    
    var awayTeam: [String] = []
    var awayImage: [UIImage] = []
    
    @IBOutlet var tableView: UITableView!

    let cellIdentifier = "matchCell"
    
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
                
                for i in 0..<matchesList.count{
                    let homeTeamID = matchesList[i]["homeTeamID"] as! Int
                    var homeTeamName = ""
                    
                    var awayTeamID = matchesList[i]["awayTeamID"] as! Int
                    var awayTeamName = ""
                    
                    //consertando cagada da api 2.0
                    if(awayTeamID == 1839){
                        awayTeamID = 6684
                    }
                    
                    //obtendo o nome dos times
                    for j in 0..<teamsList.count{
                        if(homeTeamID == teamsList[j]["id"] as! Int){
                            homeTeamName = teamsList[j]["name"] as! String
                        }
                        else if(awayTeamID == teamsList[j]["id"] as! Int){
                            awayTeamName = teamsList[j]["name"] as! String
                        }
                    }
                    
                    print("nome do time da casa: ", homeTeamName)
                    print("id do time visitante", awayTeamID)
                    
                    self.homeTeam.append(homeTeamName)
                    self.homeImage.append(UIImage(named: "\(homeTeamID)")!)
                    self.awayTeam.append(awayTeamName)
                    self.awayImage.append(UIImage(named: "\(awayTeamID)")!)
                    
                }
                
                self.tableView.reloadData()
            })
            
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeTeam.count
    }
    //retorna a célula costumizada para a table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MatchesCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! MatchesCell
        
        cell.teamHome.text = self.homeTeam[indexPath.row]
        cell.homeImage.image = self.homeImage[indexPath.row]
        cell.teamAway.text = self.awayTeam[indexPath.row]
        cell.awayImage.image = self.awayImage[indexPath.row]
        
        return cell
    }
    //retorna o tamanho de célula
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }
    //funcao que habilita qual célula foi clicada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
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
