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
                
                self.homeTeam.append("bob")
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
