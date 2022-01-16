//
//  NumberRangePickerView.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

final class NumberRangePickerView: UIPickerView {
  let minValue: Int
  let maxValue: Int
  
  init(minValue: Int, maxValue: Int) {
    self.minValue = minValue
    self.maxValue = maxValue
    
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    minValue = 0
    maxValue = 0
    
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    delegate = self
    dataSource = self
  }
}

extension NumberRangePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    (maxValue - minValue) + 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    "\(minValue + row)"
  }
}
