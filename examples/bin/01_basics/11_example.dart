// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication(
      jobs: [TestSkippableExceptionJob()],
    )..run();

class TestSkippableExceptionJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(
            name: 'Throw Exception Step',
            task: ThrowFormatExceptionTask(),
            skipConfig: SkipConfiguration(
              //! Define the exception to skip.
              skippableExceptions: [FormatException()],
            ),
          ),
          Step(name: 'Say Hello World Step', task: SayHelloWorldTask()),
        ],
      );
}

class ThrowFormatExceptionTask extends Task<ThrowFormatExceptionTask> {
  @override
  void execute(ExecutionContext context) {
    throw FormatException();
  }
}

class SayHelloWorldTask extends Task<SayHelloWorldTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('Hello, World!');
  }
}
