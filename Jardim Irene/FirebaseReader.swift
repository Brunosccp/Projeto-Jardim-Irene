//
//  FirebaseReader.swift
//  Jardim Irene
//
//  Created by Bruno Rocca on 31/07/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import Foundation
import Firebase

class FirebaseReader{
    let ref = Database.database().reference()
    
    func getMatchesInfo(completion: @escaping (_ matchday: Int, _ matchesList: [[String : Any]]) -> Void) {
        //criando lista de matches
        var matchesList: [[String : Any]] = []
        
        //obtendo referencia de matches
        ref.child("BrazilSerieA").child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let matchday = value!["currentMatchday"] as? Int
            
            //percorrendo cada key de cada partida
            for key in value!.allKeys{
                self.ref.child("BrazilSerieA").child("matches").child("\(key)").observeSingleEvent(of: .value, with: {(snapshot2) in
                    let value2 = snapshot2.value as? NSDictionary
                    
                    //testando se é partida (por causa do currentMatchday) e se a partida é da rodada atual
                    if(value2?["homeTeamID"] != nil && value2?["matchday"] as? Int == matchday){
                        //convertendo NSDictionary para [String : Any] e assim, jogando na lista
                        let match = value2! as! [String : Any]
                        matchesList.append(match)
                        
                    }   //chegou no matchday, vulgo ultima informação de matches, então retorna
                    else{
                        completion(matchday!, matchesList)
                    }
                    
                })
            }
        })
    }
    
    func getTeamsInfo(completion: @escaping (_ teamsList: [[String : Any]]) -> Void){
        var teamsList: [[String : Any]] = []
        
        ref.child("BrazilSerieA").child("teams").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            //print("todas as keys: ",value!.allKeys)
            let lastKey = value!.allKeys[value!.count - 1] as! String

            //percorrendo cada key de cada time
            for key in value!.allKeys{
                self.ref.child("BrazilSerieA").child("teams").child("\(key)").observeSingleEvent(of: .value, with: {(snapshot2) in
                    let value2 = snapshot2.value as? NSDictionary
                    
                    let team = value2! as! [String : Any]
                    //print("time achado pelo getTeams:", team["name"])
                    teamsList.append(team)
                    
                    //se for a ultima key retorna
                    if(key as! String == lastKey){
                        completion(teamsList)
                    }

                    //print(value2)
                    
                })
            }
            
        })
    }
}
