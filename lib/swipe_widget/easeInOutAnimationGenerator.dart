class EaseInOutAnimationGenerator {
  late final double _targetValue;//イージングで変化する値（座標や角度）の目標
  late final double _totalAnimationDurationSec;
  late final double _secondsPerCut;
  late final int _totalAnimationCuts; 
  //_totalAnimationCuts(アニメーションのCut数)の値が高いほど、アニメーションが滑らかになる。
  //ただし、_totalAnimationDurationの値が多い（アニメーション時間が長い）と、
  //SPC(_secondsPerCut : 1Cut当たりの必要秒)が長くなってかくかくになる。

  double _easeValueBuffer = 0.0;

  EaseInOutAnimationGenerator(this._targetValue,
      [this._totalAnimationDurationSec = 1, this._totalAnimationCuts = 32]) {
    _secondsPerCut = _totalAnimationDurationSec / _totalAnimationCuts;
  }

  Stream<double> doEaseInOutStream(double currentValueArg) async* {
    int milisecondsPerCut =  (_secondsPerCut * 1000).toInt();
    //×1000なのに計算先の変数名がmilisecondsなのは、Durationクラスのmilisecondsプロパティがint型だから

    for (final double culculatedValue in _generateEaseInOut(currentValueArg)) {
      await Future.delayed(Duration(milliseconds: milisecondsPerCut));
      yield culculatedValue;
    }
  }

  Iterable<double> _generateEaseInOut(double currentValueArg) sync* {
    final double valueDelta = currentValueArg - _targetValue;
    final double valueDeltaPerCut = valueDelta / _totalAnimationCuts;

    double culculatedValue = currentValueArg;

    double cutRatioSum = 0.0;
    double cutRatio = _secondsPerCut / _totalAnimationDurationSec;

    _easeValueBuffer = 0.0;

    for (int i = 0; i < _totalAnimationCuts; i++, cutRatioSum += cutRatio) {
      double easePercent = _calcEaseDelta(cutRatioSum) * _totalAnimationCuts;
      culculatedValue -= valueDeltaPerCut * easePercent;
      yield culculatedValue;
    }
  }

  double _calcEaseDelta(double timeArg) {
    double easeValue = _generateEaseInOutValue(timeArg);
    double easePercent = easeValue - _easeValueBuffer;
    _easeValueBuffer = easeValue;
    return easePercent;
  }

  /// 0.0 < t < 1.0
  double _generateEaseInOutValue(double timeArg) {
    if (timeArg < 0.0 || timeArg > 1.0) {
      throw ArgumentError(
          "Failed to invalid value in _generateEaseInOutValue method, current [timeArg] => $timeArg, valid range = 0.0 < t < 1.0");
    }
    double easeValue =
        timeArg < 0.5 ? 4 * timeArg * timeArg * timeArg : (timeArg - 1) * (2 * timeArg - 2) * (2 * timeArg - 2) + 1;
    return easeValue;
  }
}