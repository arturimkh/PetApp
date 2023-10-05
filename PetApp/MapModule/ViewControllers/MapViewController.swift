//
//  AuthViewController.swift
//  PetApp
//
//  Created by Sergei Smirnov on 06.09.2023.
//

import UIKit
import MapKit
import RxSwift
import SnapKit
final class MapViewController: UIViewController{

    let viewModel: any MapViewModelProtocol
    
    private let mapView = MapView()
    
    init(viewModel: any MapViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        bind()
    }

    private func setupView(){
        view.addSubview(mapView)
    }
    
    private func setConstraints(){
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    private func bind(){
        mapView.bind(beginWalkButtonTap: viewModel.input.beginWalkButtonTap,
                    walkIsActive: viewModel.output.walkIsActive,
                     navigationButtonTapped: viewModel.input.navigationButtonTap)
        
        mapView.bindToSelectionTimerView(timerCellTapped: viewModel.input.timerCellTapped,
                                         timerActivated: viewModel.output.timerActivated,
                                         walkIsActive: viewModel.output.walkIsActive)
        
        mapView.setRegion(pin: viewModel.output.locationIsPinned,
                          region: viewModel.output.locationCoordinate)
    }
}
