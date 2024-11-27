//
//  EasyEuroCardManagerEnvironment.swift
//  EasyEuroCardManager-iOS
//
//  Created by Raymond on 2024/11/26.
//

import Foundation
import CheckoutCardManagement
public enum EasyEuroCardManagerEnvironment {
    
    /// Development environment with a backend built for development work
    case sandbox
    
    /// Production environment meant for the real world
    case production
    
    func toEnvironment() -> CardManagerEnvironment{
        switch self {
        case .sandbox:return .sandbox;
        case .production:return .production;
        }
    }
}
