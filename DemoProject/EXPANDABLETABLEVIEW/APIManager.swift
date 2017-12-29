

import Foundation
import SystemConfiguration //Reachability
import SwiftyJSON

let timeoutValue = 20.0
let AuthenticationToken = "authenticationToken"
let HeaderAuthenticationField = "authId"
typealias SuccessHandler = (_ result: Any?) -> ()
typealias FailureHandler = ( _ error: String?) ->()

public let USER_DEFAULTS = UserDefaults.standard

class APIManager {
    class var shared: APIManager {
        struct Static {
            static let instance = APIManager()
        }
        return Static.instance
    }
//MARK: Handlers
    func successBlock(result: Any?,successHandler: @escaping SuccessHandler) {
        //#1. Use mainqueue to perform UI changes. Data-operation also performed in mainqueue
        DispatchQueue.main.async {
            successHandler(result)
        }
        //#2. Uncomment it to perform data operations and then manage UI changes in mainqueue in corrosponding viewcontroller
        //  successHandler(result)
    }
    func failureBlock(errorMsg: String?,failureHandler: @escaping FailureHandler) {
      //  Customs.showAlert(msg: "There is no internet connection!")
        print(errorMsg!)
        DispatchQueue.main.async {
            failureHandler(errorMsg)
        }
    }
    
//MARK: GET
    func requestForGET(url: String,isTokenEmbeded: Bool, successHandler: @escaping SuccessHandler, failureHandler: @escaping FailureHandler) {
        var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutValue)
        
        if isTokenEmbeded {
            guard let authToken = USER_DEFAULTS.object(forKey: AuthenticationToken)as? String
                else {
                    self.failureBlock(errorMsg:"Token Not Found", failureHandler: failureHandler)
                    return
            }
            request.setValue(authToken, forHTTPHeaderField: HeaderAuthenticationField)
        }
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        callRequestedAPI(request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
    
//MARK: POST
    func requestForPOST(url: String,isTokenEmbeded: Bool,params: Any, successHandler: @escaping SuccessHandler, failureHandler: @escaping FailureHandler){
        var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutValue)
        do {
            let paramBody = try JSONSerialization.data(withJSONObject: params, options: [])
            if isTokenEmbeded {
                guard let authToken = USER_DEFAULTS.object(forKey: AuthenticationToken)as? String
                    else {
                        self.failureBlock(errorMsg:"Token Not Found", failureHandler: failureHandler)
                        return
                }
                request.setValue(authToken, forHTTPHeaderField: HeaderAuthenticationField)
            }
            request.httpBody = paramBody
        } catch let errorSerialize {
                print("JSONSerialization ERROR: \(errorSerialize.localizedDescription)")
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        callRequestedAPI(request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
    
//MARK: PUT
    func requestForPUT(url: String,isTokenEmbeded: Bool,params: NSMutableDictionary,successHandler: @escaping SuccessHandler,failureHandler: @escaping FailureHandler) {
        var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutValue)
        do {
            let paramBody = try JSONSerialization.data(withJSONObject: params, options: [])
            if isTokenEmbeded {
                guard let authToken = USER_DEFAULTS.object(forKey: AuthenticationToken)as? String
                    else {
                        self.failureBlock(errorMsg:"Token Not Found", failureHandler: failureHandler)
                        return
                }
                request.setValue(authToken, forHTTPHeaderField: HeaderAuthenticationField)
            }
            request.httpBody = paramBody
            let  bodyLength = String(data: paramBody, encoding: String.Encoding.utf8)?.characters.count
            request.setValue("\(bodyLength)", forHTTPHeaderField: "Content-Length")
            //request.setValue("\((paramBody as NSData).length)", forHTTPHeaderField: "Content-Length")
        } catch let errorSerialize {
            print("JSONSerialization ERROR: \(errorSerialize.localizedDescription)")
        }
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        callRequestedAPI(request: request, successHandler: successHandler, failureHandler: failureHandler)
    }
 
//MARK: DELETE
    func requestForDELETE(url: String,isTokenEmbeded: Bool,params: NSMutableDictionary,successHandler: @escaping SuccessHandler,failureHandler: @escaping FailureHandler) {
        var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutValue)
        do {
            let paramBody = try JSONSerialization.data(withJSONObject: params, options: [])
            if isTokenEmbeded {
                guard let authToken = USER_DEFAULTS.object(forKey: AuthenticationToken)as? String
                    else {
                        self.failureBlock(errorMsg:"Token Not Found", failureHandler: failureHandler)
                        return
                }
                request.setValue(authToken, forHTTPHeaderField: HeaderAuthenticationField)
            }
            request.httpBody = paramBody
            let  bodyLength = String(data: paramBody, encoding: String.Encoding.utf8)?.characters.count
            request.setValue("\(bodyLength)", forHTTPHeaderField: "Content-Length")
            //request.setValue("\((paramBody as NSData).length)", forHTTPHeaderField: "Content-Length")
        } catch let errorSerialize {
            print("JSONSerialization ERROR: \(errorSerialize.localizedDescription)")
        }
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        callRequestedAPI(request: request, successHandler: successHandler, failureHandler: failureHandler)
    }

//MARK: Upload Image
    func requestForImageUpload(url: String,isTokenEmbeded: Bool,imageData: Data?,successHandler: @escaping SuccessHandler,failureHandler: @escaping FailureHandler) {
        var request: URLRequest = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutValue)
        if isTokenEmbeded {
            guard let authToken = USER_DEFAULTS.object(forKey: AuthenticationToken)as? String
                else {
                    self.failureBlock(errorMsg:"Token Not Found", failureHandler: failureHandler)
                    return
            }
            request.setValue(authToken, forHTTPHeaderField: HeaderAuthenticationField)
        }
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        guard imageData != nil else {
            self.failureBlock(errorMsg:"Inavalid Image", failureHandler: failureHandler)
            return
        }
        let fname = "test.png"
        let mimetype = "image/png"
        let body = NSMutableData()
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
    }

//MARK: Request API
    func callRequestedAPI(request:URLRequest, successHandler: @escaping SuccessHandler, failureHandler: @escaping FailureHandler)
    {
        if Reachability.isConnectedToNetwork() {
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?,response: URLResponse?,error: Error?) in
                if(error == nil) {
                    if (data != nil)
                    {
                        if let httpResponse = response as? HTTPURLResponse
                        {
                            if(httpResponse.statusCode == 200){
                                var jsonObject: Any?
                                do {
                                    let newStr = String(data: data!, encoding: .utf8)
                                    print(newStr)
                                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
                                } catch let errorSerialize {
                                    print("JSONSerialization ERROR: \(errorSerialize.localizedDescription)")
                                }
                                //Response Here
                                self.successBlock(result: jsonObject, successHandler: successHandler)
                            }else {
                                self.failureBlock(errorMsg:"HANDLED STATUS CODE? \(httpResponse.statusCode)", failureHandler: failureHandler)
                            }
                        }else {
                            self.failureBlock(errorMsg:"ERROR in HTTPURLResponse:", failureHandler: failureHandler)
                        }
                    }else {
                        self.failureBlock(errorMsg:"ERROR:\(error?.localizedDescription)", failureHandler: failureHandler)
                    }
                }
                else
                {
                    self.failureBlock(errorMsg:"ERROR Could not connect with server:", failureHandler: failureHandler)
                }
            })
            task.resume()
        } else {
            
            self.failureBlock(errorMsg:"ERROR Internet not available:", failureHandler: failureHandler)
        }
    }
}

