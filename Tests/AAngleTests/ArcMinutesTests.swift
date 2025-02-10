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

@Test func testAdd() throws {
    let arc = ArcMinutes(1.0)
    let increment: Int = 60
    let total = arc + increment
    #expect((total.rawValue - 61).magnitude < 0.000001)
}

@Test func testAddEqual() throws {
    let increment: Int = 60
    
    var arc = ArcMinutes(0.0)
    arc += increment
    #expect(arc == ArcMinutes(60))

    var arc2 = ArcMinutes(0.0)
    arc2 += Double(increment)
    let expectedValue = Double(increment)
    let accuracy: Double = 0.000001
    #expect(abs(arc2.rawValue - expectedValue) < accuracy)
}

@Test func testMinus() throws {
    let arc = ArcMinutes(1.0)
    let increment: Int = 60
    #expect((arc + increment == ArcMinutes(61)))
}

@Test func testMinusEqual() throws {
    var arc = ArcMinutes(0.0)
    let increment: Int = 60
    arc += increment
    #expect(arc.rawValue == Double(increment))
}

@Test func addTypes() throws {
    let deg = Degrees(90)
    let rev = Revolutions(0.25)
    let sum: Degrees = deg + rev
    #expect(sum == Degrees(180))
}
