public import Foundation
public import URI

extension URL {

    public init(_ uri: URI) throws(URI.Foundation.Error) {
        guard let url = URL(string: uri.value) else {
            throw .notRepresentableInFoundation(value: uri.value)
        }
        self = url
    }

    public init(roundTripping uri: URI) throws(URI.Foundation.Error) {
        let url = try URL(uri)
        let roundTripped = url.absoluteString
        guard roundTripped == uri.value else {
            throw .lossyRoundTrip(original: uri.value, roundTripped: roundTripped)
        }
        self = url
    }

    public func uri() throws(URI.Foundation.Error) -> URI {
        do throws(RFC_3986.Error) {
            return try URI(absoluteString)
        } catch {
            throw .notRepresentableAsURI(foundationValue: absoluteString)
        }
    }
}
