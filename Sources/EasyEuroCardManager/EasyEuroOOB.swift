//
//  EasyEuroOOB.swift
//
//  Created by Raymond on 2024/11/21.
//

import Foundation
import CheckoutOOBSDK
public struct EasyEuroOOB {
    
    var checkoutOOB:CheckoutOOB;
    
    /// Result type that can provide CardResult or a network error
    public typealias CardOOBResult = Result<String, Error>
    /// Completion handler returning CardResult
    public typealias CardOOBResultCompletion = ((CardOOBResult) -> Void)
    
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
    public func registerDevice(token: String, cardID: String, applicationID: String, countryCode:String,number:String, locale: Locale,completionHandler: @escaping CardOOBResultCompletion) async throws{
        guard let deviceRegistration = try? CheckoutOOB.DeviceRegistration(token: token, cardID: cardID, applicationID: applicationID, phoneNumber: CheckoutOOB.PhoneNumber(countryCode: countryCode, number: number), locale: .english) else {
//            completionHandler(.failure(<#T##any Error#>));
            return;
        };
        try await checkoutOOB.registerDevice(with: deviceRegistration);
        completionHandler(.success(""));
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
