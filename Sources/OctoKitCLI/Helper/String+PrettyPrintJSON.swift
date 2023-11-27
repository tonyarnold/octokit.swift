import Foundation

extension String {
    var prettyPrintedJSONString: String? {
        guard
            let dataValue = data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: dataValue),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]),
            let prettyPrintedString = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return prettyPrintedString
    }
}

func prettyPrinted<T: Encodable>(_ entity: T) throws -> String? {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]

    let data = try encoder.encode(entity)
    return String(data: data, encoding: .utf8)
}
