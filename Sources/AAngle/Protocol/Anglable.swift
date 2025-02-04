import Foundation

// MARK:- AngleType Protocol
public protocol Anglable: Codable, Hashable, Equatable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    var rawValue: Double { get set }
    init(_ rawValue: Double)
    
    static var normalizationValue: Double { get }
    mutating func normalize()
    func normalized() -> Self
    func toMeasurement() -> Measurement<UnitAngle>
    func convertTo(_ type: AngleType) -> any Anglable
}

// Default implementations in the protocol extension
public extension Anglable {
    init(floatLiteral value: Double) {
        self.init(value)
    }

    init(integerLiteral value: Int) {
        self.init(Double(value))
    }

    init<T: BinaryInteger>(_ value: T) {
        self.init(Double(value))
    }

    init<T: BinaryFloatingPoint>(_ value: T) {
        self.init(Double(value))
    }
}

extension Anglable {
    public mutating func normalize(by value: Double) {
        guard rawValue.isFinite else { return }
        self.rawValue = rawValue.truncatingRemainder(dividingBy: value)
        if rawValue < 0.0 { rawValue += value }
    }
    
    public func normalized(by value: Double) -> Self {
        var angle = self
        angle.normalize(by: value)
        return angle
    }
    
    public mutating func normalize() {
        normalize(by: Self.normalizationValue)
    }
    
    public func normalized() -> Self {
        return normalized(by: Self.normalizationValue)
    }
    
    public static func + (lhs: Self, rhs: Self) -> Self {
        var result = Self(lhs.rawValue + rhs.rawValue)
        result.normalize()
        return result
    }
    public static func + (lhs: Self, rhs: Double) -> Self {
        var result = Self(lhs.rawValue + rhs)
        result.normalize()
        return result
    }
    public static func + (lhs: Self, rhs: Int) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    public static func + <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    public static func + <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue + Double(rhs))
        result.normalize()
        return result
    }
    
    public static func += (lhs: inout Self, rhs: Self) {
        lhs.rawValue += rhs.rawValue
        lhs.normalize()
    }
    public static func += (lhs: inout Self, rhs: Double) {
        lhs.rawValue += rhs
        lhs.normalize()
    }
    public static func += (lhs: inout Self, rhs: Int) {
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    public static func += <T: BinaryInteger>(lhs: inout Self, rhs: T){
        lhs.rawValue += Double(rhs)
        lhs.normalize()
    }
    public static func += <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        lhs.rawValue += lhs.rawValue + Double(rhs)
        lhs.normalize()
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        var result = Self(lhs.rawValue - rhs.rawValue)
        result.normalize()
        return result
    }
    public static func - (lhs: Self, rhs: Double) -> Self {
        var result = Self(lhs.rawValue - rhs)
        result.normalize()
        return result
    }
    public static func - (lhs: Self, rhs: Int) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    public static func - <T: BinaryInteger>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    public static func - <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self {
        var result = Self(lhs.rawValue - Double(rhs))
        result.normalize()
        return result
    }
    
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs.rawValue -= rhs.rawValue
        lhs.normalize()
    }
    public static func -= (lhs: inout Self, rhs: Double) {
        lhs.rawValue -= rhs
        lhs.normalize()
    }
    public static func -= (lhs: inout Self, rhs: Int) {
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    public static func -= <T: BinaryInteger>(lhs: inout Self, rhs: T){
        lhs.rawValue -= Double(rhs)
        lhs.normalize()
    }
    public static func -= <T: BinaryFloatingPoint>(lhs: inout Self, rhs: T) {
        lhs.rawValue -= lhs.rawValue + Double(rhs)
        lhs.normalize()
    }
 
    public static func * (lhs: Self, rhs: Self) -> Self { Self(lhs.rawValue * rhs.rawValue) }
    public static func * (lhs: Self, rhs: Double) -> Self { Self(lhs.rawValue * rhs) }
    public static func * (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue * Double(rhs)) }
    public static func * <T: BinaryInteger>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue * Double(rhs)) }
    public static func * <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue * Double(rhs)) }
    
    public static func / (lhs: Self, rhs: Self) -> Self { Self(lhs.rawValue / rhs.rawValue) }
    public static func / (lhs: Self, rhs: Double) -> Self { Self(lhs.rawValue / rhs) }
    public static func / (lhs: Self, rhs: Int) -> Self { Self(lhs.rawValue / Double(rhs)) }
    public static func / <T: BinaryInteger>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue / Double(rhs)) }
    public static func / <T: BinaryFloatingPoint>(lhs: Self, rhs: T) -> Self { Self(lhs.rawValue / Double(rhs)) }
    
    public prefix static func - (operand: Self) -> Self { Self(-operand.rawValue) }
    
    public static func ~= (lhs: Self, rhs: Self) -> Bool {
        let tolerance = 1e-15
        return abs(lhs.rawValue - rhs.rawValue) < tolerance
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.rawValue == rhs.rawValue }
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue}
    public static func <= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue <= rhs.rawValue }
    public static func > (lhs: Self, rhs: Self) -> Bool { lhs.rawValue > rhs.rawValue }
    public static func >= (lhs: Self, rhs: Self) -> Bool { lhs.rawValue >= rhs.rawValue }
}
