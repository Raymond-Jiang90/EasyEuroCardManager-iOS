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
    
    /**
         Information required to register the device with OOB
    
         - Parameters:
           - token: Token to register the device. *Should be received from app backend*.
           - cardId: ID of the card that's being registered for OOB. *30 characters*.
           - applicationId: Unique ID that defines the application instance. *Probably your notification token*.
           - countryCode: Telephone number area code
           - phoneNumber: Phone number of the card holder. This phone number is independent of the card holder's phone number on file.
           - locale: Card’s locale. .english or .french.
    
         - Throws: ``ConfigurationError``
         */
    public func deviceRegistration(token: String, cardId: String, applicationId: String, countryCode:String,phoneNumber:String, locale: Locale) throws -> CheckoutOOB.DeviceRegistration? {
        let deviceRegistration = try? CheckoutOOB.DeviceRegistration(token: token, cardID: cardId, applicationID: applicationId, phoneNumber: CheckoutOOB.PhoneNumber(countryCode: countryCode, number: phoneNumber), locale: locale.toLocal());
        return deviceRegistration;
    }
    
    /**
       Register the app instance with Out of Band authentication
    
       - Parameter deviceRegistration: Device Registration Details
    
       - Throws: ``InternalError``
    
       - Returns: Device Registration Response
       */
    public func registerDevice(deviceRegistration:CheckoutOOB.DeviceRegistration) async throws{
        try await checkoutOOB.registerDevice(with: deviceRegistration);
    }
    
    /**
         Information required to authenticate payment via OOB
    
         - Parameters:
           - token: Token to authenticate the payment. *Should be received from app backend*.
           - cardId: ID of the card that's authenticating the payment with OOB. *30 characters*.
           - transactionId: Unique transaction ID.
           - method: Authentication method for the OOB challenge *.biometrics, .login or .other*.
           - decision: User's response to the payment authentication. *.accepted or .declined*.
    
         - Throws: ``ConfigurationError``
         */
    public func authenticate(token: String, cardId: String,transactionId:String,method:Method,decision:Decision) async throws{
        let paymentAuthentication = try CheckoutOOB.Authentication(token: token,cardID: cardId,transactionID: transactionId,method:method.toMethod(),decision: decision.toDecision());
        try await checkoutOOB.authenticatePayment(with: paymentAuthentication);
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
extension EasyEuroOOB {
    public enum Decision : String {

        /// When the user is validated by SCA and accepts the transaction
        case accepted

        /// When the user declines the transaction
        case declined
        
        func toDecision() -> CheckoutOOBSDK.CheckoutOOB.Decision{
            switch self {
            case .accepted:return .accepted;
            case .declined:return .declined;
            }
        }

    }
}
extension EasyEuroOOB {
    public enum Method : String {

        /// SCA is validated via biometrics
        case biometrics

        /// SCA is validated via app login
        case login

        /// SCA is validated via another method
        case other
        
        func toMethod() -> CheckoutOOBSDK.CheckoutOOB.Method{
            switch self {
            case .biometrics:return .biometrics;
            case .login:return .login;
            case .other:return .other;
            }
        }

    }
}
