//
//  SettingsViewController.swift
//  SeaFight
//
//  Created by Алех on 26.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fieldSizePicker: UIPickerView!
    @IBOutlet weak var turnSegment: UISegmentedControl!
    @IBOutlet weak var debugSwitch: UISwitch!
    
    @IBOutlet weak var cellsLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    

    

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellsLabel.text = "One cells\nTwo cells\nThree cells\nFour cells"
        refreshSettingsViewController()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sea.dimensions.count
    }
 
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sea.dimensions[row].description + "x" + sea.dimensions[row].description
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
  
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sea.dimension = sea.dimensions[fieldSizePicker.selectedRow(inComponent: 0)]
        sea.settings.seaSizeIndex = fieldSizePicker.selectedRow(inComponent: 0)
        refreshSettingsViewController()
    }
 
    
    
    @IBAction func playerSegmentChanged(_ sender: Any) {
         sea.settings.firstTurnIndex = turnSegment.selectedSegmentIndex
        
        
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            sea.shootNow = .own
        case 1:
            sea.shootNow = .enemy
        default:
            break
        }
        
    }
      
    @IBAction func debugSwitchChanged(_ sender: Any) {
        sea.settings.isDebugMode = debugSwitch.isOn
    }
    
    
    func refreshSettingsViewController() {
        DispatchQueue.main.async {
            self.fieldSizePicker.selectRow(sea.settings.seaSizeIndex, inComponent: 0, animated: false)
            self.turnSegment.selectedSegmentIndex = sea.settings.firstTurnIndex
            self.debugSwitch.isOn = sea.settings.isDebugMode
            
            
            if let index = sea.dimensions.index(of: sea.dimension) {
                self.countLabel.text = ""
                for ships in sea.shipsCount[index] {
                    self.countLabel.text?.append(ships.description + "\n") 
                }
            }
        }
    }


}
