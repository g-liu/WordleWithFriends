//
//  NumberRangePickerView.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

final class NumberRangePickerView: UIPickerView {
  private let minValue: Int
  private let maxValue: Int
  
  var didSelectNewValue: ((Int) -> Void)?
  
  init(frame: CGRect = .zero, minValue: Int, maxValue: Int) {
    self.minValue = minValue
    self.maxValue = maxValue
    
    super.init(frame: frame)
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
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func selectValue(_ value: Int) {
    guard minValue <= value, value <= maxValue else { return }
    selectRow(value - minValue, inComponent: 0, animated: true)
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
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    66
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let actualValue = row + minValue
   didSelectNewValue?(actualValue)
  }
}
