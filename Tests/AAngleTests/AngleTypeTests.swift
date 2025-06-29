import Testing

@testable import AAngle

@Test func testAAngleType() throws {
    let degrees = Degrees(180)
    #expect(AAngleType.revolutions.initAngle(degrees) as! Revolutions == Revolutions(0.5))
    
    let radiansType: Degrees = AAngleType.degrees.initAngle(180) as! Degrees
    let value: Revolutions = radiansType.convert(to: .revolutions) as! Revolutions
    #expect(value.rawValue == 0.5)

    let angleInRadians = Radians(.pi / 4)
    let oppositeAngleInRadians = angleInRadians
    #expect(Degrees(oppositeAngleInRadians).rawValue == 45.0)

    var myRev = Revolutions()
    myRev += 0.5
    myRev += Degrees(180)
    #expect(myRev.rawValue == 0.0)
}
