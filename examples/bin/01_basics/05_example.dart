// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'dart:io';

import 'package:batch/batch.dart';

void main(List<String> args) => runWorkflow(
      jobs: [SayHelloWorldJob()],
      logConfig: LogConfiguration(
        // Change output configuration to multi.
        output: MultiLogOutput([
          ConsoleLogOutput(),
          FileLogOutput(file: File('./test.log')),
        ]),
      ),
    );

class SayHelloWorldJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Say Hello World Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(
            name: 'Say Hello World Step',
            task: SayHelloWorldTask(),
          ),
        ],
      );
}

class SayHelloWorldTask extends Task<SayHelloWorldTask> {
  @override
  void execute(ExecutionContext context) {
    // It outputs on the console in default.
    log.info('Hello, World!');
  }
}
