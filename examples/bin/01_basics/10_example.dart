// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication(
      jobs: [TestCallbacksJob()],
    )..run();

class TestCallbacksJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Test Callbacks Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(
            name: 'Test Callbacks Step',
            task: SayHelloWorldTask(),
            //! You can determine the prerequisites for executing this step.
            precondition: (context) =>
                !context.jobParameters.contains('something'),
            //! You can define what to do when this step is started.
            onStarted: (context) => log.info('Step started.'),
            //! You can define what to do when this step is succeeded.
            onSucceeded: (context) => log.info('Step succeeded.'),
            //! You can define what to do when this step is failed due to error.
            onError: (context, error, stackTrace) =>
                log.error('Step error.', error, stackTrace),
            //! You can define what to do when this step is completed.
            onCompleted: (context) => log.info('Step completed.'),
          ),
        ],
        //! You can determine the prerequisites for executing this job.
        precondition: (context) => !context.jobParameters.contains('something'),
        //! You can define what to do when this job is started.
        onStarted: (context) => log.info('Job started.'),
        //! You can define what to do when this job is succeeded.
        onSucceeded: (context) => log.info('Job succeeded.'),
        //! You can define what to do when this job is failed due to error.
        onError: (context, error, stackTrace) =>
            log.error('Job error.', error, stackTrace),
        //! You can define what to do when this job is completed.
        onCompleted: (context) => log.info('Job completed.'),
      );
}

class SayHelloWorldTask extends Task<SayHelloWorldTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('Hello, World!');
  }
}
