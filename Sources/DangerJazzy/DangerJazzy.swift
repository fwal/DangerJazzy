import Foundation
import Danger

public enum Scope {
    case all
    case modified
}

public enum Severity {
    case fail
    case message
    case warn
}

public struct Jazzy {

    public static func check(path: String = "docs/", severity: Severity = .fail, scope: Scope = .modified, ignore: [String] = []) {
        check(using: Danger(), path, severity, scope, ignore)
    }

    public static func undocumentedSymbols(path: String = "docs/", scope: Scope, ignore: [String] = []) -> [Undocumented.Warning] {
        return undocumentedSymbols(using: Danger(), path, scope, ignore)
    }
    
}

internal extension Jazzy {

    static func check(using danger: DangerDSL, _ path: String, _ severity: Severity, _ scope: Scope = .all, _ ignore: [String]) {
        undocumentedSymbols(using: danger, path, scope, ignore).forEach {
            notify(danger, severity, "Undocumented symbol", warning: $0)
        }
    }

    static func undocumentedSymbols(using danger: DangerDSL, _ path: String, _ scope: Scope, _ ignore: [String]) -> [Undocumented.Warning] {
        guard let undocumented = try? load(path) else {
            danger.fail("Couldn't load undocumented info for Jazzy docs at \"\(path)\"")
            return []
        }

        let filesOfInterest = files(from: danger)

        return undocumented.warnings.filter { warning in
            guard
                let file = warning.file,
                !ignore.contains(where: { file.range(of: $0, options: .regularExpression) != nil }) else {
                return false
            }
            return scope == .all || filesOfInterest.contains(file)
        }
    }

    static func load(_ path: String) throws -> Undocumented {
        let url = URL(fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/\(path)/undocumented.json")
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Undocumented.self, from: data)
    }

    static func files(from danger: DangerDSL) -> [File] {
        return danger.git.createdFiles + danger.git.modifiedFiles
    }

    static func notify(_ danger: DangerDSL, _ severity: Severity, _ message: String, warning: Undocumented.Warning) {
        notify(danger, severity, message, file: warning.file, line: warning.line)
    }

    static func notify(_ danger: DangerDSL, _ severity: Severity, _ message: String, file: String? = nil, line: Int? = nil) {
        switch severity {
        case .fail:
            if let file = file, let line = line {
                danger.fail(message: message, file: file, line: line)
            } else {
                danger.fail(message)
            }
            return
        case .message:
            if let file = file, let line = line {
                danger.message(message: message, file: file, line: line)
            } else {
                danger.message(message)
            }
            return
        case .warn:
            if let file = file, let line = line {
                danger.warn(message: message, file: file, line: line)
            } else {
                danger.warn(message)
            }
            return
        }
    }
}
