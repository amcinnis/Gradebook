//
//  GradebookURLLoader.swift
//  GradebookExample
//
//  Created by John Bellardo on 2/13/17.
//  Copyright © 2017 John Bellardo. All rights reserved.
//

import Foundation

class GradebookURLLoader {
    enum RequestOptions: String {
        case method = "method"
        case contentType = "content type"
        case body = "body"
    }

    /* Stores the base URL for the gradebook server.  See the assignment specs for
     * the actual URL to use.
     */
    var baseUrlStr = "https://users.csc.calpoly.edu/~bellardo/cgi-bin/test/grades.json" {
        didSet {
            baseUrl = URL(string: baseUrlStr)
        }
    }
    
    private var baseUrl = URL(string: "https://users.csc.calpoly.edu/~bellardo/cgi-bin/test/grades.json")
    
    /* Logs in to the gradebook JSON server.  Must set the baseURL property before calling this method.
     *
     * Calls the closure when complete.  The parameter to the closeure indicates 
     * success or failure.
     */
    func login(username: String, password: String, compCallback: @escaping (_ success: Bool) -> Void) {
        self.username = username
        self.password = password
        
        authType = .none
        validateCredentials {
            [weak self] (result) in
            guard let this = self else { return }
            if result == .valid {
                compCallback(true)
                return
            }
            
            this.authType = .basic
            this.validateCredentials {
                (result) in
                if result == .valid {
                    compCallback(true)
                    return
                }
                
                this.authType = .cas
                this.validateCredentials {
                    (result) in
                    if result == .valid {
                        compCallback(true)
                        return
                    }
                    
                    compCallback(false)
                }
            }
        }
    }
    
    /* Performs a simple HTTP "GET" operaton to load JSON data.  The urlSuffix is
     * effectively appended to the baseURL to for the actual URL that is loaded.
     * err is an out parameter, set when a loading error has occurred.  Pass
     * nil into err if you aren't interested in receiving this NSError object.
     *
     * Returns an NSData object containing the loaded page data, or nil
     * if an error occurred during the load operation.
     */
    func load(path: String, compCb: @escaping (_ data: Data, _ status: Int, _ err: Error?) -> Void) {
        load(path: path, request: nil, compCb: compCb)
    }

