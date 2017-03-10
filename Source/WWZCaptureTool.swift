//
//  WWZCaptureTool.swift
//  WWZSwift
//
//  Created by wwz on 17/3/10.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit
import AVFoundation

public protocol WWZCaptureToolDelegate: NSObjectProtocol {
    
    func captureTool(captureTool: WWZCaptureTool, captureStringValue value: String);
}


open class WWZCaptureTool: NSObject {
    
    public var delegate : WWZCaptureToolDelegate?
    
    /**
     *  显示视频预览层
     *
     *  @param layer super layer
     */
    public func showPreviewLayer(inLayer: CALayer) {
        
        if WWZCaptureTool.isCaptureDenyAuthorizationed() { return }
        
        self.previewLayer.frame = inLayer.bounds
        
        inLayer.insertSublayer(self.previewLayer, at: 0)
    }
    /**
     *  开始扫描
     */
    public func startRunning() {
        
        if WWZCaptureTool.isCaptureDenyAuthorizationed() {return}
        self.captureSession.startRunning()
    }
    /**
     *  停止扫描
     */
    public func stopRunning() {
        
        if WWZCaptureTool.isCaptureDenyAuthorizationed() {return}
        self.captureSession.stopRunning()
    }
    
    /**
     *  手电简开关
     */
    public func setIsTorchModeOn(torchModeOn: Bool) {
        
        if WWZCaptureTool.isCaptureDenyAuthorizationed() {
            return
        }
        
        let torchMode : AVCaptureTorchMode = torchModeOn ? .on : .off
        
        guard let captureDevice = self.captureInput?.device else {return}
        
        guard ((try? captureDevice.lockForConfiguration()) != nil) else {return}
        guard captureDevice.isTorchModeSupported(torchMode) else {return}
        
        captureDevice.torchMode = torchMode
        
        captureDevice.unlockForConfiguration()
    }
    
    public class func isCaptureDenyAuthorizationed() -> Bool{
        
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .denied
    }
    
    fileprivate lazy var captureSession : AVCaptureSession! = {
        
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        if session.canAddInput(self.captureInput) {
            
            session.addInput(self.captureInput)
        }
        if session.canAddOutput(self.captureOutput) {
            
            session.addOutput(self.captureOutput)
        }
        
        self.captureOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        return session
        
    }()
    
    fileprivate lazy var captureInput : AVCaptureDeviceInput? = {
        
        var captureDevice : AVCaptureDevice?
        
        guard let devices = (AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice]) else { return nil }
        
        for device in devices {
            
            if device.position == .back {
                
                captureDevice = device
                break
            }
        }
        
        guard let captureInputDevice = captureDevice else {
            print("取得后置摄像头时出现问题.");
            return nil
        }
        
        guard let input = try? AVCaptureDeviceInput(device: captureInputDevice) else { return nil }
        
        return input
        
        
    }()
    
    fileprivate lazy var captureOutput : AVCaptureMetadataOutput! = {
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        return output
    }()
    
    fileprivate lazy var previewLayer : AVCaptureVideoPreviewLayer! = {
        
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        return layer
    }()
}


extension WWZCaptureTool : AVCaptureMetadataOutputObjectsDelegate{
    /**
     *  扫描成功调用
     */
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        guard metadataObjects.count > 0 else {
            return
        }
        
        self.captureSession.stopRunning()
        
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else { return }
        
        guard let stringValue = metadataObj.stringValue else { return }
        
        if let delegate = self.delegate {
            
            delegate.captureTool(captureTool: self, captureStringValue: stringValue)
        }
    }
}
