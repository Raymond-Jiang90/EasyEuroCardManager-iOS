# EasyEuroCardManager-iOS
# Integration

### Import SDK
Use SPM to import the SDK into your app:

1. In **Xcode**, select _File > Swift Packages > Add Package Dependency_.
2. When prompted, enter `enter https://github.com/Raymond-Jiang90/EasyEuroCardManager-iOS.git`.

See Apple's [Add a package dependency](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app#Add-a-package-dependency) documentation for more information.

### Prepare card manager
To start consuming SDK functionality, instantiate the main object, which enables access to the functionality:
```Swift
// The statement should match the library imported in the previous step
import EasyEuroCardManager

let cardManager = EasyEuroCardManager(font: UIFont.boldSystemFont(ofSize: 22), textColor: .black,environment: .production);
let easyeuroOOB = EasyEuroOOB(environment: .production);
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  *****
}

1、EasyEuroCardManager

### Prepare card manager
To start consuming SDK functionality, instantiate the main object, which enables access to the functionality:
```Swift
// The statement should match the library imported in the previous step
import EasyEuroCardManager

let cardManager = EasyEuroCardManager(font: UIFont.boldSystemFont(ofSize: 22), textColor: .black,environment: .production);
let easyeuroOOB = EasyEuroOOB(environment: .production);
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  *****
}
```

### Login user
In order to provide your users with the SDK functionality, you must authenticate them for the session.

In a Live environment, you are responsible for ensuring you authenticate a user for the session. This means your application should retrieve a session token from your authentication backend.

1、get access-token

2、log in with access token.
```Swift
let token = "";
guard cardManager.logInSession(token: token) else {
    print("Could not login with the current credentials");
        return
}
print("login with the current credentials");
```
### init card with cardId

Once you’ve authenticated the card, and your application, you can do next function.


```Swift
cardManager.initCard(cardId: "crd_xxx", completionHandler: {result in
            switch(result){
            case .success(_):
            //init card successful.
            //then use getPan、getPin、getSecurityCode、getPanAndSecurityCode
                break;
            case .failure(let error):
                // print error msg.
                break;
            }
        });
```
### get card pin
Request a secure UI component containing pin number for the card
```Swift
cardManager.getPin(singleUseToken: "", completionHandler: {secureResult in
    switch (secureResult) {
    case .success(let view):
        //If successful, you'll receive a UI component that you can display to the user
        break;
    case .failure(let error):
        break;
    }
});
```

### get card pan
Request a secure UI component containing long card number for the card
```Swift
init card successful
cardManager.getPan(singleUseToken: "", completionHandler: {secureResult in
    switch (secureResult) {
    case .success(let view):
        //If successful, you'll receive a UI component that you can display to the user
        break;
    case .failure(let error):
        break;
    }
});
```

### get card security code

Request a secure UI component containing security number for the card
```Swift
cardManager.getSecurityCode(singleUseToken: "", completionHandler: {secureResult in
    switch (secureResult) {
    case .success(let view):
        //If successful, you'll receive a UI component that you can display to the user
        break;
    case .failure(let error):
        break;
    }
});
```

### get card pan and security code

Request a tuple made of pan and security code protected UI components for the card
```Swift
cardManager.getPanAndSecurityCode(singleUseToken: "", completionHandler: {secureResult in
    switch (secureResult) {
    case .success(let views):
        //If successful, you'll receive a UI component that you can display to the user
        break;
    case .failure(let error):
        break;
    }
});
```

### Push Provisioning
**Push Provisioning** is the operation of adding a physical or virtual card to a digital wallet. On iOS, this means adding a card to an Apple Wallet

1、get provisioning token

2、use provisioning token in provision function.
```Swift
cardManager.initCard(cardId: "crd_xxxx", completionHandler: {result in
            switch(result){
            case .success(_):
                cardManager.provision(cardHolderId: "crh_xxx", provisioningToken: "token", completionHandler: {operationResult in
                    switch operationResult {
                    case .success:
                        // If successful, this means add a card to Apple Wallet completed.
                        break;
                    case .failure(let error):
                        break;
                    }
                });
                break;
            case .failure(let error):
                break;
            }
        });
```
