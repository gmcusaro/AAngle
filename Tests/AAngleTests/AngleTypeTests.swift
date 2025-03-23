import Testing
@testable import AAngle

@Test func testAngleType() throws {
    let radiansType: Degrees = AngleType.degrees.initAngle(180) as! Degrees
    let value: Revolutions = radiansType.convertTo(.revolutions) as! Revolutions
    print(value.rawValue)
    
    let angleInRadians = Radians(.pi / 4)
    let oppositeAngleInRadians = angleInRadians
    print(Degrees(oppositeAngleInRadians))
    
    var myRev = Revolutions()
    myRev += 0.5
    myRev += Degrees(180)
    print(myRev.rawValue)
}
