//
//  Encodable.swift
//  Pods
//
//  Created by Scott McCoy on 12/15/24.
//

public extension Encodable {
    var swiftInitStatementResult: Result<String, Error> {
        Result {
            try SwiftInitEncoder().encode(self)
        }
    }

    var swiftInitStatement: String? {
        guard case let .success(ret) = self.swiftInitStatementResult else {
            return nil
        }
        return ret
    }

}
