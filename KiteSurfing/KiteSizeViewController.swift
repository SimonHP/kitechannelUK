//
//  KiteSizeViewController.swift
//  KiteSurfing
//
//  Created by Ram Suthar on 22/12/20.
//

import UIKit

class KiteSizeViewController: UIViewController {
    
    let service = Service()
    @IBOutlet weak var kiteSizeEstimation: UILabel!
    
    @IBOutlet weak var windInKnots: UITextField!
    @IBOutlet weak var weightInKG: UITextField!
    @IBOutlet weak var kiteView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reset(self)
    }
    
    @IBAction func submit(_ sender: Any) {
        view.endEditing(true)
        
        guard let windSpeed = windInKnots.text,
              let weight = weightInKG.text,
              !windSpeed.isEmpty,
              !weight.isEmpty else {
            
            return
        }
        let w = Float(weight)!
        let s = Float(windSpeed)!
        let x = (w/s)*2.2
        let size = Int(ceil(x))
        
        kiteSizeEstimation.text = "\(size) metre-squared"
        
        kiteView.isHidden = false
//        submitButton.isHidden = true
        resetButton.isHidden = false
    }
    
    @IBAction func reset(_ sender: Any) {
        windInKnots.text = ""
        weightInKG.text = ""
        kiteView.isHidden = true
//        submitButton.isHidden = false
        resetButton.isHidden = true
    }
}