    /*
     * A more fully-featured version of loadDataFromPath:error:.  The urlSuffix parameter,
     *  err parameter, and return value work exactly the same as loadDataFromPath:error:.
     *  The status out parameter contains the HTTP status code.  Set status to nil if you
     *  aren't interested in this piece of information.  The reqDict provides a generic
     *  mechanism for modifying the HTTP request.  All values in the dictionary must be strings.
     *  All keys are optional.  The supported keys are macros defined in this header file:
     *
     *     GradebookReqMethod -- Controls the HTTP method.  The default is "GET".
     *                           "PUT" and "POST" are also support methods.
     *
     *     GradebookReqContentType -- Used verbatim as the HTTP Content-Type request header.
     *                                Default is to not include a Content-Type header.
     *     GradebookReqBody -- The data uploaded with the HTTP request.  The default is
     *                         to upload no additional data.
     */
    func load(path: String, request: [String:String]?, compCb: @escaping (_ data: Data, _ status: Int, _ err: Error?) -> Void) {
        let req = urlRequest(path: path, request: request)
        lastURLRequest = req
        
        if let req = req {
            let session = URLSession.shared
            let download = session.dataTask(with: req) {
                [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
                guard let this = self else { return }
                
                var status: Int = 0
                
                if let resp = response as? HTTPURLResponse {
                    status = resp.statusCode
                }
                
                if let error = error as? NSError {
                    if error.domain == NSURLErrorDomain && error.code == -1012 {
                        status = 401
                    }
                }
                
                var dataOut = data
                if dataOut == nil {
                    dataOut = Data()
                }

                if this.authType == .cas, let respUrl = response?.url {
                    if let casData = this.extractCASForm(data: dataOut!) {
                        this.attemptCASLogin(casFormData: casData, baseURL: respUrl) {
                            (status: Int, data: Data?) in
                            
                            var dataOut = data
                            if dataOut == nil {
                                dataOut = Data()
                            }
                            compCb(dataOut!, status, nil)
                        }
                        return
                    }
                }
                
                compCb(dataOut!, status, error)
            }
            download.resume()
        }
    }
//    - (nullable NSData*) loadDataFromPath: (nonnull NSString*) urlSuffix
//    withRequestDict:(nullable NSDictionary*) reqDict
//    returningStatus: (nullable NSInteger*) status
//    error: (NSError * _Nullable * _Nullable) err;
    
    /*
     * Returns the URLRequest that will be loaded for a given path and request dictionary.
     *  This includes all applicable authentication headers, suitable for use in a UIWebView.
     */
    func urlRequest(path: String, request: [String:String]?) -> URLRequest? {
        guard let baseUrl = baseUrl else { return nil }
        guard let url = URL(string: path, relativeTo: baseUrl) else { return nil }

        var req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        
        if authType == .basic && url.scheme == "https" {
            let loginString = "\(username):\(password)"
            let enc = loginString.base64Encoded!
            req.addValue("Basic \(enc)", forHTTPHeaderField: "Authorization")
        }
        
        if let request = request {
            if let value = request[RequestOptions.method.rawValue] {
                req.httpMethod = value
            }
            if let value = request[RequestOptions.contentType.rawValue] {
                req.setValue(value, forHTTPHeaderField: "Content-Type")
            }
            
            if let value = request[RequestOptions.body.rawValue] {
                req.httpBody = value.data(using: .utf8)
            }
        }
        
        return req;
    }
    
    // Type of authorization we are using
    enum AuthType {
        case basic
        case none
        case cas
    }

    private var lastURLRequest: URLRequest?
    private var authType = AuthType.none
    // Saved user name
    private var username = ""
    // Saved password
    private var password = ""
    
    enum ValidationResult {
        case invalid
        case valid
        case redirect
    }
    // Checks to see if we can actually log into the server
    private func validateCredentials(cb: @escaping (_ result: ValidationResult) -> Void) {
        load(path: "auth.txt") {
            (data: Data, status: Int, error: Error?) in
            var result = ValidationResult.invalid
            
            if let dataStr = String(data: data, encoding: .utf8) {
                if dataStr == "access\n" && status == 200 {
                    result = .valid
                }
                else if status == 200 {
                    result = .redirect
                }
            }
            
            cb(result)
        }
    }
    
    private func getAttribute(named: String, fromString: String, range: NSRange) -> String?
    {
        let regStr = "\(named)=\"[^\"]*\""
        guard let regex = try? NSRegularExpression(pattern: regStr, options: .caseInsensitive) else { return nil }
        let matchRange = regex.rangeOfFirstMatch(in: fromString, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: range)
        
        guard matchRange.location != NSNotFound else { return nil }
        
        let lb = fromString.characters.index(fromString.characters.startIndex,
                                        offsetBy: matchRange.location + 2 + named.lengthOfBytes(using: .utf8))
        let ub = fromString.characters.index(lb, offsetBy: matchRange.length - named.lengthOfBytes(using: .utf8) - 3)
        
        let srange = Range<String.Index>(uncheckedBounds: (lower: lb, upper: ub))
        return fromString.substring(with: srange)
    }
    
    private func extractCASForm(data: Data) -> Data? {
        guard let beginCASData = "<!-- BEGIN CAS -->".data(using: .utf8) else { return nil }
        guard let beginCASRange = data.range(of: beginCASData, options: [], in: nil) else { return nil }
        guard let endCASData = "<!-- END CAS -->".data(using: .utf8) else { return nil }
        guard let endCASRange = data.range(of: endCASData, options: [], in: nil) else { return nil }

        let casFormRange = Range(uncheckedBounds: (lower: beginCASRange.upperBound, upper: endCASRange.lowerBound))
        
        return data.subdata(in: casFormRange)
    }
    
    private func parseInputLine(line: String, range: NSRange?) -> [String:String]? {
        guard let range = range else { return nil }
        var result: [String: String] = [:]
//        let lb = line.characters.index(line.characters.startIndex, offsetBy: range.location)
//        let ub = line.characters.index(lb, offsetBy: range.length)
//        print(line[lb..<ub])
        for attr in ["name", "type", "value"] {
            if let value = getAttribute(named: attr, fromString: line, range: range) {
                result[attr] = value
            }
        }
        
        return result
    }
    
    private func parseCASFormInputs(_ cas: String) -> [[ String : Any ]]? {
        var result : [[ String : Any ]] = []
        guard let regex = try? NSRegularExpression(pattern: "<input[\t \r\n][^>]*>", options: .caseInsensitive) else { return nil }

        regex.enumerateMatches(in: cas, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, cas.lengthOfBytes(using: .utf8))) {
            (match: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) in
            if let line = parseInputLine(line: cas, range: match?.range) {
                result.append(line)
            }
        }
            
        return result
    }
    
