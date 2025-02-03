import Foundation

extension Measurement where UnitType == UnitAngle {
    /// Initializes a `Measurement<UnitAngle>` from an `Anglable` instance.
    /// - Parameter anglable: An instance conforming to the `Anglable` protocol.
    public init(_ anglable: any Anglable) {
        let measurement = anglable.toMeasurement()
        self.init(value: measurement.value, unit: measurement.unit)
    }
}
