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
    
    func getMatchesInfo(completion: @escaping (_ matchday: Int, _ count: [[String : Any]]) -> Void) {
        //obtendo referencia de matches
        var matchesList: [[String : Any]] = []
        
        ref.child("BrazilSerieA").child("matches").observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let matchday = value!["currentMatchday"] as? Int
            
            //obtendo cada key de cada partida
            for key in value!.allKeys{
                self.ref.child("BrazilSerieA").child("matches").child("\(key)").observeSingleEvent(of: .value, with: {(snapshot2) in
                    let value2 = snapshot2.value as? NSDictionary
                    
                    //testando se é partida (por causa do currentMatchday) e se a partida é da rodada atual
                    if(value2?["homeTeamID"] != nil && value2?["matchday"] as? Int == matchday){
                        //convertendo NSDictionary para [String : Any] e assim, jogando na lista
                        let mom = value2! as! [String : Any]
                        matchesList.append(mom)
                        
                    }   //chegou no matchday, vulgo ultima informação de matches, então retorna
                    else{
                        //print(matchesList)
                        completion(matchday!, matchesList)
                    }
                    
                })
            }
        })
    }
}
