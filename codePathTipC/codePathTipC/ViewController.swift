//
//  ViewController.swift
//  codePathTipC
//
//  Created by Bhalla, Kapil on 3/9/17.
//  Copyright © 2017 Bhalla, Kapil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // datamembers
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipPercentageChoice: UISegmentedControl!
    
    static let tipPercentages = [15, 20, 25]
    static let TIP_DEFAULT_PERCENTAGE_KEY = "tip.default.perentage"
    
    let DATE_SAVED_KEY = "last.saved.date"
    let AMOUNT_SAVED_KEY = "last.saved.amount"
    
    let USDAmountFormattingStyle: String = "$%.2f"
    let amountFormattingStyle: String = "%.2f"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        autoLoadBillAmountSmartly()
    }

    override func viewWillAppear(_ animated: Bool) {
        // check for the default values of the tip percentage from the defaults.
        
        // make the input field selected by default and keyboard open.
        billField.becomeFirstResponder()

        readDefaultTipFromDefaults()
        readValuesAndCalculate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // save the amount to the defaults with time of save
        let defaults = UserDefaults.standard
        defaults.setValue(Date(), forKey: DATE_SAVED_KEY)
        
        if (billField.text != nil){
            let billAmount = Double (billField.text!)
            defaults.setValue(billAmount, forKey: AMOUNT_SAVED_KEY)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        // if the input post conversion is nil then return 0
        readValuesAndCalculate ()
    }
    
    func readValuesAndCalculate () {
        // if the input post conversion is nil then return 0
        let billAmount = Double(billField.text!) ?? 0
        let tipPercentage = ViewController.tipPercentages[tipPercentageChoice.selectedSegmentIndex]
        let calculationResultObject = amountCalculation(billAmount, tipPercentage)
        
        setUIElements (calculationResultObject.totalAmount, calculationResultObject.tipAmount)
    }
    
    func setUIElements (_ totalAmount: Double, _ tipAmount: Double) {
        // the formatter stuff could be a utility in common code.
        tipLabel.text = String(format: USDAmountFormattingStyle, tipAmount)
        totalLabel.text = String(format: USDAmountFormattingStyle, totalAmount)
    }
    
    // Function calculates the tip ampunt and the total amount.
    func amountCalculation ( _ pBillAmount: Double? = 0, _ pTipPercentage: Int) -> (totalAmount: Double, tipAmount: Double) {
        // calculate the tip amount
        let tipAmount = pBillAmount! * Double(pTipPercentage) / 100
        
        return ((pBillAmount! + tipAmount), tipAmount)
    }
    
    // This function reads the user defaults for the property
    func readDefaultTipFromDefaults () -> (Int){
        let defaults = UserDefaults.standard
        
        let defaultTipValue = defaults.integer(forKey: ViewController.TIP_DEFAULT_PERCENTAGE_KEY)
        
        // set the UI control to display the value read from defaults.
        for index in (0..<(ViewController.tipPercentages.count)){
            if (ViewController.tipPercentages[index] == defaultTipValue){
                //print(tipPercentages[index])
                tipPercentageChoice.selectedSegmentIndex = index
            }
        }
        
        return ViewController.tipPercentages[tipPercentageChoice.selectedSegmentIndex]
    }
    
    func autoLoadBillAmountSmartly () {
        let defaults = UserDefaults.standard
        
        if (defaults.object(forKey: DATE_SAVED_KEY) != nil){
            let previousSavedDate = defaults.object(forKey: DATE_SAVED_KEY) as! Date
            
            let currentDate = Date ()
            // if difference between current date and saved date is more than 10 minutes then clear the amount field.
            
            let interval = currentDate.timeIntervalSince(previousSavedDate)
            
            //let TEN_MINUTES: Double = 60 * 10
            let FIVE_SECONDS: Double = 5
            
            if (interval > FIVE_SECONDS) {
                billField.text = ""
            } else {
                if (defaults.object(forKey: AMOUNT_SAVED_KEY) != nil){
                    let previousSavedAmount = defaults.object(forKey: AMOUNT_SAVED_KEY) as! Double
                    billField.text = String(format: amountFormattingStyle, previousSavedAmount)
                }
            }
        }
    }
}
