//
//  AVFoundation+Asset.swift
//  WatchMovies LITE
//
//  Created by User on 15.05.2024.
//

import Foundation
import AVFoundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension NSDataAsset: AVAssetResourceLoaderDelegate{
    
    @objc public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        if let infoRequest = loadingRequest.contentInformationRequest{
            infoRequest.contentType = typeIdentifier
            infoRequest.contentLength = Int64(data.count)
            infoRequest.isByteRangeAccessSupported = true
        }
        
        if let dataRequest = loadingRequest.dataRequest{
            dataRequest.respond(with: data.subdata(in:Int(dataRequest.requestedOffset) ..< Int(dataRequest.requestedOffset) + dataRequest.requestedLength))
            loadingRequest.finishLoading()
            
            return true
        }
        return false
    }
}

extension AVURLAsset {
    
    public convenience init?(_ dataAsset: NSDataAsset){
        guard let name = dataAsset.name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = URL(string: "NSDataAsset://\(name))") else {
            return nil
        }
        
        self.init(url: url) // not really used!
        self.resourceLoader.setDelegate(dataAsset, queue: .main)
        // Retain the weak delegate for the lifetime of AVURLAsset
        objc_setAssociatedObject(self, "AVURLAsset+NSDataAsset", dataAsset, .OBJC_ASSOCIATION_RETAIN)
    }
}
