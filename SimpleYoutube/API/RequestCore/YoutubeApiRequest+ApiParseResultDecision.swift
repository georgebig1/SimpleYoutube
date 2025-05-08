//
//  YoutubeApiRequest+ApiParseResultDecision.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

struct YoutubeApiParseResultDecision: Decision {
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return true
    }

    func apply<Req: Request>(request: Req,
                             data: Data,
                             response: HTTPURLResponse,
                             done closure: @escaping (DecisionAction<Req>) -> Void) {
        do {
            let value = try decoder.decode(Req.Response.self, from: data)
            closure(.done(value))
        } catch {
            print("Req: \(String(describing: request.url)), error: \(error)")
            closure(.continueWith(data, response))
        }
    }
}

private let decoder = JSONDecoder()
