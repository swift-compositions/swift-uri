import Foundation
import Testing
import URI

@testable import URI_Foundation_Integration

extension URI.Foundation {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension URI.Foundation.Test.Integration {
    @Test
    func `URL bridge round-trips a canonical HTTPS URI`() throws {
        let uri = try URI("https://example.com/path?query=value#fragment")
        let url = try URL(roundTripping: uri)
        #expect(url.absoluteString == uri.value)
        #expect(try url.uri().value == uri.value)
    }

    @Test
    func `URLComponents bridge round-trips a canonical HTTPS URI`() throws {
        let uri = try URI("https://example.com/path?query=value#fragment")
        let components = try URLComponents(roundTripping: uri)
        #expect(try components.uri().value == uri.value)
    }
}

extension URI.Foundation.Test.Unit {
    @Test
    func `relative reference bridges to URL without a scheme`() throws {
        let uri = try URI("/path/to/resource?x=1")
        let url = try URL(uri)
        #expect(url.scheme == nil)
    }

    @Test
    func `the typed error carries a human-readable description for every case`() {
        let errors: [URI.Foundation.Error] = [
            .notRepresentableInFoundation(value: "//[invalid"),
            .notRepresentableAsURI(foundationValue: "not a uri"),
            .lossyRoundTrip(original: "a", roundTripped: "b"),
        ]
        for error in errors {
            #expect(!error.description.isEmpty)
        }
    }
}

extension URI.Foundation.Test.`Edge Case` {

    @Test
    func `strict URL bridge reports any mismatch accepted by the non-strict bridge`() throws {
        let uri = try URI("https://example.com/a/../b")
        let foundationValue = try URL(uri).absoluteString

        do throws(URI.Foundation.Error) {
            let strict = try URL(roundTripping: uri)
            #expect(foundationValue == uri.value)
            #expect(strict.absoluteString == foundationValue)
        } catch {
            guard case .lossyRoundTrip(let original, let roundTripped) = error else {
                Issue.record("Expected .lossyRoundTrip, got \(error)")
                return
            }
            #expect(original == uri.value)
            #expect(roundTripped == foundationValue)
            #expect(roundTripped != original)
        }
    }

    @Test
    func `an empty URLComponents bridges to the empty relative-reference URI`() throws {
        let uri = try URLComponents().uri()
        #expect(uri.value.isEmpty)
    }
}
