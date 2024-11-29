// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  EasyEuroCardManagerStub.swift
//
//  Created by Raymond on 2024/11/20.
//

import Foundation
import CheckoutCardManagementStub
import UIKit
public final class EasyEuroCardManagerStub {
    
    private var cardManager:CheckoutCardManager?;
    private var card:Card?;
    
    /// Result type that on success delivers a secure UIView to be presented to the user, and on failure delivers an error to identify problem
    public typealias SecureResult = Result<UIView, CardManagementError>
    /// Completion handler returning a SecureResult
    public typealias SecureResultCompletion = ((SecureResult) -> Void)
    /// Result type that on success delivers secure UIViews for PAN & SecurityCode, and on failure delivers an error to identify problem
    public typealias SecurePropertiesResult = Result<(pan: UIView , securityCode: UIView), CardManagementError>
    /// Completion handler returning a SecurePropertiesResult
    public typealias SecurePropertiesResultCompletion = ((SecurePropertiesResult) -> Void)
    /// Result type that can provide CardResult or a network error
    public typealias CardResult = Result<String, CardManagementError>
    /// Completion handler returning CardResult
    public typealias CardResultCompletion = ((CardResult) -> Void)
    
    /// Initialiser with single configuration for all returned UI components
    /// font:  Font used when returning UI component
    /// textColor :  Text color used when returning UI component
    public init(font: UIFont,textColor: UIColor,environment:EasyEuroCardManagerEnvironmentStub) {
        cardManager = CheckoutCardManager(designSystem: CardManagementDesignSystem(font: font, textColor: textColor),environment: environment.toEnvironment());
    }
    
    /// Store provided token to use on network calls. If token is rejected, any previous session token will be removed.
    public func logInSession(token: String) -> Bool {
        return cardManager?.logInSession(token: token) ?? false;
    }
    
    /// Remove current token from future calls
    public func logoutSession(){
        cardManager?.logoutSession();
    }
    
    /// Initialize a single card based on the card id
    public func initCard(cardId:String,completionHandler: @escaping CardResultCompletion){
        cardManager?.getCards(completionHandler: {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    self.card = cards.filter({$0.id == cardId}).first;
                    if(self.card == nil){
                        completionHandler(.failure(CardManagementError.connectionIssue));
                    }else{
                        completionHandler(.success(""));
                    }
                    break
                case .failure(let error):
                    completionHandler(.failure(error));
                    break;
                }
            }
        })
    }
    
    /// Request a secure UI component containing pin number for the card
    public func getPin(singleUseToken:String,completionHandler: @escaping SecureResultCompletion){
        card?.getPin(singleUseToken: singleUseToken, completionHandler: completionHandler);
    }
    
    /// Request a tuple made of pan and security code protected UI components for the card
    public func getPanAndSecurityCode(singleUseToken:String,completionHandler: @escaping SecurePropertiesResultCompletion){
        card?.getPanAndSecurityCode(singleUseToken: singleUseToken, completionHandler: completionHandler);
    }
    
    /// Request a secure UI component containing long card number for the card
    public func getPan(singleUseToken:String,completionHandler: @escaping SecureResultCompletion){
        card?.getPan(singleUseToken: singleUseToken, completionHandler: completionHandler);
    }
    
    /// Request a secure UI component containing long card number for the card
    public func getSecurityCode(singleUseToken:String,completionHandler: @escaping SecureResultCompletion){
        card?.getSecurityCode(singleUseToken: singleUseToken, completionHandler: completionHandler);
    }
    
    /// Add the card object to the Apple Wallet
    ///
    /// - Parameters:
    ///     - cardhodlerID: Identifier for the cardholder owning the card
    ///     - provisioningToken: Push Provisioning token
    ///     - completionHandler: Completion Handler returning the outcome of the provisioning operation
    public func provision(cardHolderId:String,provisioningToken:String,completionHandler: @escaping ((CheckoutCardManager.OperationResult) -> Void)){
        let configuration = ProvisioningConfiguration(issuerID: D1WrappingCredentials.issuerID,
                                                      serviceRSAExponent: D1WrappingCredentials.serviceRSAExponent.data(using: .utf8)!,
                                                      serviceRSAModulus: D1WrappingCredentials.serviceRSAModulus.data(using: .utf8)!,
                                                      serviceURLString: D1WrappingCredentials.serviceURL,
                                                      digitalServiceURLString: D1WrappingCredentials.digitalCardURL);
        card?.provision(cardholderID: cardHolderId, configuration: configuration, provisioningToken: provisioningToken, completionHandler: completionHandler);
    }
}
