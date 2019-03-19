public struct Undocumented {
    public struct Warning {
        public let file: String?
        public let line: Int?
        public let symbol: String?
        public let symbolKind: String?
        public let warning: String
    }

    public let warnings: [Warning]
    public let sourceDirectory: String
}

extension Undocumented: Codable {
    enum CodingKeys: String, CodingKey {
        case warnings = "warnings"
        case sourceDirectory = "source_directory"
    }
}

extension Undocumented.Warning: Codable {
    enum CodingKeys: String, CodingKey {
        case file = "file"
        case line = "line"
        case symbol = "symbol"
        case symbolKind = "symbol_kind"
        case warning = "warning"
    }
}
