import Foundation
import OpenpayKit
import UIKit

@objc(OpenpayLib)
class OpenpayLib: NSObject {

  var openpay : Openpay!
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
     
    self.openpay = Openpay(withMerchantId: merchantId, andApiKey: apiKey, isProductionMode: productionMode, isDebug: true,countryCode: "MX")
     
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
       // TODO: Implementar la obtención del device session ID
       // currently crashes when the device session is requested
      // try  self.openpay.createDeviceSessionId(
      //   successFunction: { sessionID in
      //       // print("SessionID: \(sessionID)")
      //       resolver(sessionID)
             
      //   },
      //   failureFunction: { error in
      //       // print("\(error.code) - \(error.localizedDescription)")
      //       rejecter("DEVICE_SESSION_ERROR", "Failed to get device session ID", error) // Retorna el error en caso de fallo
      //   }
      //   )
       //
      let deviceSessionId = "deviceSessionId" // Simulado, reemplaza con el real
      resolver(deviceSessionId)
    } catch let error {
      rejecter("DEVICE_SESSION_ERROR", "Failed to get device session ID", error)
    }
  } 

    @objc(createToken:resolver:rejecter:)
    func createToken(cardDetails: NSDictionary, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) -> Void {
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
        let card = TokenizeCardRequest(cardNumber: cardNumber,holderName:holderName, expirationYear: expirationYear, expirationMonth: expirationMonth, cvv2: cvv2)
        
      self.openpay.tokenizeCard(card: card) { (OPToken) in
          print(OPToken.id)     
          resolver(OPToken.id) 
          NSLog("Generated Device Session ID:\(OPToken.id)")       
      } failureFunction: { (NSError) in
          NSLog("Generated Device Session ID:\(NSError)")  
          rejecter("INVALID_CARD_TOKEN", "Card details are invalid:\(NSError)", nil) 
      }
        
    }

}
