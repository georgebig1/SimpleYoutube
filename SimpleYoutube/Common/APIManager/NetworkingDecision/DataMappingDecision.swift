//
//  DataMappingDecision.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

struct DataMappingDecision: Decision {
    private let condition: (Data) -> Bool
    private let transform: (Data) -> Data

    init(condition: @escaping (Data) -> Bool, transform: @escaping (Data) -> Data) {
        self.condition = condition
        self.transform = transform
    }

    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool {
        return condition(data)
    }

    func apply<Req: Request>(request: Req,
                             data: Data,
                             response: HTTPURLResponse,
                             done closure: @escaping (DecisionAction<Req>) -> Void) {
        closure(.continueWith(transform(data), response))
    }
}
