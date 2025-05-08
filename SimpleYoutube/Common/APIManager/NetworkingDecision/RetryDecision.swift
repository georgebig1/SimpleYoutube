//
//  RetryDecision.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

struct RetryDecision: Decision {
    let leftCount: Int

    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        let isStatusCodeValid = (200..<300).contains(response.statusCode)
        return isStatusCodeValid == false && leftCount > 0
    }

    func apply<Req: Request>(request: Req,
                             data: Data,
                             response: HTTPURLResponse,
                             done closure: @escaping (DecisionAction<Req>) -> Void) {
        let retryDecision = RetryDecision(leftCount: leftCount - 1)
        let newDecisions = request.decisions.replacing(self, with: retryDecision)
        closure(.restartWith(newDecisions))
    }
}
