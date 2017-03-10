//
//  WWZTCPSocketClient.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

private let CONNECT_TIME_OUT : TimeInterval = 5
private let READ_TIME_OUT : TimeInterval = -1
private let WRITE_TIME_OUT : TimeInterval = -1
private let WRITE_TAG : Int = 1
private let READ_TAG : Int = 0

public protocol WWZTCPSocketClientDelegate {
    
    /// 连接成功回调
    func socket(_ socket: WWZTCPSocketClient, didConnectToHost host: String, port: UInt16)
    
    /// 收到数据回调
    func socket(_ socket: WWZTCPSocketClient, didRead result: Any)
    
    /// 断开连接回调
    func socket(_ sock: WWZTCPSocketClient, didDisconnectWithError err: Error?)
}

open class WWZTCPSocketClient: NSObject {

    // MARK: -属性
    public var delegate : WWZTCPSocketClientDelegate?
    
    // 读取结束符
    public var endKeyString : String? {
    
        didSet {
            
            self.endKeyData = endKeyString?.data(using: .utf8)
        }
    }
    // 读取结束符
    public var endKeyData : Data?
    
    // MARK: -懒加载属性
    fileprivate lazy var socket : GCDAsyncSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue(label: "WWZTCPSocketClient"))

    // MARK: -公有方法
    /// 连接到服务器
    public func connect(host: String, onPort: UInt16) {
        
        self.disconnect()
        
        guard let host = self.p_convertedHost(host: host) else {
            print("host converted fail")
            return
        }
        
        if (try? self.socket.connect(toHost: host, onPort: onPort, withTimeout: CONNECT_TIME_OUT)) == nil {
            
            print("connect fail")
        }
    }
    /// 断开连接
    public func disconnect() {
        
        if self.socket.isConnected {
            
            print("disconnect socket")
            
            self.socket.disconnect()
        }
    }
    
    /// 发送请求
    public func sendToServer(string: String?) {
        
        guard var message = string else {
            return
        }
        guard message.characters.count != 0 else {
            return
        }
        
        message = (message as NSString).replacingOccurrences(of: "'", with: "")
        
        self.sendToServer(data: message.data(using: .utf8))
    }
    /// 发送请求
    public func sendToServer(data: Data?) {

        guard let data = data else {
            return
        }
        guard data.count != 0 else {
            return
        }
        
        self.socket.write(data, withTimeout: WRITE_TIME_OUT, tag: WRITE_TAG)
    }
}
// MARK: -delegate
extension WWZTCPSocketClient : GCDAsyncSocketDelegate {
    
    /// 连接成功
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("+++connect to server success")
        
        DispatchQueue.main.async {
            
            guard let delegate = self.delegate else {
                
                return
            }
            delegate.socket(self, didConnectToHost: host, port: port)
        }
        // 连接成功开始读数据
        self.p_continueToRead()
    }
    /// 写成功
    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        
        // 写成功后开始读数据
        self.p_continueToRead()
    }
    /// 收到数据
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        
        self.p_handleReadData(data: data)
    }
    /// 断开连接
    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        
        print("+++socket disconnect+++");
        
        DispatchQueue.main.async {
            
            guard let delegate = self.delegate else {
                
                return
            }
            delegate.socket(self, didDisconnectWithError: err)
        }
    }

}
// MARK: -私有方法
extension WWZTCPSocketClient {

    // MARK: -私有方法
    /// 处理收到的数据
    fileprivate func p_handleReadData(data: Data) {
        
        guard data.count != 0 else {
            
            self.p_continueToRead()
            
            return
        }
        var readData = data
        
        // 去掉结束符
        if let endKeyData = self.endKeyData {
            
            if data.count <= endKeyData.count {
                self.p_continueToRead()
                
                return
            }
            
            readData = (readData as NSData).subdata(with: NSRange(location: 0, length: data.count-endKeyData.count))
        }
        
        // Data转String失败
        guard let resultString = String(data: readData, encoding: .utf8) else {
            
            if let delegate = self.delegate {
                
                DispatchQueue.main.async {
                    
                    delegate.socket(self, didRead: readData)
                }
            }
            
            self.p_continueToRead()
            
            return
        }
        // json解析失败
        guard let result = try? JSONSerialization.jsonObject(with: readData, options: .mutableContainers) else {
        
            if let delegate = self.delegate {
                
                DispatchQueue.main.async {
                    
                    delegate.socket(self, didRead: resultString)
                }
            }
            self.p_continueToRead()
            
            return;
        }
        
        if let delegate = self.delegate {
            
            DispatchQueue.main.async {
                
                delegate.socket(self, didRead: result)
            }
        }
        
        // 读完当前数据后继续读数
        self.p_continueToRead()
    }
    /// 读数据
    fileprivate func p_continueToRead() {
        
        if let endKeyData = self.endKeyData {
            
            self.socket.readData(to: endKeyData, withTimeout: READ_TIME_OUT, tag: READ_TAG)
        }else{
            
            self.socket.readData(withTimeout: READ_TIME_OUT, tag: READ_TAG)
        }
    }
    
    // MARK: -help
    /// ip转ipv4/6
    fileprivate func p_convertedHost(host: String) -> String?{
        
        let hosts = try? GCDAsyncSocket.lookupHost(host, port: 0)
        
        guard let addresses = hosts else {
            return nil;
        }
        
        var address4 : Data?
        var address6 : Data?
        
        for item in addresses {
            
            guard let address = item as? Data else {
                continue
            }
            
            if address4 == nil && GCDAsyncSocket.isIPv4Address(address) {
                
                address4 = address
            }else if address6 == nil && GCDAsyncSocket.isIPv6Address(address)  {
                address6 = address
            }
        }
        
        return address6 != nil ? GCDAsyncSocket.host(fromAddress: address6!) : GCDAsyncSocket.host(fromAddress: address4!)
    }
}


