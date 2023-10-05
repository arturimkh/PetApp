//
//  MapStep.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import RxFlow
@frozen enum MapStep: Step{
    case alertIsRequired
    case mapIsRequired
}
