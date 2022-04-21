// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication(
      jobs: [
        SayHelloWorldJob(),
        SayDartIsAwesomeJob(),
      ],
    )..run();

class SayHelloWorldJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Say Hello World Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(name: 'Say Hello Step', task: SayHelloTask()),
          Step(name: 'Say World Step', task: SayWorldTask())
        ],
      );
}

class SayDartIsAwesomeJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Say Dart Is Awesome Job',
        schedule: CronParser('*/1 * * * *'), // Execute every minutes.
        steps: [
          Step(
            name: 'Say Dart Is Awesome Step',
            task: SayDartIsAwesomeTask(),
          )
        ],
      );
}

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
