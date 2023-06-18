//
//  Service.swift
//  KiteSurfing
//
//  Created by Ram Suthar on 22/12/20.
//

import Foundation
import SwiftSoup

class Service {
    let key = "831875ef0b67e87bc10c63356ed7aab0"
    
    func identifier(observatory: Observatory) -> String {
        switch observatory {
        
        case .Arun:
            return "86"
        case .Brighton:
            return "88"
        case .Sandown:
            return "92"
        case .Chapel:
            return "120"
        case .Deal:
            return "90"
        case .Felixstow:
            return "125"
        case .Folkstone:
            return "69"
        case .Happisburgh:
            return "123"
        case .Herne:
            return "89"
        case .Looe:
            return "98"
        case .Lymington:
            return "87"
        case .Penzance:
            return "75"
        case .Perranporth:
            return "76"
        case .Portland:
            return "96"
        case .Teignmouth:
            return "94"
        case .West:
            return "95"
        case .Weymouth:
            return "84"
        case .Worthing:
            return "101"
        case .Southwold:
            return "127"
        case .Swanage:
            return "93"
        case .Penarth:
            return "119"
        }
    }
    
    
    func msToKnots(ms: String) -> String {
        guard let wind = Double(ms) else { return "" }
        let windSpeed = String(ceil(wind*1.9426*10)/10)
        return windSpeed
    }
    
    func msToKnots2(ms: String) -> String {
        guard let wind = Double(ms) else { return "" }
        let windSpeed = String(lround(wind*1.9426))
        return windSpeed
    }
    
    var metFeatures: [Feature]?
    var tideFeatures: [Feature]?
    
    func wTime(timeStamp: String?, value: String?) -> String {
        guard let timeStamp = timeStamp, let value = value else {
            return ""
        }
        let df = DateFormatter()
        df.dateFormat = "yyyyMMdd#HHmmss"
        let date = df.date(from: timeStamp)
        if date == nil {
            return ""
        }
        df.dateFormat = "HH:mm"
        let time = df.string(from: date!)
        
        var w = value
        if let wind = Double(value) {
            w = String(round(wind*100)/100)
        }
        return "\(time), \(w)"
    }
    
    func model(for id: String) -> Model? {
        guard let features = metFeatures else {
            return nil
        }
        let props = features.first(where: { $0.properties?.id == id })?.properties
        if let props = props {
            var dateTime = ""
            if let datestring = props.date {
                let df = DateFormatter()
                df.dateFormat = "yyyyMMdd#HHmmss"
                if let date = df.date(from: datestring) {
                    df.dateFormat = "dd-MM-yyyy HH:mm"
                    dateTime = df.string(from: date)
                }
            }
            
            var windSpeed = ""
            if let value = props.value {
                windSpeed = msToKnots(ms: value)
            }
            var gustSpeed = ""
            if let gust = props.gust {
                gustSpeed = msToKnots2(ms: gust)
            }
            
            var direction = ""
            if let dir = props.dir, let value = Double(dir) {
                direction = String(lround(value/10)*10)
            }
            
            var temperature = ""
            if let temp = props.temp, let value = Double(temp) {
                temperature = String(lround(value))
            }
            
            let tideProps = tideFeatures?.first(where: { $0.properties?.id == id })?.properties
            let nextLW = wTime(timeStamp: tideProps?.lwTimestamp, value: tideProps?.lw)
            let nextHW = wTime(timeStamp: tideProps?.hwTimestamp, value: tideProps?.hw)
            
            let aModel = Model(dateTime: dateTime,
                               windSpeed: windSpeed,
                               gustSpeed: gustSpeed,
                               windDirection: direction,
                               temperature: temperature,
                               nextHW: nextHW,
                               nextLW: nextLW)
            return aModel
        }
        return nil
    }
    
    
    
    
    func fetchAll(observatory: Observatory, completion: @escaping (Model)->Void, onError: @escaping (Error)->Void) {
        
        let id = self.identifier(observatory: observatory)
        
        if ["84", "94", "96"].contains(id) {
            fetchHTML(observatory: observatory, completion: completion, onError: onError)
            return
        }
        
//        if let m = model(for: id) {
//            completion(m)
//        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let group = DispatchGroup()
            
            group.enter()
            self.fetchAPI(id: id) { (m) in
                group.leave()
            } onError: { (e) in
                group.leave()
            }
            
            group.enter()
            self.fetchHWLWAPI(id: id) { (m) in
                group.leave()
            } onError: { (e) in
                group.leave()
            }
            
            group.notify(queue: .global(qos: .background)) {
                
                if let m = self.model(for: id) {
                    DispatchQueue.main.async {
                        
                        completion(m)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        
                        onError(NSError(domain: "KiteSurfing", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Could not load data"]))
                    }
                }
            }
        }
    }
    
    func fetchAPI(id: String, completion: @escaping ([Feature]?)->Void, onError: @escaping (Error)->Void) {
        
        
        let urlString = "https://data.channelcoast.org/observations/met/latest.geojson?key=\(key)"
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("http://kitesurfingapp.com", forHTTPHeaderField: "referer")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data
                {
                let metResponse = try? JSONDecoder().decode(MetResponse.self, from: data)
                self.metFeatures = metResponse?.features
                completion(self.metFeatures)
            }
        }
        task.resume()
        
    }
    
