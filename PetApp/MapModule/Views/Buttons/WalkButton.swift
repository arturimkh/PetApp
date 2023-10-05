//
//  WalkButton.swift
//  PetApp
//
//  Created by Artur Imanbaev on 25.09.2023.
//

import UIKit
import RxSwift
import RxRelay
import CoreImage
class WalkButton: UIButton {
    
    // MARK: - Private properties
    private let walkIsActive = BehaviorRelay(value: true)
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Bindings
    private func bind() {
        walkIsActive
            .filter { $0 }
            .bind { [weak self] _ in
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.layer.borderWidth = 0
                    guard let self = self else { return }
                        self.backgroundColor = .systemBlue
                        self.doGlowAnimation(withColor: .systemBlue)
                        self.setTitle("Начать прогулку", for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        walkIsActive
            .filter { !$0 }
            .bind { [weak self] _ in
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self = self else { return }
                        self.backgroundColor = .systemRed
                        self.doGlowAnimation(withColor: .systemRed)
                        self.setTitle("Закончить прогулку", for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
    //VC -> View -> VM
    //      output<-
    public func bind(tap: PublishRelay<Void>,
                     isActive: BehaviorRelay<Bool>
    ) {
        isActive
            .bind(to: walkIsActive)
            .disposed(by: disposeBag)
        rx.tap
            .bind(to: tap)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    private func setup() {
        setTitle("Начать прогулку", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18)
        backgroundColor = .systemBlue
        layer.cornerRadius = 30
        doGlowAnimation(withColor: .systemBlue)
    }
}
