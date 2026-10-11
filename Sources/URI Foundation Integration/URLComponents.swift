public import Foundation
public import URI

extension URLComponents {

    public init(_ uri: URI) throws(URI.Foundation.Error) {
        guard let components = URLComponents(string: uri.value) else {
            throw .notRepresentableInFoundation(value: uri.value)
        }
        self = components
    }

    public init(roundTripping uri: URI) throws(URI.Foundation.Error) {
        let components = try URLComponents(uri)
        guard let roundTripped = components.string, roundTripped == uri.value else {
            throw .lossyRoundTrip(original: uri.value, roundTripped: components.string ?? "")
        }
        self = components
    }

    public func uri() throws(URI.Foundation.Error) -> URI {
        guard let value = string else {
            throw .notRepresentableAsURI(foundationValue: "")
        }
        do throws(RFC_3986.Error) {
            return try URI(value)
        } catch {
            throw .notRepresentableAsURI(foundationValue: value)
        }
    }
}
