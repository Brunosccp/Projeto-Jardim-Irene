//
//  ViewController.swift
//  Jardim Irene
//
//  Created by Bruno Rocca on 31/07/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import Firebase
import Charts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //informações dos times que vão se enfrentar
    var homeInfo: [String] = []
    var awayInfo: [String] = []
    
    var info = ["Posição", "Pontos", "Jogos", "Vitórias", "Derrotas", "Empates", "Gols Pró", "Gols Contra", "Saldo de Gols"]
    
    //img dos times que vão se enfrentar
    @IBOutlet weak var homeImg: UIImageView!
    @IBOutlet weak var awayImg: UIImageView!
    
    //declarando gráficos
    @IBOutlet weak var resultChart: PieChartView!
    @IBOutlet weak var twoGoalsChart: PieChartView!
    
    //criando variáveis dos gráficos que recebem valores
    var homeOddEntry = PieChartDataEntry(value: 0)
    var awayOddEntry = PieChartDataEntry(value: 0)
    var drawOddEntry = PieChartDataEntry(value: 0)
    var moreTwoGoals = PieChartDataEntry(value: 0)
    var noMoreTwoGoals = PieChartDataEntry(value: 0)
    
    
    var oddsEntry = [PieChartDataEntry]()
    var twoGoalsEntry = [PieChartDataEntry]()
    
    //id da partida (recebe de um segue)
    var matchID: Int = -1
    
    @IBOutlet var tableView: UITableView!
    
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //criando gráficos
        resultChart.chartDescription?.text = ""
        resultChart.legend.enabled = false
        
        twoGoalsChart.chartDescription?.text = ""
        twoGoalsChart.legend.enabled = false
        
        
        
        
        let reader = FirebaseReader()
        //chamando funções com completion para sincronizar com o load do Firebase
        reader.getMatchesInfo(completion: { matchday, matchesList in
            reader.getTeamsInfo(completion: { teamsList in
                
                //print("teste2: ", matchesList)
                //print("teste3: ", teamsList)
                //print("id da partida no viewController: ",self.matchID)
                
                //achando qual a posição da partida no array
                var matchArray = -1
                
                for i in 0..<matchesList.count{
                    if(self.matchID == matchesList[i]["id"] as! Int){
                        matchArray = i
                        break
                    }
                }
                
                var homeTeamID = matchesList[matchArray]["homeTeamID"] as! Int
                var awayTeamID = matchesList[matchArray]["awayTeamID"] as! Int
                
                var homeTeamArray = -1
                var awayTeamArray = -1
                
                //consertando cagada da api
                if(homeTeamID == 1839){
                    homeTeamID = 6684
                }else if(awayTeamID == 1839){
                    awayTeamID = 6684
                }
                
                //achando qual a posição dos times no array
                for i in 0..<teamsList.count{
                    if(homeTeamID == teamsList[i]["id"] as! Int){
                        //print(teamsList[i]["name"])
                        homeTeamArray = i
                    }
                    else if(awayTeamID == teamsList[i]["id"] as! Int){
                        //print(teamsList[i]["name"])
                        awayTeamArray = i
                    }
                }
                
                //pegando a informação de jogos jogados
                let homeGamesPlayed = ((teamsList[homeTeamArray]["won"]! as! Int) + (teamsList[homeTeamArray]["draw"]! as! Int) + (teamsList[homeTeamArray]["lost"]! as! Int))
                let awayGamesPlayed = ((teamsList[awayTeamArray]["won"]! as! Int) + (teamsList[awayTeamArray]["draw"]! as! Int) + (teamsList[awayTeamArray]["lost"]! as! Int))
                
                //jogando informações do time da casa
                self.homeInfo.append("\(teamsList[homeTeamArray]["position"]!)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["points"]!)")
                self.homeInfo.append("\(homeGamesPlayed)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["won"]!)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["draw"]!)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["lost"]!)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["goalsFor"]!)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["goalsAgainst"]!)")
                self.homeInfo.append("\(teamsList[homeTeamArray]["goalDifference"]!)")
                
                //jogando informações do time de fora
                self.awayInfo.append("\(teamsList[awayTeamArray]["position"]!)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["points"]!)")
                self.awayInfo.append("\(awayGamesPlayed)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["won"]!)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["draw"]!)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["lost"]!)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["goalsFor"]!)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["goalsAgainst"]!)")
                self.awayInfo.append("\(teamsList[awayTeamArray]["goalDifference"]!)")
                
                //atualizando img dos times
                self.homeImg.image = UIImage(named: "\(homeTeamID)")
                self.awayImg.image = UIImage(named: "\(awayTeamID)")
                
                //jogando dados nos gráficos
                self.homeOddEntry.value = (matchesList[matchArray]["homeWinOdd"] as! Double) * 100
                self.homeOddEntry.label = "Mandante"
                self.awayOddEntry.value = (matchesList[matchArray]["awayWinOdd"] as! Double) * 100
                self.awayOddEntry.label = "Visitante"
                self.drawOddEntry.value = (matchesList[matchArray]["drawOdd"] as! Double) * 100
                self.drawOddEntry.label = "Empate"
                
                self.oddsEntry = [self.homeOddEntry, self.awayOddEntry, self.drawOddEntry]
                
                self.moreTwoGoals.value = (matchesList[matchArray]["moreThan2GoalsOdd"] as! Double) * 100
                self.moreTwoGoals.label = "Mais de 2 gols"
                self.noMoreTwoGoals.value = (1.0 - (matchesList[matchArray]["moreThan2GoalsOdd"] as! Double)) * 100
                self.noMoreTwoGoals.label = "Menos de 2 gols"
                
                self.twoGoalsEntry = [self.moreTwoGoals, self.noMoreTwoGoals]
                
                //atualizando gráficos
                self.updateCharts()
                
                //atualizando table view
                self.tableView.reloadData()
            })
            
        })
        
    }
    
    //atualiza os gráficos
    func updateCharts(){
        //atualizando as odds
        let chartDataSetOdds = PieChartDataSet(values: oddsEntry, label: nil)
        let chartDataOdds = PieChartData(dataSet: chartDataSetOdds)
        chartDataSetOdds.sliceSpace = (2.0)
        
        //atualizando odd de 2 gols
        let chartDataSetTwoGoals = PieChartDataSet(values: twoGoalsEntry, label: nil)
        let chartDataTwoGoals = PieChartData(dataSet: chartDataSetTwoGoals)
        chartDataSetTwoGoals.sliceSpace = (2.0)
        
        //adicionado cor nas odds
        let colorsOdds = [UIColor.red.withAlphaComponent(0.6), UIColor.blue.withAlphaComponent(0.6), UIColor.yellow.withAlphaComponent(0.6)]
        chartDataSetOdds.colors = colorsOdds
        
        //adicionando cor na odd de 2 gols
        let colorsTwoGoals = [UIColor.orange.withAlphaComponent(0.6), UIColor.cyan.withAlphaComponent(0.6)]
        chartDataSetTwoGoals.colors = colorsTwoGoals
        
        resultChart.data = chartDataOdds
        resultChart.data?.setValueTextColor(UIColor.darkText)
        
        twoGoalsChart.data = chartDataTwoGoals
        twoGoalsChart.data?.setValueTextColor(UIColor.darkText)
    }
    
    //retorna a quantidade de células da table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeInfo.count
    }
    //retorna a célula costumizada para a table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ComparationCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ComparationCell
        
        cell.homeLabel.text = self.homeInfo[indexPath.row]
        cell.awayLabel.text = self.awayInfo[indexPath.row]
        
        cell.infoLabel.text = self.info[indexPath.row]
        cell.infoLabel.sizeToFit()
        cell.infoLabel.center.x = self.view.center.x
        
        return cell
    }
    //retorna o tamanho de célula
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
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

