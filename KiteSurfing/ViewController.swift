//
//  ViewController.swift
//  KiteSurfing
//
//  Created by Ram Suthar on 22/12/20.
//

import UIKit

class ViewController: UIViewController {

    let service = Service()
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var gustSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var temperatur: UILabel!
    @IBOutlet weak var nextHW: UILabel!
    @IBOutlet weak var nextLW: UILabel!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var location: UIButton!
    
    
    @IBOutlet weak var nextHWLabel: UILabel!
    @IBOutlet weak var nextLWLabel: UILabel!
    
    var timer: Timer?
    
    var observatory: Observatory = .Arun {
        didSet {
            updateLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refresh(self)
        setupTimer()
        
    }
    
    
    
    func setupTimer() {
        let timeInterval: TimeInterval = 300 // seconds
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(refresh(_:)), userInfo: nil, repeats: true)
    }
    
    func clearUI() {
        dateTime.text = "-"
        windSpeed.text = "-"
        gustSpeed.text = "-"
        windDirection.text = "-"
        temperatur.text = "-"
        nextHW.text = "-"
        nextLW.text = "-"
        error.text = " "
    }
    
    func updateUI(model: Model) {
        dateTime.text = model.dateTime
        windSpeed.text = model.windSpeed + " knots"
        gustSpeed.text = model.gustSpeed + " knots"
        windDirection.text = model.windDirection + "°"
        temperatur.text = model.temperature.isEmpty ? "" : model.temperature + " °C"
        
        if model.nextHW.isEmpty {
            nextHW.isHidden = true
            nextHWLabel.isHidden = true
            nextLW.isHidden = true
            nextLWLabel.isHidden = true
        }
        else {
            nextHW.isHidden = false
            nextHWLabel.isHidden = false
            nextLW.isHidden = false
            nextLWLabel.isHidden = false
            nextHW.text = model.nextHW
            nextLW.text = model.nextLW
        }
    }
    
    func updateLocation() {
        let place = observatory.rawValue.uppercased()
        self.location.setTitle(place, for: .normal)
        self.info.text = "Here is the real time wind and gust data from the channel coast observatory data from the \(place) platform\nhttps://www.channelcoast.org/realtimedata"
        refresh(self)
    }
    
    @IBAction func showLocationOptions(_ sender: Any) {
    
        let options = Observatory.values.sorted()
        
        let alert = UIAlertController(title: "OBSERVATORY", message: "choose your nearest channel coast observatory from the following list", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = location
        
        options.forEach { (value) in
            let action = UIAlertAction(title: value, style: .default) { [unowned self] (action) in
                self.observatory = Observatory(rawValue: value) ?? .Arun
            }
            alert.addAction(action)
        }
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.view.tintColor = .systemTeal
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func refresh(_ sender: Any) {
        clearUI()
        
        service.fetchAll(observatory: observatory) { [weak self] (model) in
            debugPrint(model)
            self?.updateUI(model: model)
        } onError: { [weak self] (e) in
            self?.error.text = "Some error occurred. Please try again later."
        }
        
//        service.fetch(observatory: observatory) { [weak self] (model) in
//            debugPrint(model)
//            self?.updateUI(model: model)
//        } onError: { [weak self] (error) in
//            self?.error.text = "Some error occurred. Please try again later."
//        }
    }
}

