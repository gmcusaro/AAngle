import Testing
@testable import AAngle

@Test func testAngleType() throws {
    let radiansType: Degrees = AngleType.degrees.initAngle(180) as! Degrees
    let value: Revolutions = radiansType.convertTo(.revolutions) as! Revolutions
    print(value.rawValue)
    
    let angleInRadians = Radians(.pi / 4)  // 45° in radians
    let oppositeAngleInRadians = angleInRadians.opposite()
    print(Degrees(oppositeAngleInRadians))  // Should print 3π/4, i.e., 135° in radians
    
    
    var myRev = Revolutions()
    myRev += 0.5
    myRev += Degrees(180)
    print(myRev.rawValue)
}
