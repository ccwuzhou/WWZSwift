//
//  WWZCaptureTool.swift
//  WWZSwift
//
//  Created by wwz on 17/3/10.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit
import AVFoundation

public typealias WWZScanResultBlock = (_ result: [String]) -> ()

open class WWZCaptureTool: NSObject {
    
    /// 是否绘制扫描到的二维码边框
    public var isDrawCodeFrameFlag : Bool = false
    
    /// 开始扫描
    public func startRunning(inView: UIView, result: @escaping WWZScanResultBlock) {
        
        if WWZCaptureTool.isCaptureDenyAuthorizationed() {return}
        
        self.resultBlock = result
        
        // 使用会话, 添加输入和输出
        if self.captureSession.canAddInput(self.captureInput) && self.captureSession.canAddOutput(self.captureOutput) {
            
            self.captureSession.addInput(self.captureInput)
            self.captureSession.addOutput(self.captureOutput)
        }
        // 此项设置, 只能设置到session添加输出之后, 否则扫描无效
        self.captureOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // 添加视频预览图层
        self.previewLayer.frame = inView.bounds
        inView.layer.insertSublayer(self.previewLayer, at: 0)
        
        // 启动会话, 监听元数据处理后的结果
        self.captureSession.startRunning()
    }
    
    /// 停止扫描
    public func stopRunning() {
        
        if WWZCaptureTool.isCaptureDenyAuthorizationed() {return}
        self.captureSession.stopRunning()
    }
    /// 设置兴趣点
    public func setOriginRectOfInterest(originRect: CGRect) {
    
        // 注意: 每个参数的取值都是对应的比例
        // 注意: 坐标系, 是横屏状态下的坐标系
        let screenBounds = UIScreen.main.bounds
        let x = originRect.origin.y / screenBounds.size.height
        let y = originRect.origin.x / screenBounds.size.width
        let width = originRect.size.height / screenBounds.size.height
        let height = originRect.size.width / screenBounds.size.width
        
        self.captureOutput.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
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
    
    // MARK: -内部属性
    // 会话
    fileprivate lazy var captureSession : AVCaptureSession! = {
        
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        return session
    }()
    
    // 输入设备
    fileprivate lazy var captureInput : AVCaptureDeviceInput? = {
        
        var captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            
            print("取得后置摄像头时出现问题.");
            return nil
        }
        
        return input
        
        
    }()
    // 元数据输出处理
    fileprivate lazy var captureOutput : AVCaptureMetadataOutput = {
        
        let output = AVCaptureMetadataOutput()
        // 设置元数据输出处理代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        return output
    }()
    // 预览图层
    fileprivate lazy var previewLayer : AVCaptureVideoPreviewLayer! = {
        
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        return layer
    }()
    
    // 记录需要执行的代码块
    fileprivate var resultBlock : WWZScanResultBlock?
}

// MARK: -扫描框
extension WWZCaptureTool {

    // 添加扫描框
    fileprivate func addShowLayer(resultCodeObject: AVMetadataMachineReadableCodeObject) {
        
        if resultCodeObject.corners == nil || resultCodeObject.corners.count == 0{ return }
        
        // 创建图层
        let showLayer: CAShapeLayer = CAShapeLayer()
        showLayer.lineWidth = 2.0
        showLayer.strokeColor = UIColor.red.cgColor
        showLayer.fillColor = UIColor.clear.cgColor
        
        // 创建图层路径, 并根据四角绘制线
        let path = UIBezierPath()
        // 解析点
        var resultPointArray = [CGPoint]()
        for pointDic in resultCodeObject.corners{
            // 将点字典转换成为点
            let point = CGPoint(dictionaryRepresentation: pointDic as! CFDictionary)
            resultPointArray.append(point!)
        }
        
        // 移动到第一个点
        path.move(to: resultPointArray[0])
        
        // 添加剩下的三个点
        for i in (1...3)
        {
            path.addLine(to: resultPointArray[i])
        }
        
        // 关闭路径
        path.close()
        
        showLayer.path = path.cgPath
        
        // 将layer, 添加到图层上
        self.previewLayer.addSublayer(showLayer)
    }
    
    // 移除扫描框
    fileprivate func removeShowLayer() {
        
        guard let subLayers = self.previewLayer.sublayers else { return }
        
        for layer in subLayers {
            
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
    }
}
// MARK: -AVCaptureMetadataOutputObjectsDelegate
extension WWZCaptureTool : AVCaptureMetadataOutputObjectsDelegate{
 
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        self.removeShowLayer()
        
        var tempArray = [String]()
        
        for metadataObj in metadataObjects {
            
            guard let obj = metadataObj as? AVMetadataObject else { continue }
            
            guard let codeObject = self.previewLayer.transformedMetadataObject(for: obj) as? AVMetadataMachineReadableCodeObject else { continue }
            
            guard let stringValue = codeObject.stringValue else { continue }
            tempArray.append(stringValue)
            
            if self.isDrawCodeFrameFlag {
                self.addShowLayer(resultCodeObject: codeObject)
            }
        }
        
        self.resultBlock?(tempArray)
    }
}