open class WWZTCPSocketRequest: NSObject {
    
    public let NOTI_PREFIX = "wwz"
    
    // 请求超时时间
    public var requestTimeout : TimeInterval = 10.0
    
    fileprivate var APP_PARAM = "wwz"
    fileprivate var CO_PARAM = "wwz"
    
    private var tcpSocket : WWZTCPSocketClient?
    
    fileprivate var mApiDict = [String: [String]]()
    
    fileprivate var mSuccessBlockDict = [String: (Any)->()]()
    fileprivate var mFailureBlockDict = [String: (Error)->()]()
    
    // 单例
    public static let shareInstance : WWZTCPSocketRequest = WWZTCPSocketRequest()
    
    public func setSocket(socket: WWZTCPSocketClient, app_param: String?, co_param: String?) {
        
        self.tcpSocket = socket
        self.APP_PARAM = app_param ?? "wwz"
        self.CO_PARAM = co_param ?? "wwz"
    }
    
    // socket请求
    public func request(api: String, parameters: Any, success: ((_ result: Any)->())?, failure: ((_ error: Error)->())?){
        
        guard let socket = self.tcpSocket else { return }
        
        self.request(socket: socket, api: api, parameters: parameters, success: success, failure: failure)
    }
    
    public func request(socket: WWZTCPSocketClient, api: String, parameters: Any, success: ((_ result: Any)->())?, failure: ((_ error: Error)->())?){
    
        guard let message = self.p_formatCmd(api: api, parameters: parameters) else { return }
        
        self.request(socket: socket, api: api, message: message, success: success, failure: failure)
    }
    public func request(api: String, message: String, success: ((_ result: Any)->())?, failure: ((_ error: Error)->())?){
    
        guard let socket = self.tcpSocket else { return }
        
        self.request(socket: socket, api: api, message: message, success: success, failure: failure)
    }
    public func request(socket: WWZTCPSocketClient, api: String, message: String, success: ((_ result: Any)->())?, failure: ((_ error: Error)->())?){
   
        guard let data = (message as NSString).replacingOccurrences(of: "'", with: "").data(using: .utf8) else { return }
        
        self.request(socket: socket, api: api, data: data, success: success, failure: failure)
    }
    public func request(socket: WWZTCPSocketClient, api: String, data: Data, success: ((_ result: Any)->())?, failure: ((_ error: Error)->())?){
    
        let noti_name = NOTI_PREFIX + "_" + api
        if success != nil {
            self.mSuccessBlockDict[noti_name] = success
        }
        if failure != nil {
            self.mFailureBlockDict[noti_name] = failure
        }
        
        if success != nil || failure != nil {
        
            self.p_insertApi(key: noti_name)
            
            // 添加通知
            NotificationCenter.default.addObserver(self, selector: #selector(WWZTCPSocketRequest.p_getResultNoti), name: NSNotification.Name(noti_name), object: nil)
        }
        // 发送请求
        socket.sendToServer(data: data)
        
        // 超时处理
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() +  self.requestTimeout) {
            
            if self.mFailureBlockDict[noti_name] == nil { return }
            
            let noti = Notification(name: Notification.Name(noti_name), object: nil, userInfo: ["-1" : "request time out"])
            
            self.p_getResultNoti(noti: noti)
        }
    }
}

extension WWZTCPSocketRequest {

    // 私有方法
    // 通知
    @objc fileprivate func p_getResultNoti(noti: Notification) {
        
        let noti_name = noti.name.rawValue
        
        self.p_removeApi(key: noti_name)
        
        // 移除通知
        NotificationCenter.default.removeObserver(self, name: noti.name, object: nil)
        
        guard let userInfo = noti.userInfo, noti.userInfo!.count > 0 else { return }
        
        guard let key = userInfo.first?.key else { return }
        
        guard let retcode = key as? Int else { return }
        
        if retcode == 0 || retcode == 100 {
            
            if let success = self.mSuccessBlockDict[noti_name] {
                
                success(noti.object)
            }
            
        }else{
            
            if let failure = self.mFailureBlockDict[noti_name] {
                
                failure(NSError(domain: NSCocoaErrorDomain, code: retcode, userInfo: ["error": userInfo.first?.value]))
            }
        }
        
        // 执行完移除回调
        self.mSuccessBlockDict.removeValue(forKey: noti_name)
        self.mFailureBlockDict.removeValue(forKey: noti_name)
    }
    
    
    
    fileprivate func p_insertApi(key: String) {
        
        guard var mArray = self.mApiDict[key] else {
            
            self.mApiDict[key] = [String]()
            return
        }
        
        mArray.append(key)
    }
    
    fileprivate func p_removeApi(key: String) {
        
        guard var mArray = self.mApiDict[key] else {
            
            return
        }
        
        if mArray.count <= 1 {
            self.mApiDict.removeValue(forKey: key)
        }else{
            
            mArray.remove(at: 0)
        }
    }
    
    fileprivate func p_formatCmd(api: String, parameters: Any) -> String?{
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return nil}
        
        guard let param = String(data: jsonData, encoding: .utf8) else { return nil}
        return String(format: "{\"app\":\"%@\",\"co\":\"%@\",\"api\":\"%@\",\"data\":%@}\n", self.APP_PARAM, self.CO_PARAM, api, param)
    }

    
}


