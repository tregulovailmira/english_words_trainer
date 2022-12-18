import 'dart:isolate';

bool _running = true;

void animatedLogoLoop(SendPort sendPort) async {
  const double fps = 50.0;
  const double second = 1000.0;
  const double updateTime = second / fps;

  Stopwatch loopWatch = Stopwatch();
  loopWatch.start();
  Stopwatch timerWatch = Stopwatch();
  timerWatch.start();

  while (_running) {
    if (loopWatch.elapsedMilliseconds > updateTime) {
      loopWatch.reset();
      sendPort.send(true);
    }
    if (timerWatch.elapsedMilliseconds > second) {
      timerWatch.reset();
    }
  }
}