    func fetchHWLWAPI(id: String, completion: @escaping ([Feature]?)->Void, onError: @escaping (Error)->Void) {
        let urlString = "https://data.channelcoast.org/observations/tides/latest.geojson?key=\(key)"
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("http://kitesurfingapp.com", forHTTPHeaderField: "referer")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data
                {
                let metResponse = try? JSONDecoder().decode(MetResponse.self, from: data)
                self.tideFeatures = metResponse?.features
                completion(self.tideFeatures)
            }
            
        }
        task.resume()
        
    }
    
    
    /// Below code for parsing data from HTML
    
    func fetchHTML(observatory: Observatory, completion: @escaping (Model)->Void, onError: @escaping (Error)->Void) {
        
        let id = identifier(observatory: observatory)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let urlString = "https://www.channelcoast.org/realtimedata/?chart=\(id)&tab=met&disp_option="
            let urlString2 = "https://www.channelcoast.org/realtimedata/?chart=\(id)&tab=tides&disp_option="
            
            do {
                
                guard let doc: Document = self.fetchUrl(urlString: urlString) else {
                    
                    onError(NSError(domain: "KiteSurfing", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Could not load data"]))
                    return
                }
                
                let tds = try doc.select("div.table-responsive td")
                
                var dateTime = "-"
                var windSpeed = "-"
                var gustSpeed = "-"
                var windDirection = "-"
                var temperature = "-"
                if !tds.isEmpty() {
                    dateTime = try tds[0].text()
                    windSpeed = try tds[2].text()
                    gustSpeed = try tds[4].text()
                    windDirection = try tds[6].text()
                    temperature = try tds[7].text()
                }
                
                let doc2: Document = self.fetchUrl(urlString: urlString2)!
                let tds2 = try doc2.select("div.col-md-3 td")
                
                var nextHW = ""
                var nextLW = ""
                if !tds2.isEmpty() {
                    nextHW = try tds2[0].text()
                    nextLW = try tds2[1].text()
                }
                
                if nextHW == "-, -" {
                    nextHW = ""
                }
                
                if nextLW == "-, -" {
                    nextLW = ""
                }
                
                let model = Model(dateTime: dateTime,
                                  windSpeed: windSpeed,
                                  gustSpeed: gustSpeed,
                                  windDirection: windDirection,
                                  temperature: temperature,
                                  nextHW: nextHW,
                                  nextLW: nextLW)
                
                DispatchQueue.main.async {
                    completion(model)
                }
            }
            catch (let error) {
                debugPrint(error)
                DispatchQueue.main.async {
                    onError(error)
                }
            }
            
        }
    }
    
    func fetchHWLW(id: String) -> (String, String) {
        let urlString2 = "https://www.channelcoast.org/realtimedata/?chart=\(id)&tab=tides&disp_option="
        
        do {
            
            let doc2: Document = self.fetchUrl(urlString: urlString2)!
            let tds2 = try doc2.select("div.col-md-3 td")
            
            var nextHW = ""
            var nextLW = ""
            if !tds2.isEmpty() {
                nextHW = try tds2[0].text()
                nextLW = try tds2[1].text()
            }
            
            return (nextLW, nextHW)
        }
        catch (let error) {
            debugPrint(error)
            return ("", "")
        }
    }
    
    private func fetchUrl(urlString: String) -> Document? {
        let url = URL(string: urlString)!
        do {
            let htmlString = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(htmlString)
            return doc
        }
        catch (let error) {
            debugPrint(error)
        }
        
        return nil
    }
    
    
}
