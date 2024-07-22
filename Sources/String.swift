public extension String {
    var isNotEmptyOrWhitespace: Bool {
        return !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
