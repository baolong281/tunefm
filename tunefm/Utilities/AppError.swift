//
//  AppError.swift
//  tunefm
//
//  Created by dylan h on 4/25/26.
//

import Foundation

// helper to throw custom runtime errors
enum AppError: Error {
    case runtimeError(String)
}
