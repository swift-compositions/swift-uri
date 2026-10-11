import Testing
import URI

extension URI {
    @Suite struct Test {
        @Suite struct Integration {}
    }
}

extension URI.Test.Integration {

    @Test
    func `canonical(host:) reaches the L2 law through the re-export`() throws(URI.Canonicalization
        .Error)
    {
        let uri = URI(unchecked: "https://example.com/path")
        let result = try uri.canonical(host: "canonical.com")

        #expect(result == "https://canonical.com/path")
    }
}
