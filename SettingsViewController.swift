//
//  SettingsViewController.swift
//  codePathTipC
//
//  Created by Bhalla, Kapil on 3/10/17.
//  Copyright © 2017 Bhalla, Kapil. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipChoice: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readDefaultTipFromDefaults()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func DefaultTipChanged(_ sender: UISegmentedControl) {
        let selectionIndex = defaultTipChoice.selectedSegmentIndex
        let defaultTipRate = ViewController.tipPercentages[selectionIndex]
        
        print(defaultTipRate)
        saveTipAsDefault(defaultTipRate)
    }
    
    func saveTipAsDefault (_ tipPercentage: Int) {
        let defaults = UserDefaults.standard
        defaults.set(tipPercentage, forKey: (ViewController.TIP_DEFAULT_PERCENTAGE_KEY))
        defaults.synchronize()
    }
    
    func readDefaultTipFromDefaults ()  {
        let defaults = UserDefaults.standard
        
        let defaultTipValue = defaults.integer(forKey: ViewController.TIP_DEFAULT_PERCENTAGE_KEY)
        
        for index in (0..<(ViewController.tipPercentages.count)){
            if (ViewController.tipPercentages[index] == defaultTipValue){
                //print(ViewController.tipPercentages[index])
                defaultTipChoice.selectedSegmentIndex = index
            }
        }
    }
}
