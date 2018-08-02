//
//  MatchesViewController.swift
//  Jardim Irene
//
//  Created by Bruno Rocca on 01/08/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //imagem e string referente ao time da casa
    var homeTeam: [String] = []
    var homeImage: [UIImage] = []
    
    //imagem e string referente ao time de fora
    var awayTeam: [String] = []
    var awayImage: [UIImage] = []
    
    //label referente a data
    var date: [String] = []
    
    //vetor que guarda os id's da partida em ordem
    var matchID: [Int] = []
    
    var cellTapped: Int = -1
    
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
                print("teste2: ", matchesList)
                //print("teste3: ", teamsList)
                
                for i in 0..<matchesList.count{
                    let homeTeamID = matchesList[i]["homeTeamID"] as! Int
                    var homeTeamName = ""
                    
                    var awayTeamID = matchesList[i]["awayTeamID"] as! Int
                    var awayTeamName = ""
                    
                    //arrumando data
                    let utcDate = matchesList[i]["utcDate"] as! String
                    self.setDate(gameDate: utcDate)
                    
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
                    
                    self.homeTeam.append(homeTeamName)
                    self.homeImage.append(UIImage(named: "\(homeTeamID)")!)
                    self.awayTeam.append(awayTeamName)
                    self.awayImage.append(UIImage(named: "\(awayTeamID)")!)
                    
                    self.matchID.append(matchesList[i]["id"] as! Int)
                    
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
        cell.teamHome.sizeToFit()
        cell.teamHome.center.x = 90
        cell.homeImage.image = self.homeImage[indexPath.row]
        
        cell.teamAway.text = self.awayTeam[indexPath.row]
        cell.teamAway.sizeToFit()
        cell.teamAway.center.x = 286
        cell.awayImage.image = self.awayImage[indexPath.row]
        
        cell.date.text = self.date[indexPath.row]
        cell.date.sizeToFit()
        cell.date.center.x = self.view.center.x
        
        return cell
    }
    //retorna o tamanho de célula
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    //funcao que habilita qual célula foi clicada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("id da partida: ", matchID[indexPath.row])
        cellTapped = indexPath.row
        
        performSegue(withIdentifier: "matchToComparation", sender: matchID)
    }
    
    func setDate(gameDate: String){
        //arrumando calendário para atual
        let calendar = Calendar.current
        
        //transformando a string no formate de date
        let dateFormatter = ISO8601DateFormatter()
        let rawDate = dateFormatter.date(from: gameDate)
        
        //transformando date para dateComponents no fuso certo
        var dateComponents = calendar.dateComponents([.day, .month, .weekday, .hour, .minute], from: rawDate!)
        dateComponents.timeZone = TimeZone.current
        
        let day = String(format: "%02d", dateComponents.day!) + "/" + String(format: "%02d", dateComponents.month!)
        let hour = String(format: "%02d", dateComponents.hour!) + ":" + String(format: "%02d", dateComponents.minute!)
        self.date.append(day + " - " + hour)
        
        //print("data do jogo: ",self.date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "matchToComparation") {
            // pass data to next view
            let match = segue.destination as! ViewController
            match.matchID = matchID[cellTapped]
        }
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