    private func parseCASForm(casForm: String) -> [String:Any]? {
        var result: [String: Any] = [:]
        guard let regex = try? NSRegularExpression(pattern: "<form[\t \r\n][^>]*>", options: .caseInsensitive) else { return nil }
        
        //print(casForm)
        let formRange = regex.rangeOfFirstMatch(in: casForm, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, casForm.lengthOfBytes(using: .utf8)))
        guard formRange.location != NSNotFound else { return nil }
        
        if let value = getAttribute(named: "action", fromString: casForm, range: formRange) {
            result["action"] = value
        }
        if let value = getAttribute(named: "method", fromString: casForm, range: formRange) {
            result["method"] = value
        }
        
        // Do more paring here!
        if let inputs = parseCASFormInputs(casForm) {
            result["inputs"] = inputs
        }
        
        return result
    }

    
    private func attemptCASLogin(casFormData: Data, baseURL: URL?, cb: @escaping (_ status: Int, _ data: Data?) -> Void) {
        guard let baseURL = baseURL else { return }
        guard let formStr = String(data: casFormData, encoding: .utf8) else { return }
        guard let casForm = parseCASForm(casForm: formStr) else { return }
        
        if casForm["method"] == nil || !(casForm["method"] is String) || (casForm["method"] as! String) != "post" || casForm["inputs"] == nil || !(casForm["inputs"] is [[String: String]] || casForm["action"] == nil || !(casForm["action"] is String)) {
            cb(401, nil)
            return
        }
        var postStr = ""
        var charSet = CharacterSet.alphanumerics
        charSet.insert("-")
        charSet.insert("_")
        let inputs = casForm["inputs"] as! [[String:String]]
        for input in inputs {
            guard let name = input["name"] else { continue }
            var value = input["value"]
            if name == "username" {
                value = username
            }
            if name == "password" {
                value = password
            }
            if value == nil {
                continue
            }
            
            if postStr != "" {
                postStr.append("&")
            }
            postStr.append("\(name.addingPercentEncoding(withAllowedCharacters: charSet)!)=\(value!.addingPercentEncoding(withAllowedCharacters: charSet)!)")
        }
        
        let action = casForm["action"] as! String
        
        guard let postUrl = URL(string: action, relativeTo:baseURL) else { cb(401, nil); return }
        
        var request = URLRequest(url: postUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postStr.data(using: .utf8)
        
        let session = URLSession.shared
        let download = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            var status: Int = 0
            
            if let resp = response as? HTTPURLResponse {
                status = resp.statusCode
            }
            
            if let error = error as? NSError {
                if error.domain == NSURLErrorDomain && error.code == -1012 {
                    status = 401
                }
            }

            cb(status, data)
        }
        
        download.resume()
    }
}

extension String {
    var base64Encoded: String? {
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
}
