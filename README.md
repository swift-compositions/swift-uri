# swift-uri

Use this package when you work with URIs as checked values and need to hand them to Foundation or take them back from it. Start from `URI`. The `URI Foundation Integration` product converts between `URI` and Foundation's `URL` and `URLComponents`. If you never touch Foundation, swift-uri-standard alone gives you the same `URI`.

## Laws

- Foundation may rewrite a URI as it reads it. `URL.init(_:)` and `URLComponents.init(_:)` accept the rewritten form. `URL.init(roundTripping:)` and `URLComponents.init(roundTripping:)` throw `URI.Foundation.Error.lossyRoundTrip` unless Foundation's string is byte for byte the original.
- Going back with `URL.uri()` or `URLComponents.uri()` parses Foundation's string as RFC 3986. It throws if that string isn't a valid URI.
- A relative reference converts to a `URL` with no scheme. An empty `URLComponents` becomes the empty relative reference.
