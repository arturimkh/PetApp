//
//  RxViewModel.swift
//  PetApp
//
//  Created by Artur Imanbaev on 21.09.2023.
//

import Foundation
import RxSwift

protocol RxViewModel {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}
