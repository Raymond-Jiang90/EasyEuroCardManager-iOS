// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  EasyEuroCardManager.swift
//  EasyEuroCardManager-iOS
//
//  Created by Raymond on 2024/11/20.
//
import Foundation
import CheckoutCardManagement
import UIKit
public final class EasyEuroCardManager {
    
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
    /// Result type that can provide CardList or a network error
    public typealias CardListResult = Result<[Card], CardManagementError>
    /// Completion handler returning CardListResult
    public typealias CardListResultCompletion = ((CardListResult) -> Void)
    
    /// Initialiser with single configuration for all returned UI components
    /// font:  Font used when returning UI component
    /// textColor :  Text color used when returning UI component
    public init(font: UIFont,textColor: UIColor,environment:EasyEuroCardManagerEnvironment) {
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
                        completionHandler(.failure(.configurationIssue(hint: "The card ID cannot be matched to a card")));
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
    
    public func initCards(cardId:String,completionHandler: @escaping CardListResultCompletion){
        cardManager?.getCards(completionHandler: {(result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    completionHandler(.success(cards));
                    break;
                case .failure(let error):
                    completionHandler(.failure(error));
                    break;
                }
            }
        });
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
    
    /// Request a secure UI component containing security number for the card
    public func getSecurityCode(singleUseToken:String,completionHandler: @escaping SecureResultCompletion){
        card?.getSecurityCode(singleUseToken: singleUseToken, completionHandler: completionHandler);
    }
    
    ///  return card holder name
    public func getCardholderName() -> String{
        return card?.cardholderName ?? "";
    }
    
    ///  return card expiry date
    public func getCardExpiryDate() -> String{
        if(!(card?.expiryDate.year.isEmpty ?? true) && !(card?.expiryDate.month.isEmpty ?? true)){
            return (card?.expiryDate.year ?? "") + "-" + (card?.expiryDate.month ?? "");
        }
        return "";
    }
    
    public func getCardExpiryYear() -> String{
        if(!(card?.expiryDate.year.isEmpty ?? true)){
            return card?.expiryDate.year ?? "";
        }
        return "";
    }
    
    public func getCardExpiryMonth() -> String{
        if(!(card?.expiryDate.month.isEmpty ?? true)){
            return card?.expiryDate.month ?? "";
        }
        return "";
    }
    
    public func configurePushProvisioning(cardHolderId:String,appGroupId:String,uimage:UIImage,completionHandler: @escaping ((CheckoutCardManager.OperationResult) -> Void)){
        if(card == nil){
            return;
        }
        let configuration = ProvisioningConfiguration(issuerID: D1WrappingCredentials.issuerID,
                                                      serviceRSAExponent: D1WrappingCredentials.serviceRSAExponent.data(using: .utf8)!,
                                                      serviceRSAModulus: D1WrappingCredentials.serviceRSAModulus.data(using: .utf8)!,
                                                      serviceURLString: D1WrappingCredentials.serviceURL,
                                                      digitalServiceURLString: D1WrappingCredentials.digitalCardURL);
        cardManager?.configurePushProvisioning(cardholderID: cardHolderId, appGroupId: appGroupId, configuration: configuration, walletCards: [(card!,uimage)], completionHandler: completionHandler);
    }
    
    public func configurePushProvisioning(cardHolderId:String,appGroupId:String,walletCards: [(Card, UIImage)],completionHandler: @escaping ((CheckoutCardManager.OperationResult) -> Void)){
        let configuration = ProvisioningConfiguration(issuerID: D1WrappingCredentials.issuerID,
                                                      serviceRSAExponent: D1WrappingCredentials.serviceRSAExponent.data(using: .utf8)!,
                                                      serviceRSAModulus: D1WrappingCredentials.serviceRSAModulus.data(using: .utf8)!,
                                                      serviceURLString: D1WrappingCredentials.serviceURL,
                                                      digitalServiceURLString: D1WrappingCredentials.digitalCardURL);
        cardManager?.configurePushProvisioning(cardholderID: cardHolderId, appGroupId: appGroupId, configuration: configuration, walletCards: walletCards, completionHandler: completionHandler);
    }
    
    /// Add the card object to the Apple Wallet
    ///
    /// - Parameters:
    ///     - provisioningToken: Push Provisioning token
    ///     - completionHandler: Completion Handler returning the outcome of the provisioning operation
    public func provision(provisioningToken:String,completionHandler: @escaping ((CheckoutCardManager.OperationResult) -> Void)){
        card?.provision(provisioningToken: provisioningToken, completionHandler: completionHandler);
    }
    
    public func getDigitizationState(provisioningToken:String,completionHandler: @escaping ((CheckoutCardManager.CardDigitizationResult) -> Void)){
        card?.getDigitizationState(provisioningToken: provisioningToken, completionHandler: completionHandler);
    }
}
