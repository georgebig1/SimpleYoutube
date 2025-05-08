//
//  YoutubeApiRequest+ApiErrorDecision.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

struct YoutubeResponseAPIError: Codable {
    let error: YoutubeResponseError
}

struct YoutubeResponseError: Codable, APIError {
    let code: Int
    let message: String
}

struct YoutubeApiErrorDecision: Decision {
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return true
    }

    func apply<Req: Request>(request: Req,
                             data: Data,
                             response: HTTPURLResponse,
                             done closure: @escaping (DecisionAction<Req>) -> Void) {
        do {
            let value = try decoder.decode(YoutubeResponseAPIError.self, from: data)
            let error = ResponseError.apiError(error: value.error, statusCode: response.statusCode)

            closure(.errored(error))
        } catch {
            closure(.errored(error))
        }
    }
}

private let decoder = JSONDecoder()
