enum BmiCategory { underweight, normal, overweight, obese }

class BmiResult {
  final double value;
  final BmiCategory category;

  const BmiResult({required this.value, required this.category});
}

class BmiCalculator {
  const BmiCalculator();

  BmiResult calculate({required double heightCm, required double weightKg}) {
    final safeHeight = heightCm <= 0 ? 1 : heightCm;
    final meter = safeHeight / 100;
    final bmi = weightKg / (meter * meter);
    return BmiResult(value: bmi, category: _categoryFor(bmi));
  }

  BmiCategory _categoryFor(double bmi) {
    if (bmi < 18.5) return BmiCategory.underweight;
    if (bmi < 24) return BmiCategory.normal;
    if (bmi < 28) return BmiCategory.overweight;
    return BmiCategory.obese;
  }
}
