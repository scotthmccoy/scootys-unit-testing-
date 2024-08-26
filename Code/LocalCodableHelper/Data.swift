extension Data {
    public var prettyPrintedJSONString: String {
        guard
            let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
            let jsonData = try? JSONSerialization.data(
                withJSONObject: json,
                options: [.prettyPrinted, .withoutEscapingSlashes]
            ),
            let strPretty = String(data: jsonData, encoding: .utf8) else {
            return "Malformed JSON"
        }

        return strPretty
    }
}
