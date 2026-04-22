import Testing
@testable import SoundVault

@Suite("TimeFormatter")
struct TimeFormatterTests {

    @Test func formatsZeroSeconds() {
        #expect(TimeFormatter.format(seconds: 0) == "0:00")
    }

    @Test func formatsSecondsOnly() {
        #expect(TimeFormatter.format(seconds: 45) == "0:45")
    }

    @Test func formatsOneMinuteExact() {
        #expect(TimeFormatter.format(seconds: 60) == "1:00")
    }

    @Test func formatsMinutesAndSeconds() {
        #expect(TimeFormatter.format(seconds: 90) == "1:30")
    }

    @Test func paddsSingleDigitSeconds() {
        #expect(TimeFormatter.format(seconds: 61) == "1:01")
    }

    @Test func formatsLargeDuration() {
        #expect(TimeFormatter.format(seconds: 3723) == "62:03")
    }
}
