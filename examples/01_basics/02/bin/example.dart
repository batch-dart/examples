// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication()
  ..addJob(
    Job(
      name: 'Say Hello World Job',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )
      ..nextStep(
        Step(name: 'Say Hello Step')..registerTask(SayHelloTask()),
      )
      ..nextStep(
        Step(name: 'Say World Step')..registerTask(SayWorldTask()),
      ),
  )
  ..addJob(
    Job(
      name: 'Say Dart Is Awesome Job',
      schedule: CronParser(value: '*/1 * * * *'), // Execute every minutes.
    )..nextStep(
        Step(name: 'Say Dart Is Awesome Step')
          ..registerTask(SayDartIsAwesomeTask()),
      ),
  )
  ..run();

class SayHelloTask extends Task<SayHelloTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('Hello');
  }
}

class SayWorldTask extends Task<SayWorldTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('World!');
  }
}

class SayDartIsAwesomeTask extends Task<SayDartIsAwesomeTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('Dart is awesome!');
  }
}
