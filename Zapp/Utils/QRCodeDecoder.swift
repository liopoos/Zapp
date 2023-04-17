//
//  QRCodeDecoder.swift
//  Zapp
//
//  Created by hades on 2023/4/2.
//

import Cocoa
import CoreImage


class QRCodeDecoder {
    private var status: QRCodeDecodeStatus = .failure
    private var message: String?
    
    func decode(image: NSImage) -> QRCodeDecodeStatus {
        guard let ciImage = CIImage(data: image.tiffRepresentation!) else {
            status = .failure
            return status
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: ciImage)
        
        if let feature = features?.first as? CIQRCodeFeature {
            message = feature.messageString
            status = .success
        } else {
            message = nil
            status = .failure
        }
        
        return status
    }
    
    func getStatus() -> QRCodeDecodeStatus {
        return status
    }
    
    func getMessage() -> String? {
        return message
    }
}
