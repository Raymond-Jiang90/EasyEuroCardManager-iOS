//
//  EasyEuroOOB.swift
//
//  Created by Raymond on 2024/11/21.
//

import Foundation
import CheckoutOOBSDK
public struct EasyEuroOOB {
    
    var checkoutOOB:CheckoutOOB;
    
    /**
    
       - Parameter environment: Environment for the OOB SDK *.sandbox or .production*
       */
    public init(environment: Environment){
        checkoutOOB = CheckoutOOB(environment: environment.toEnvironment());
    }
    
    public func deviceRegistration(token: String, cardID: String, applicationID: String, countryCode:String,number:String, locale: Locale) throws -> CheckoutOOB.DeviceRegistration? {
        let deviceRegistration = try? CheckoutOOB.DeviceRegistration(token: token, cardID: cardID, applicationID: applicationID, phoneNumber: CheckoutOOB.PhoneNumber(countryCode: countryCode, number: number), locale: .english);
        return deviceRegistration;
    }
    
    /**
       Register the app instance with Out of Band authentication
    
       - Parameter deviceRegistration: Device Registration Details
    
       - Throws: ``InternalError``
    
       - Returns: Device Registration Response
       */
    public func registerDevice(with deviceRegistration: CheckoutOOBSDK.CheckoutOOB.DeviceRegistration) async throws{
        try await checkoutOOB.registerDevice(with: deviceRegistration);
    }
}
extension EasyEuroOOB {

    /// Environment for Checkout.com Out of Band SDK
    public enum Environment : String, Equatable {

        /// Development environment with a backend built for development work
        case sandbox

        /// Production environment that operates on live data
        case production
        
        func toEnvironment() -> CheckoutOOB.Environment{
            switch self {
            case .sandbox:return .sandbox;
            case .production:return .production;
            }
        }

    }
}
extension EasyEuroOOB {
    public enum Locale : String {

        /// Get the texts in English
        case english

        /// Get the texts in French
        case french
        
        func toLocal() -> CheckoutOOB.Locale{
            switch self {
            case .english:
                return CheckoutOOB.Locale.english;
            case .french:
                return CheckoutOOB.Locale.french;
            }
        }

    }
}
