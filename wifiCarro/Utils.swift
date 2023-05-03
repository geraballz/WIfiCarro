//
//  Utils.swift
//  wifiCarro
//
//  Created by Gerardo Herrera on 23/07/22.
//

import Foundation
import Alamofire

class Utils {
    func
    sendInstruction(instruction: String, completion: @escaping()->()) {
        let parameters: Parameters = [ "State" : instruction]
        let urlString = "http://192.168.4.1"
        let url = URL.init(string: urlString)
        AF.request(url!, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).response { response in
            print(response)
             switch response.result
            {
            case .success(let json):
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    func sendUDPInstruction(instruction: String, completion: @escaping()->()) {
        let parameters: Parameters = [ "State" : instruction]
        let urlString = "http://192.168.4.1"
        let url = URL.init(string: urlString)
        AF.request(url!, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).response { response in
            print(response)
             switch response.result
            {
            case .success(let json):
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func mapper(x: Double , in_min: Double, in_max: Double, out_min: Double , out_max: Double ) -> Double {
      return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    }
}
