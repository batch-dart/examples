// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication()
  ..addJob(
    Job(
      name: 'Shutdown Job',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )..nextStep(
        //! You can shutdown this application with `shutdown()`.
        Step(name: 'Shutdown Step')..shutdown(),
      ),
  )
  ..run();

class SayHelloWorldTask extends Task<SayHelloWorldTask> {
  @override
  void execute(ExecutionContext context) {
    //! You also can shutdown with following method instead of `shutdown()`.
    super.shutdown();
  }
}
