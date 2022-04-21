// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication(
      jobs: [TestRetryJob()],
    )..run();

class TestRetryJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Test Retry Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(
            name: 'Throw Exception and Retry Step',
            task: ThrowFormatExceptionTask(),
            retryConfig: RetryConfiguration(
              //! Define the exception to retry.
              retryableExceptions: [FormatException()],
              //! Define the retry count.
              maxAttempt: 5,
              //! Define the retry interval.
              backOff: Duration(milliseconds: 5),
              //! Do recover when the all retries are failed.
              onRecover: (context) {
                log.warn('Recovered from exception.');
              },
            ),
          ),
          Step(name: 'Say Hello World Step', task: SayHelloWorldTask())
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
