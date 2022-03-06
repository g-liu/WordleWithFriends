//
//  WordGuessRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessRow: UITableViewCell {
  static let identifier = "WordGuessRow"
  
  private lazy var calculatedHeight: CGFloat = {
    let gridSize = LayoutUtility.gridSize(numberOfColumns: GameSettings.clueLength.readIntValue(),
                                          padding: calculatedPadding,
                                          screenWidthPercentage: 85,
                                          maxSize: 50)
    
    return floor(gridSize)
  }()
  
  private lazy var calculatedPadding: CGFloat = {
    let padding = LayoutUtility.gridPadding(numberOfColumns: GameSettings.clueLength.readIntValue())
    return CGFloat(padding)
  }()
  
  private lazy var guessRowView: WordGuessRowView = {
    .init()
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupCell()
  }
  
  private func setupCell() {
    contentView.addSubview(guessRowView)
    
    NSLayoutConstraint.activate([
      guessRowView.topAnchor.constraint(equalTo: contentView.topAnchor),
      guessRowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -calculatedPadding),
      guessRowView.heightAnchor.constraint(equalToConstant: calculatedHeight),
      guessRowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    ])
  }
  
  func configure(with wordGuess: WordGuess = .init()) {
    guessRowView.configure(with: wordGuess)
  }
}

final class WordGuessRowView: UIStackView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    axis = .horizontal
    distribution = .fillEqually
    alignment = .fill
    spacing = CGFloat(LayoutUtility.gridPadding(numberOfColumns: GameSettings.clueLength.readIntValue()))
    
    (0...(GameSettings.clueLength.readIntValue()-1)).forEach { _ in
      let tile = LetterTileView()
      addArrangedSubview(tile)
    }
  }
  
  func configure(with wordGuess: WordGuess = .init()) {
    removeAllArrangedSubviews()
    (0...(GameSettings.clueLength.readIntValue()-1)).forEach { index in
      let tile = LetterTileView(letterGuess: wordGuess.guess(at: index))
      addArrangedSubview(tile)
    }
  }
  
  func mark(_ index: Int, as letterState: LetterState) {
    guard index >= 0, index < arrangedSubviews.count,
          let letterTile = arrangedSubviews[index] as? LetterTileView else { return }
    
    letterTile.setState(letterState)
  }
}
