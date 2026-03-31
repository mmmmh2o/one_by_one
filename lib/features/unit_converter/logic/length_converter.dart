enum LengthUnit { meter, kilometer, centimeter, inch, foot }

class LengthConverter {
  static const Map<LengthUnit, double> _toMeter = {
    LengthUnit.meter: 1.0,
    LengthUnit.kilometer: 1000.0,
    LengthUnit.centimeter: 0.01,
    LengthUnit.inch: 0.0254,
    LengthUnit.foot: 0.3048,
  };

  double convert({
    required double value,
    required LengthUnit from,
    required LengthUnit to,
  }) {
    final meters = value * (_toMeter[from] ?? 1.0);
    return meters / (_toMeter[to] ?? 1.0);
  }
}
