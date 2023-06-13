import Foundation

extension TimeInterval {
    static func minutes(_ minutes: Double) -> TimeInterval {
        TimeInterval(minutes * 60)
    }

    static func minutes(_ minutes: Int) -> TimeInterval {
        TimeInterval(Double(minutes) * 60)
    }

    static func hours(_ hours: Double) -> TimeInterval {
        TimeInterval(hours * 60 * 60)
    }

    static func hours(_ hours: Int) -> TimeInterval {
        TimeInterval(Double(hours) * 60 * 60)
    }

    static func days(_ days: Double) -> TimeInterval {
        TimeInterval(days * 60 * 60 * 24)
    }

    static func days(_ days: Int) -> TimeInterval {
        TimeInterval(Double(days) * 60 * 60 * 24)
    }

    static func weeks(_ weeks: Double) -> TimeInterval {
        TimeInterval(weeks * 7 * 24 * 60 * 60)
    }

    static func weeks(_ weeks: Int) -> TimeInterval {
        TimeInterval(Double(weeks) * 7 * 24 * 60 * 60)
    }
}
