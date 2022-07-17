import RationalModule

internal extension Rational {
    static func randomSample(count: Int) -> UnfoldSequence<Rational, Int> {
        sequence(state: 0) { currentCount in
            guard currentCount != count else { return nil }
            currentCount += 1
            return Rational(.random(in: -10_000...10_000), .random(in: 1...10_000))
        }
    }
    
    static func randomPairSample(count: Int) -> UnfoldSequence<(Rational, Rational), Int> {
        sequence(state: 0) { currentCount in
            guard currentCount != count else { return nil }
            currentCount += 1
            let first = Rational(.random(in: -10_000...10_000), .random(in: 1...10_000))
            let second = Rational(.random(in: -10_000...10_000), .random(in: 1...10_000))
            return (first, second)
        }
    }
}
