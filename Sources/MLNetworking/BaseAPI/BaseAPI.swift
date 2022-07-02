//
//  MySessionManager.swift
//  PhotoApp
//
//  Created by Alaattin Bedir on 2.03.2019.
//  Copyright © 2019 Alaattin Bedir. All rights reserved.
//

import Foundation
import Alamofire

public struct ErrorMessage: Decodable {
    public var errorCode: Int?
    public var message: String?
    public var httpStatus: Int?

    public init(errorCode: Int? = nil, message: String? = nil, httpStatus: Int? = nil) {
        self.errorCode = errorCode
        self.message = message
        self.httpStatus = httpStatus
    }

    enum CodingKeys: String, CodingKey {
        case errorCode = "errorCode"
        case message = "message"
        case httpStatus = "httpStatus"
    }
}

public enum MimeType: String {
    case applicationJson = "application/json"
    case textHtml = "text/html"
    case applicationPdf = "application/pdf"
    case formUrlEncoded = "application/x-www-form-urlencoded; charset=utf-8"
    case imagePNG = "image/png"
    case empty = ""
    case base64ForHTML = "base64"
}

open class BaseAPI: SessionDelegate {
    public static let shared = BaseAPI()
    private var session: Session?
    private init() {
        super.init()
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 280

        session = Session(configuration: configuration,
                          delegate: self,
                          startRequestsImmediately: true)
    }
    
    public func request<S: Decodable, F: Decodable>(methotType: HTTPMethod,
                                                    baseURL: String,
                                                    endPoint: String,
                                                    params: ([String: Any])?,
                                                    contentType: String = MimeType.applicationJson.rawValue,
                                                    headerParams: ([String: String])? = nil,
                                                    succeed:@escaping (S) -> Void,
                                                    failed:@escaping (F) -> Void) {
        guard let session = session else { return }

        guard networkIsReachable() else {
            if let myError = ErrorMessage(errorCode: 1001, message: "Please check your internet connection.") as? F {
                failed(myError)
            }
            return
        }

        var url = baseURL + endPoint
        var bodyParams: ([String: Any])?
        if let params = params {
            if methotType == .get {
                url.append(URLQueryBuilder(params: params).build())
            } else {
                bodyParams = params
            }
        }

        let headerParams = prepareHeaderForSession(endPoint, methotType, bodyParams, headerParams, contentType)

        printRequest(url: url, methodType: methotType, body: bodyParams, headerParams: headerParams)

        let networkRequest = session.request(url,
                                             method: methotType,
                                             parameters: bodyParams,
                                             headers: HTTPHeaders(headerParams))
            .validate(contentType: [contentType])
            .validate(statusCode: 200 ..< 600)

        handleJsonResponse(dataRequest: networkRequest,
                           succeed: succeed,
                           failed: failed)
    }

    // MARK: Handle Default Json Response

    private func handleJsonResponse<S: Decodable, F: Decodable>(dataRequest: DataRequest,
                                                                succeed: @escaping (S) -> Void,
                                                                failed: @escaping (F) -> Void) {
        dataRequest.responseDecodable(of: S.self) { [weak self] response in
            guard let self = self else { return }

            self.printResponse(request: dataRequest, statusCode: response.response?.statusCode, url: response.request?.description)
            
            switch response.result {
            case .success:
                switch StatusCodeType.toStatusType(httpStatusCode: response.response?.statusCode) {
                case .successStatus:
                    self.handleSuccessfulResponseObject(dataRequest: dataRequest, succeed: succeed)
                case .errorStatus:
                    self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
                default:
                    print("default")
                }
            case .failure(_):
                self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
            }
        }
    }

    private func handleSuccessfulResponseObject<S: Decodable>(dataRequest: DataRequest,
                                                              succeed: @escaping (S) -> Void) {
        dataRequest.responseDecodable(of: S.self) { (response: DataResponse<S, AFError>) in
            if let responseObject = response.value {
                succeed(responseObject)
            }
        }
    }

    private func handleFailureResponseObject<F: Decodable>(dataRequest: DataRequest,
                                                           failed: @escaping (F) -> Void) {
        dataRequest.responseDecodable(of: F.self) { (response: DataResponse<F, AFError>) in
            if let responseObject = response.value {
                if var errorMessage = responseObject as? ErrorMessage {
                    errorMessage.httpStatus = response.response?.statusCode
                }
                failed(responseObject)
            }
        }
    }

    private func prepareHeaderForSession(_: String,
                                         _: HTTPMethod,
                                         _ bodyParams: ([String: Any])?,
                                         _ extraHeaderParams: ([String: String])?,
                                         _ contentType: String) -> [String: String] {
        var allHeaderFields: [String: String] = [:]

        allHeaderFields["Content-Type"] = contentType
        if let extraHeaderParams = extraHeaderParams, !extraHeaderParams.isEmpty {
            allHeaderFields.merge(extraHeaderParams) { _, new in new }
        }

        return allHeaderFields
    }

    // MARK: Reachability for connection

    private func networkIsReachable() -> Bool {
        let networkManager = NetworkReachabilityManager()
        let result = networkManager?.isReachable
        return result ?? false
    }

    private func printRequest(url: String?,
                              methodType: HTTPMethod?,
                              body: ([String: Any])?,
                              headerParams: [String: String]) {

        let header = headerParams.reduce("\n   ") { $0 + $1.key + ":" + $1.value + "\n      " }
        print("""
        --------------------------------------------------
        Request Url: \(url ?? "")
        Request Type: \(String(describing: methodType))
        Request Parameters: \(String(describing: body))
        Request Headers: \(header)
        """)
    }

    private func printResponse(request: DataRequest,
                               statusCode: Int?,
                               url: String?) {
        print("--------------------------------------------------")

        request.prettyPrintedJsonResponse()

        print("""
        --------------------------------------------------
        Response Url: \(String(describing: url))
        Response StatusCode: \(String(describing: statusCode))
        """)
    }
}
