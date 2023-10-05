//
//  TimeSelectionCollectionViewCell.swift
//  PetApp
//
//  Created by Artur Imanbaev on 25.09.2023.
//

import UIKit
import SnapKit
final class TimeSelectionCollectionViewCell: UICollectionViewCell {
    
    private lazy var timeLabel = makeTimeLabel()
    override var isSelected: Bool {
       didSet{
           if self.isSelected {
               UIView.animate(withDuration: 0.15) { // for animation effect
                   self.backgroundColor = .secondarySystemBackground
               }
           }
           else {
               UIView.animate(withDuration: 0.15) { // for animation effect
                   self.backgroundColor = .white
               }
           }
       }
   }
    static var identifier: String {
        return String(describing: TimeSelectionCollectionViewCell.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func configure(with text: String){
        timeLabel.text = text
    }
}
private extension TimeSelectionCollectionViewCell{
    func setView(){
        addSubview(timeLabel)
        layer.cornerRadius = 10
    }
    func setConstraints(){
        timeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func makeTimeLabel() -> UILabel{
        let label = UILabel()
        label.textAlignment = .center
        label.text = "5"
        label.font = .systemFont(ofSize: 13)
        return label
    }
}
