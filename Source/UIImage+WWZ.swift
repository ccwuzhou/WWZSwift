//
//  UIImage-WWZ.swift
//  wwz_swift
//
//  Created by wwz on 17/3/2.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

// MARK: -
extension UIImage {

    /// 图片不透明区渲染
    func wwz_imageMask(maskColor: UIColor) -> UIImage? {
        
        guard let cgImage = self.cgImage else { return nil }
        
        let imageRect = CGRect(origin: CGPoint.zero, size: self.size)
    
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -self.size.height)
        // 获取不透明区域路径
        context?.clip(to: imageRect, mask: cgImage)
        // 设置color
        context?.setFillColor(maskColor.cgColor)
        // 绘制
        context?.fill(imageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImage {

    /// 从bundle中获取图片，imageName 需带后缀
    convenience init?(imageName: String) {

        let filePath = Bundle.main.path(forResource: imageName, ofType: nil)
        
        self.init(contentsOfFile: filePath ?? "")
    }
    
    // 圆形图片
    class func wwz_circleImage(imageName: String, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        
        // 需要裁剪的图片
        guard let image = UIImage(named: imageName) else { return nil}
        
        let imageW = image.size.width + 2 * borderWidth
        let imageH = image.size.height + 2 * borderWidth
        
        // 开启图片上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageW, height: imageH), false, 0.0)
        
        // 获取上下文
        UIGraphicsGetCurrentContext()
        
        let radius = min(image.size.width*0.5, image.size.height*0.5)
        
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageW*0.5, y: imageH*0.5), radius: radius, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        
        // 剪切
        bezierPath.addClip()
        
        // 画图
        image.draw(in: CGRect(x: borderWidth, y: borderWidth, width: image.size.width, height: image.size.height))
        // 获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// 背景转换成图片
    class func wwz_backgroundImage(size: CGSize) -> UIImage? {
    
        let center = CGPoint(x: size.width*0.5, y: size.height*0.5)
        
        let endRadius = sqrtf(Float(size.width * size.width + size.height * size.height)) * 0.5
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        // 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        let components : [CGFloat] = [
            0.0, 0.0, 0.0, 0.1, // More transparent black
            0.0, 0.0, 0.0, 0.7  // More opaque black
        ]
        let locations : [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: components, locations: locations, count: locations.count) else { return nil }
        
        context?.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: CGFloat(endRadius), options: CGGradientDrawingOptions(rawValue: 0))
        
        // 获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


extension UIImage {
    
    /// 得到纯色图片
    class func wwz_image(color: UIColor, size: CGSize, alpha: CGFloat) -> UIImage? {
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setAlpha(alpha)
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 虚线图片
    class func wwz_dashImage(size: CGSize, color: UIColor) -> UIImage? {
    
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let bitmapContext = UIGraphicsGetCurrentContext() else { return nil }
        
        // 设置color
        color.set()
        // 设置线宽
        bitmapContext.setLineWidth(size.height)
        // 设置虚线
        bitmapContext.setLineDash(phase: 0, lengths: [10.0, 5.0])
        
        bitmapContext.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0)])
        
        bitmapContext.strokePath()
        
        // 获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    class func wwz_launchImage(orientation: UIInterfaceOrientation) -> UIImage?{
    
        var viewSize = CGSize.zero
        var viewOrientation = ""
        
        switch orientation {
        case .portrait, .portraitUpsideDown:
            viewSize = UIScreen.main.bounds.size
            viewOrientation = "Portrait"
        case .landscapeLeft, .landscapeRight:
            viewSize = CGSize(width: UIScreen.main.bounds.size.height, height: UIScreen.main.bounds.size.width)
            viewOrientation = "Landscape"
        default:
            break
        }
        
        guard let imageDicts = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String : Any]] else { return nil }
        
        for imageDict in imageDicts {
            
            guard let sizeString = imageDict["UILaunchImageSize"] as? String, let orientationString = imageDict["UILaunchImageOrientation"] as? String, let launchImageString = imageDict["UILaunchImageName"] as? String else { continue }
            
            let imageSize = CGSizeFromString(sizeString)
            
            if imageSize.equalTo(viewSize) && viewOrientation == orientationString {
                
                return UIImage(named: launchImageString)
            }
        }
        return nil
    }
    
    /// 通过图片Data数据第一个字节 来获取图片扩展名
    class func wwz_contentType(imageData: Data) -> String? {
        
        var c : __uint8_t = 0
        
        imageData.copyBytes(to: &c, count: 1)
        
        switch c {
        case 0xFF:
            return "jpeg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        case 0x49, 0x4D:
            return "tiff"
        case 0x52:
            guard imageData.count >= 12 else { return nil }
            
            guard let text = String(data: (imageData as NSData).subdata(with: NSMakeRange(0, 12)), encoding: .ascii) else { return nil }
            
            if text.hasPrefix("RIFF") && text.hasSuffix("WEBP") {
                
                return "webp"
            }
            
        default:
            return nil
        }
        return nil
    }
    
    /// 由二维码生成图片
    class func wwz_image(qrcode: String, size: CGSize) -> UIImage? {
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setDefaults()
        
        let infoData = qrcode.data(using: .utf8)
        
        filter.setValue(infoData, forKeyPath: "inputMessage")
        
        guard let outputImage = filter.outputImage else { return nil }
        
        return self.wwz_image(ciimage: outputImage, size: size)
    }
    
    /// 将CIImage转换成UIImage
    class func wwz_image(ciimage: CIImage, size: CGSize) -> UIImage? {
        
        let integralRect = ciimage.extent.integral
        let scale : CGFloat = min(size.width / integralRect.width, size.height / integralRect.height)
        // 1.创建bitmap;
        let width = integralRect.width * scale
        let height = integralRect.height * scale
        
        // CGContext
        guard let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue).rawValue) else { return nil }
        
        let context = CIContext(options: nil)
        
        // CGImage
        guard let bitmapImage = context.createCGImage(ciimage, from: integralRect) else { return nil }
        
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: integralRect)
        
        // 2.保存bitmap到图片
        guard let scaledImage: CGImage = bitmapRef.makeImage() else { return nil }
        
        return UIImage(cgImage: scaledImage)
    }
    
    /// 从图片中获取url
    class func wwz_imageUrlString(image: UIImage?) -> String? {
        
        guard let cgImage = image?.cgImage else { return nil }
        
        guard let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else { return nil }
        
        // 取得识别结果
        let features = detector.features(in: CIImage(cgImage: cgImage))
        
        guard features.count > 0 else { return nil }
        
        guard let qrcodeFeature = features[0] as? CIQRCodeFeature else { return nil }
        
        return qrcodeFeature.messageString
    }
}


extension UIImage {

    /// 压缩图片
    func wwz_compressedImage(maxFileSize: Int) -> UIImage? {
    
        guard let imageData = self.wwz_compressedData(maxFlieSize: maxFileSize) else { return nil }
        
        return UIImage(data: imageData)
    }
    
    func wwz_compressedData(maxFlieSize: Int) -> Data? {
        
        var compression : CGFloat = 0.9
        let maxCompression : CGFloat = 0.01
        
        guard var imageData = UIImageJPEGRepresentation(self, 1.0) else{
        
            return nil
        }
        
        while (imageData.count > maxFlieSize && compression > maxCompression){
           
            compression -= maxCompression
            
            guard let data = UIImageJPEGRepresentation(self, compression) else { return nil }
            
            imageData = data
        }
        
        return imageData
    }
}
















