//
//  MapView.swift
//  PetApp
//
//  Created by Artur Imanbaev on 21.09.2023.
//

import UIKit
import MapKit
import SnapKit
import RxSwift
import RxRelay
final class MapView: UIView {
    
    private let mapMkView = MKMapView()
    
    private let timeSelectionView = TimeSelectionView()
    
    private let walkButton = WalkButton()
    
    private let navigateButton = NavigationButton()
    
    private let isTimeSelectionShow = BehaviorRelay<Bool>(value: true)
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        bindTimeSelection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Bindings
    public func bind(
        beginWalkButtonTap: PublishRelay<Void>,
        walkIsActive: BehaviorRelay<Bool>,
        navigationButtonTapped: PublishRelay<Void>
    ){
        walkButton.bind(tap: beginWalkButtonTap, //получаем событие
                        isActive: walkIsActive) //тут отдаем его
        
        walkIsActive
            .bind(to: isTimeSelectionShow)
            .disposed(by: disposeBag)
        
        navigateButton.bind(tap: navigationButtonTapped)
    }
    
    public func bindToSelectionTimerView(timerCellTapped:  PublishRelay<IndexPath>,
                                         timerActivated: BehaviorRelay<Int>,
                                         walkIsActive: BehaviorRelay<Bool>
    ){
        timeSelectionView
            .bind(timerCellTapped: timerCellTapped,
                  timerActivated: timerActivated,
                  walkIsActive: walkIsActive)
    }
    
    private func bindTimeSelection(){
        isTimeSelectionShow
            .bind { [weak self] event in
                guard let self = self else {return}
                if event {
                    UIView.animate(withDuration: 1) {
                        self.setConstraints()
                        self.navigateButton.layoutIfNeeded()
                    }
                } else{
                    UIView.animate(withDuration: 1) {
                        self.showTimeSelectionView()
                        self.timeSelectionView.layoutIfNeeded()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    public func setRegion(pin: BehaviorRelay<MKPointAnnotation>,
                          region: BehaviorRelay<MKCoordinateRegion>){
        pin.bind{ [weak self] pointAnnotation in
            guard let self else {return}
            self.mapMkView.addAnnotation(pointAnnotation)
        }
        .disposed(by: disposeBag)
        
        region.bind{ [weak self] coordinateRegion in
            guard let self else {return}
            self.mapMkView.setRegion(coordinateRegion, animated: true)
        }
        .disposed(by: disposeBag)
    }
}

private extension MapView{
    func setViews(){
        addSubview(mapMkView)
        mapMkView.addSubview(walkButton)
        mapMkView.addSubview(navigateButton)
    }
    func setConstraints(){
        timeSelectionView.removeFromSuperview()
        
        mapMkView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }
        walkButton.snp.makeConstraints { make in
            make.bottom.equalTo(mapMkView.snp.bottom).offset(-60)
            make.left.equalTo(mapMkView.snp.left).offset(17)
            make.right.equalTo(mapMkView.snp.right).offset(-17)
            walkButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07).isActive = true
        }
        navigateButton.snp.makeConstraints { make in
            make.right.equalTo(mapMkView.snp.right).offset(-17)
            make.bottom.equalTo(walkButton.snp.top).offset(-17)
            navigateButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
            navigateButton.widthAnchor.constraint(equalToConstant: 47).isActive = true
        }
    }

    func showTimeSelectionView(){
        mapMkView.addSubview(timeSelectionView)
        navigateButton.removeFromSuperview()
        mapMkView.addSubview(navigateButton)
        
        timeSelectionView.snp.makeConstraints { make in
            make.bottom.equalTo(walkButton.snp.top).offset(-20)
            make.left.equalTo(mapMkView.snp.left).offset(17)
            make.right.equalTo(mapMkView.snp.right).offset(-17)
            timeSelectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12).isActive = true
        }
        navigateButton.snp.makeConstraints { make in
            make.right.equalTo(mapMkView.snp.right).offset(-17)
            make.bottom.equalTo(timeSelectionView.snp.top).offset(-17)
            navigateButton.heightAnchor.constraint(equalToConstant: 47).isActive = true
            navigateButton.widthAnchor.constraint(equalToConstant: 47).isActive = true
        }
    }
}
