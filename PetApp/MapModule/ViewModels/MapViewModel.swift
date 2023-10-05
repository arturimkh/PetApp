//
//  MapViewModel.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay
import MapKit

struct MapViewModelInput {
    let beginWalkButtonTap: PublishRelay<Void>
    let timerCellTapped: PublishRelay<IndexPath>
    let navigationButtonTap: PublishRelay<Void>
}

struct MapViewModelOutput {
    let walkIsActive: BehaviorRelay<Bool>
    let timerActivated: BehaviorRelay<Int>
    let locationIsPinned: BehaviorRelay<MKPointAnnotation>
    let locationCoordinate: BehaviorRelay<MKCoordinateRegion>
}

protocol MapViewModelProtocol: Stepper,RxViewModel where
                                Input == MapViewModelInput,
                                Output == MapViewModelOutput{
}
final class MapViewModel: MapViewModelProtocol{
    
    var locationIsOn = PublishRelay<Bool>()
        
    var steps = PublishRelay<Step>()
    
    let disposeBag = DisposeBag()

    let mapService: MapServiceProtocol
    
    //MARK: - Input
    var input: MapViewModelInput
    
    let beginWalkButtonTap = PublishRelay<Void>()
    
    let timerCellTapped = PublishRelay<IndexPath>()
    
    let navigationButtonTap = PublishRelay<Void>()

    
    //MARK: - Output
    var output: MapViewModelOutput
    
    let walkIsActive = BehaviorRelay<Bool>(value: true)
    
    let timerActivated = BehaviorRelay<Int>(value: 0)
    
    let locationIsPinned = BehaviorRelay<MKPointAnnotation>(value: MKPointAnnotation())
    
    let locationCoordinate = BehaviorRelay<MKCoordinateRegion>(value: MKCoordinateRegion())
    
    init(mapService: MapServiceProtocol){
        self.mapService = mapService
        input = Input(beginWalkButtonTap: beginWalkButtonTap,
                      timerCellTapped: timerCellTapped,
                      navigationButtonTap: navigationButtonTap)
        
        output = Output(walkIsActive: walkIsActive,
                        timerActivated: timerActivated,
                        locationIsPinned:locationIsPinned,
                        locationCoordinate:locationCoordinate)
        
        bind()
    }
    private func bind(){
        bindTap()
        bindTimer()
        bindNavigationButton()
    }
    private func bindTap(){
        beginWalkButtonTap
            .withLatestFrom(walkIsActive)
            .map {!$0}
            .bind(to:walkIsActive)
            .disposed(by: disposeBag)
    }
    private func bindNavigationButton(){
        navigationButtonTap.subscribe { [weak self] _ in
            guard let self = self else {return}
            self.getLocation()
        }
        .disposed(by: disposeBag)
    }
    private func bindTimer(){
        timerCellTapped.map{ indexPath in
            switch indexPath.row{
            case 0:
                return 5
            case 1:
                return 15
            case 2:
                return 30
            case 3:
                return 45
            default:
                return 0
            }
        }.bind(to: timerActivated)
        .disposed(by: disposeBag)
    }
    private func getLocation(){
        mapService.getUserLocation  { [weak self] myLocation in
            guard let self = self else {return}

            DispatchQueue.main.async {
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude,
                                                            myLocation.coordinate.longitude)
                
                let center = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude,
                                                    longitude: myLocation.coordinate.longitude)
                print(center)
                self.locationIsPinned.accept(pin)
                self.locationCoordinate.accept(MKCoordinateRegion(center: center,
                                                                  span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                                         longitudeDelta: 0.01)))
            }
        }
    }
}
