import Testing
@testable import AAngle

let arrArcMin: [ArcMinutes] = [
    ArcMinutes(0.0),
    ArcMinutes(60.0),
    ArcMinutes(5400.0),
    ArcMinutes(10800.0),
    ArcMinutes(16200.0),
    ArcMinutes(21600.0),
    ArcMinutes(24000.0)
]

@Suite("ArcMinutes tests")
struct ArcMinutesTests {
    @Test func testArcMin() async throws {
        for(index, item) in arrDeg.enumerated() {
            let arcMin = ArcMinutes(item)
            #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrGrad.enumerated() {
            let arcMin = ArcMinutes(item)
            #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrRad.enumerated() {
            let arcMin = ArcMinutes(item)
            #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrRev.enumerated() {
            let arcMin = ArcMinutes(item)
            #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrArcSec.enumerated() {
            let arcMin = ArcMinutes(item)
            #expect((arcMin.rawValue - arrArcMin[index].rawValue).magnitude < 0.000001)
        }
    }
    
    @Test func testNormalizeArcMinutes() throws {
        #expect(ArcMinutes(5400_000).normalized() == ArcMinutes(0))
        #expect(ArcMinutes(432_000).normalized() == ArcMinutes(0))
        #expect(ArcMinutes(24000_0).normalized() == ArcMinutes(2400))
    }
    
    @Test func testArcMinutesOperator() throws {
        var arcMin: ArcMinutes = .zero
        arcMin += 5400.0
        #expect(arcMin + Int(1000) == ArcMinutes(6400.0))
        #expect(arcMin + Float(400) == ArcMinutes(5800.0))
        #expect(arcMin + Revolutions(0.5) == ArcMinutes(16200.0))
        #expect(arcMin - Int(1000) == ArcMinutes(4400.0))
        #expect(arcMin - Float(400) == ArcMinutes(5000.0))
        #expect(arcMin - Degrees(90.0) == ArcMinutes(0.0))
        arcMin -= 400.0
        #expect(arcMin == ArcMinutes(5000.0))
        arcMin += 400.0
        #expect(arcMin == ArcMinutes(5400.0))
        #expect(arcMin * 2 == ArcMinutes(10800.0))
        #expect(arcMin / 4 == ArcMinutes(1350.0))
        #expect(arcMin < Revolutions(0.251111))
        #expect(arcMin > Revolutions(0.249999))
        #expect(arcMin <= Revolutions(0.25))
        #expect(arcMin >= Revolutions(0.25))
        #expect(arcMin == Gradians(100.0))
        #expect(arcMin == Degrees(90.0))
    }
    
    @Test func testArcMinutesNaN() {
        let nanArcMinutes = ArcMinutes(.nan)
        let infArcMinutes = ArcMinutes(.infinity)
        let negInfArcMinutes = ArcMinutes(-.infinity)
        let value = ArcMinutes(5)

        #expect(nanArcMinutes.normalized().rawValue.isNaN)
        #expect((nanArcMinutes + value).rawValue.isNaN)
        #expect((value + nanArcMinutes).rawValue.isNaN)
        #expect((nanArcMinutes - value).rawValue.isNaN)
        #expect((value - nanArcMinutes).rawValue.isNaN)
        #expect((nanArcMinutes * value).rawValue.isNaN)
        #expect((value * nanArcMinutes).rawValue.isNaN)
        #expect((nanArcMinutes / value).rawValue.isNaN)
        #expect((value / nanArcMinutes).rawValue.isNaN)
        #expect((-nanArcMinutes).rawValue.isNaN)

        //In-Place
        var mutableNan = ArcMinutes(.nan)
        mutableNan += value
        #expect(mutableNan.rawValue.isNaN)

        mutableNan = ArcMinutes(.nan) //Reset
        mutableNan -= value
        #expect(mutableNan.rawValue.isNaN)

        #expect(infArcMinutes.normalized().rawValue.isInfinite)
        #expect((infArcMinutes / value).rawValue.isNaN)
        #expect((-infArcMinutes).rawValue.isNaN)
        #expect((infArcMinutes + value).rawValue.isNaN)
        
        #expect(infArcMinutes.description == "+Inf")
        #expect(negInfArcMinutes.description == "-Inf")
        #expect(nanArcMinutes.description == "NaN")
    }
}
