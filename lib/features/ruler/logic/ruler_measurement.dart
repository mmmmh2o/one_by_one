class RulerMeasurement {
  final double valueInCm;

  const RulerMeasurement(this.valueInCm);

  double get valueInInch => valueInCm / _cmPerInch;

  static const double _cmPerInch = 2.54;
}
