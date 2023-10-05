//
//  MapAssembly.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import UIKit
import RxSwift
final class MapAssembly{
    func createMapScreen() -> MapViewController {
        let mapService = MapService()
        let mapViewModel = MapViewModel(mapService: mapService)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        return mapViewController
    }
    func createAlertMessage() -> UIAlertController{
        let alert = UIAlertController(title: "Служба геолокации выключена", message: "Хотите включить?", preferredStyle: .alert)
        let setting = UIAlertAction(title: "Настройки", style: .default) { alert in
            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES"){
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(setting)
        alert.addAction(cancelAction)
        return alert
    }
}
