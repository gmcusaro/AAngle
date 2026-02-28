import Testing
@testable import AAngle

let arrDeg: [Degrees] = [
    Degrees(0.0),
    Degrees(1.0),
    Degrees(90.0),
    Degrees(180.0),
    Degrees(270.0),
    Degrees(360.0),
    Degrees(400)
]

@Suite("Degrees tests")
struct DegreesTests {
    @Test func testDeg() throws {
        for(index, item) in arrGrad.enumerated() {
            let deg = Degrees(item)
            #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrRad.enumerated() {
            let deg = Degrees(item)
            #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrRev.enumerated() {
            let deg = Degrees(item)
            #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrArcMin.enumerated() {
            let deg = Degrees(item)
            #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrArcSec.enumerated() {
            let deg = Degrees(item)
            #expect((deg.rawValue - arrDeg[index].rawValue).magnitude < 0.000001)
        }
    }
    
    @Test func testNormalizeDegrees() throws {
        #expect(Degrees(450).normalized() == Degrees(90))
        #expect(Degrees(-380).normalized() == Degrees(340))
        #expect(Degrees(1500).normalized() == Degrees(60))
    }
    
    @Test func testDegreesOperator() async throws {
        var deg: Degrees = .zero
        deg += Degrees(180.0)
        #expect(deg + Int(20) == Degrees(200.0))
        #expect(deg + UInt8(10) == Degrees(190.0))
        #expect(deg + Float(20) == Degrees(200.0))
        #expect(deg + Revolutions(0.25) == Degrees(270.0))
        #expect(deg - Float(20) == Degrees(160.0))
        #expect(deg - Gradians(100) == Degrees(90.0))
        deg -= 100
        #expect(deg == Degrees(80))
        deg += 100
        #expect(deg == Degrees(180.0))
        #expect(deg * 2 == Degrees(360.0))
        #expect(deg / 3 == Degrees(60.0))
        #expect(deg < Revolutions(0.7))
        #expect(deg > ArcSeconds(324000.0))
        #expect(deg <= Gradians(Gradians(200.0)))
        #expect(deg <= Revolutions(0.5))
        #expect(deg >= Gradians(200.0))
        #expect(deg >= Degrees(180.0))
        #expect(deg == Degrees(180.0))
        #expect(deg == 180.0)
        #expect(deg == Radians(3.1415926535898))
        #expect(Degrees(510).normalized().rawValue == 150)
        #expect(Degrees(45.0).opposite == Degrees(135.0))
        #expect(Degrees(90.0).opposite == Degrees(90.0))
        #expect(Degrees(180.0).opposite == Degrees(0.0))
        #expect(Degrees(90.0).adjacentAngles() == [Degrees(180.0),Degrees(0.0)])
        #expect(Degrees(180.0).adjacentAngles() == [Degrees(270.0),Degrees(90.0)])
        #expect(Degrees(360.0).adjacentAngles() == [Degrees(90.0),Degrees(270.0)])
        #expect(Degrees(270.0).adjacentAngles() == [Degrees(0.0),Degrees(180.0)])
        #expect(Degrees(ArcSeconds(-1439999.9999999999999)) == Degrees(-400.0))
        #expect(Degrees(ArcSeconds(-1439999.9999999999999).normalized()) == Degrees(320.0))
    }
    
    @Test func testDegreesNaN() {
        let nanDegrees = Degrees(.nan)
        let infDegrees = Degrees(.infinity)
        let negInfDegrees = Degrees(-.infinity)
        let value = Degrees(5)

        #expect(nanDegrees.normalized().rawValue.isNaN, "Normalized NaN should be NaN")
        #expect((nanDegrees + value).rawValue.isNaN, "NaN + finite should be NaN")
        #expect((value + nanDegrees).rawValue.isNaN, "finite + NaN should be NaN")
        #expect((nanDegrees - value).rawValue.isNaN, "NaN - finite should be NaN")
        #expect((value - nanDegrees).rawValue.isNaN, "finite - NaN should be NaN")
        #expect((nanDegrees * value).rawValue.isNaN, "NaN * finite should be NaN")
        #expect((value * nanDegrees).rawValue.isNaN, "finite * NaN should be NaN")
        #expect((nanDegrees / value).rawValue.isNaN, "NaN / finite should be NaN")
        #expect((value / nanDegrees).rawValue.isNaN, "finite / NaN should be NaN")
        #expect((-nanDegrees).rawValue.isNaN, "Negation of NaN should be NaN")
        #expect((nanDegrees + .nan).rawValue.isNaN)
        #expect((nanDegrees - .nan).rawValue.isNaN)
        #expect((nanDegrees * .nan).rawValue.isNaN)
        #expect((nanDegrees / .nan).rawValue.isNaN)

        //In-Place
        var mutableNan = Degrees(.nan)
        mutableNan += value
        #expect(mutableNan.rawValue.isNaN, "In-place addition with NaN")

        mutableNan = Degrees(.nan) //Reset
        mutableNan -= value
        #expect(mutableNan.rawValue.isNaN, "In-place subtraction with NaN")

        #expect(infDegrees.normalized().rawValue.isInfinite)
        #expect((infDegrees / value).rawValue.isNaN)
        #expect((-infDegrees).rawValue.isNaN)
        #expect((infDegrees + value).rawValue.isNaN)
        
        #expect(infDegrees.description == "+Inf")
        #expect(negInfDegrees.description == "-Inf")
        #expect(nanDegrees.description == "NaN")
        
        var deg1 = Degrees(89.999999999999)
        let deg2 = Degrees(89.99999)
        #expect(deg1 != deg2)
        deg1.tolerance = 1e-5
        #expect(deg1 == deg2)
    }

    @Test func testRegressionAndNumericSymmetry() {
        var deg = Degrees(180)
        deg -= Float(45)
        #expect(deg == Degrees(135))

        #expect((20 + deg) == Degrees(155))
        #expect((400 - deg) == Degrees(265))

        #expect((deg / 0.0).rawValue.isNaN)
        #expect((deg / 0).rawValue.isNaN)
    }

    @Test func testCircularEquivalenceAndToleranceSanitization() {
        #expect(Degrees(0).isEquivalent(to: Degrees(360)))
        #expect(Degrees(0).isEquivalent(to: Revolutions(1)))

        var a = Degrees(10.0)
        var b = Degrees(10.0 + 5e-13)
        a.tolerance = -.infinity
        b.tolerance = .nan
        #expect(a == b)
    }
}
