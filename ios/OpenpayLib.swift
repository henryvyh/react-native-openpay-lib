import Foundation

@objc(OpenpayLib)
class OpenpayLib: NSObject {

  //  private var openpay: Openpay?
  private var initialized: Bool = false

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }

  @objc(initOpenpay:resolver:rejecter:)
  func initOpenpay(args: NSDictionary, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) -> Void {
    guard let merchantId = args["merchantId"] as? String,
          let apiKey = args["apiKey"] as? String,
          let productionMode = args["productionMode"] as? Bool else {
      rejecter("INIT_ERROR", "Invalid arguments provided", nil)
      return
    }

    // self.openpay = Openpay(withMerchantId: merchantId, apiKey: apiKey, productionMode: productionMode)
    self.initialized = true
    resolver(true)
  } 


  @objc(getDeviceSessionId:rejecter:) 
  func getDeviceSessionId(resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) -> Void {
    guard initialized else {
      rejecter("NOT_INITIALIZED", "Openpay is not initialized", nil)
      return
    }

    guard let currentActivity = UIApplication.shared.delegate?.window??.rootViewController else {
      rejecter("DEVICE_SESSION_ERROR", "No current activity available", nil)
      return
    }

    do {
      // Suponiendo que 'openpay.deviceCollectorDefaultImpl().setup' es una función válida
            // Aquí debes reemplazarlo con la lógica real de Openpay para obtener el device session ID.
      let deviceSessionId = "deviceSessionId" // Simulado, reemplaza con el real
      resolver(deviceSessionId)
    } catch let error {
      rejecter("DEVICE_SESSION_ERROR", "Failed to get device session ID", error)
    }
  } 

    @objc(createToken:resolver:rejecter:)
    func createToken(cardDetails: NSDictionary, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        guard initialized else {
            rejecter("NOT_INITIALIZED", "Openpay is not initialized", nil)
            return
        }

         // Obtener los detalles de la tarjeta
        guard let holderName = cardDetails["holderName"] as? String,
              let cardNumber = cardDetails["cardNumber"] as? String,
              let expirationMonth = cardDetails["expirationMonth"] as? String,
              let expirationYear = cardDetails["expirationYear"] as? String,
              let cvv2 = cardDetails["cvv"] as? String else {
            rejecter("INVALID_CARD_DETAILS", "Card details are incomplete or invalid", nil)
            return
        }

        // Crear el objeto tarjeta (suponiendo que Openpay tiene un objeto similar)
        // let card = Card()
        // card.holderName = holderName
        // card.cardNumber = cardNumber
        // card.expirationMonth = expirationMonth
        // card.expirationYear = expirationYear
        // card.cvv2 = cvv2

        // Llamar a Openpay para crear el token
        // openpay.createToken(card, success: { token in
        //     print("Generated Token: \(String(describing: token))")
        //     resolver(token?.id)
        // }, failure: { serviceException in
        //     let errorCode = serviceException?.errorCode ?? "UNKNOWN_ERROR"
        //     var errorDescription = "Unknown error"
            
        //     switch serviceException?.errorCode {
        //     case 3001:
        //         errorDescription = "The card was declined by the bank."
        //     case 3002:
        //         errorDescription = "The card has expired."
        //     case 3003:
        //         errorDescription = "Insufficient funds."
        //     case 3004:
        //         errorDescription = "The card was reported as stolen."
        //     case 3005:
        //         errorDescription = "Fraud suspected."
        //     default:
        //         errorDescription = "Error code: \(errorCode). Check Openpay documentation for details."
        //     }
        //     rejecter(errorCode, errorDescription, nil)
        // })

        resolver(cardNumber)
        
    }

}
