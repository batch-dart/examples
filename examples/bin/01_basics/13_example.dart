// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication(
      jobs: [TestShutdownJob()],
    )..run();

class TestShutdownJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Shutdown Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step.ofShutdown(),
          Step(name: 'Shutdown Step (another way)', task: ShutdownTask()),
        ],
      );
}

class ShutdownTask extends Task<ShutdownTask> {
  @override
  void execute(ExecutionContext context) {
    //! You also can shutdown with following method instead of `shutdown()`.
    super.shutdown();
  }
}
