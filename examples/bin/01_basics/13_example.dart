// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication()
  ..addJob(
    Job(
      name: 'Job',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )
      ..nextStep(
        Step(
          name: 'Throw Exception Step',
          retryConfig: RetryConfiguration(
            //! Define the exception to retry.
            retryableExceptions: [FormatException()],
            //! Define the retry count.
            maxAttempt: 5,
            //! Define the retry interval.
            backOff: Duration(milliseconds: 5),
            //! Do recover when the all retries are failed.
            onRecover: (context) {
              log.info('Recovered from exception.');
            },
          ),
        )..registerTask(ThrowFormatExceptionTask()),
      )
      ..nextStep(
        Step(name: 'Say Hello World Step')..registerTask(SayHelloWorldTask()),
      ),
  )
  ..run();

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
