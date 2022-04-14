// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication()
  ..addJob(
    Job(
      name: 'Say Hello World Job',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )..nextStep(
        Step(name: 'Say Hello World Step')..registerTask(SayHelloWorldTask()),
      ),
  )
  ..run();

class SayHelloWorldTask extends Task<SayHelloWorldTask> {
  @override
  void execute(ExecutionContext context) {
    // It outputs on the console in default.
    log.info('Hello, World!');
  }
}
