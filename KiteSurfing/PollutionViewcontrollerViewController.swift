//
//  PollutionViewcontrollerViewController.swift
//  KiteChannelUK
//
//  Created by simon palmer on 18/06/2023.
//

import UIKit

class PollutionViewcontrollerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pollutioncheck(_ sender: Any) {UIApplication.shared.open(URL(string:"https://www.sas.org.uk/water-quality/sewage-pollution-alerts/")!as URL, options :[:], completionHandler: nil)
    }
    
    
    @IBAction func donate(_ sender: Any) {UIApplication.shared.open(URL(string:"https://www.sas.org.uk/donate/")!as URL, options :[:], completionHandler: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
