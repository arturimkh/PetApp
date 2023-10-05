//
//  AppStep.swift
//  PetApp
//
//  Created by Artur Imanbaev on 20.09.2023.
//

import Foundation
import RxFlow

enum AppStep: Step{
    case userIsAuthorized
    case userIsUnauthorized
}

