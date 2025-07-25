import Testing
@testable import AAngle

let arrRev: [Revolutions] = [
    Revolutions(0.0),
    Revolutions(0.002777777778),
    Revolutions(0.25),
    Revolutions(0.5),
    Revolutions(0.75),
    Revolutions(1.0),
    Revolutions(1.111111111111)
]

@Suite("Revolutions tests")
struct RevolutionsTests {
    @Test func testConvertToRevolutions() throws {
        for(index, item) in arrDeg.enumerated() {
            let rev = Revolutions(item)
            #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrGrad.enumerated() {
            let rev = Revolutions(item)
            #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrRad.enumerated() {
            let rev = Revolutions(item)
            #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrArcMin.enumerated() {
            let rev = Revolutions(item)
            #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
        }
        for(index, item) in arrArcSec.enumerated() {
            let rev = Revolutions(item)
            #expect((rev.rawValue - arrRev[index].rawValue).magnitude < 0.000001)
        }
    }
    
    @Test func testNormalizeRevolutions() throws {
        #expect(Revolutions(1.5).normalized().rawValue == 0.50)
    }
    
    @Test func testRevolutionsOperator() throws {
        var rev: Revolutions = .zero
        rev += 0.25
        rev += Revolutions(0.25)
        #expect(rev - rev == Revolutions(0.0))
        #expect(rev + 0.25 == Revolutions(0.75))
        #expect(rev + Int(3) == Revolutions(0.5))
        #expect(rev + Float(1) == Revolutions(0.5))
        #expect(rev + UInt64(2) == Revolutions(0.5))
        #expect(rev + Degrees(90) == Revolutions(0.75))
        #expect(rev - 0.25 == Revolutions(0.25))
        #expect(rev - Int(1) == Revolutions(0.5))
        #expect(rev - Float(2.5) == Revolutions(0.0))
        #expect(rev - UInt64(2) == Revolutions(0.5))
        #expect(rev - Degrees(90) == Revolutions(0.25))
        rev -= 0.75
        #expect(rev == Revolutions(0.75))
        #expect(rev == Radians(4.7123889803847))
        #expect(rev == ArcMinutes(16200.0))
        #expect(rev * 2 == Revolutions(1.5))
        #expect(rev / 3 == Revolutions(0.25))
        #expect(rev / 3 == Revolutions(Degrees(90)))
        #expect(rev < Revolutions(0.751))
        #expect(rev > Radians(4.711))
        #expect(rev <= Revolutions(0.7500001))
        #expect(rev >= Degrees(270.0))
        #expect(rev >= Revolutions(0.2499999999999))
    }
    
    @Test func testRevolutionsNaN() {
        let nanRevolutions = Revolutions(.nan)
        let infRevolutions = Revolutions(.infinity)
        let negInfRevolutions = Revolutions(-.infinity)
        let value = Revolutions(5)
        
        #expect(nanRevolutions.normalized().rawValue.isNaN)
        #expect((nanRevolutions + value).rawValue.isNaN)
        #expect((value + nanRevolutions).rawValue.isNaN)
        #expect((nanRevolutions - value).rawValue.isNaN)
        #expect((value - nanRevolutions).rawValue.isNaN)
        #expect((nanRevolutions * value).rawValue.isNaN)
        #expect((value * nanRevolutions).rawValue.isNaN)
        #expect((nanRevolutions / value).rawValue.isNaN)
        #expect((value / nanRevolutions).rawValue.isNaN)
        #expect((-nanRevolutions).rawValue.isNaN)
        
        //In-Place
        var mutableNan = Revolutions(.nan)
        mutableNan += value
        #expect(mutableNan.rawValue.isNaN)
        
        mutableNan = Revolutions(.nan) //Reset
        mutableNan -= value
        #expect(mutableNan.rawValue.isNaN)
        
        #expect(infRevolutions.normalized().rawValue.isInfinite)
        #expect((infRevolutions / value).rawValue.isNaN)
        #expect((-infRevolutions).rawValue.isNaN)
        #expect((infRevolutions + value).rawValue.isNaN)
        
        #expect(infRevolutions.description == "+Inf")
        #expect(negInfRevolutions.description == "-Inf")
        #expect(nanRevolutions.description == "NaN")
        
        var rev1 = Revolutions(0.333333333333)
        let rev2 = Revolutions(0.333333)
        print("rev1: ",rev1.tolerance)
        print("rev2: ",rev2.tolerance)
        #expect(rev1 != rev2)
        
        rev1.tolerance = 1e-6
        print("rev1: ",rev1.tolerance)
        print("rev2: ",rev2.tolerance)
        #expect(rev1 == rev2)
    }
}
