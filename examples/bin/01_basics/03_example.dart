// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => runWorkflow(
      jobs: [DoParallelProcessesJob()],
    );

class DoParallelProcessesJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Parallel Processes Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          ParallelStep(
            name: 'Parallel Processes Step',
            tasks: [
              ComputeHeavyTask(),
              ComputeHeavyTask(),
              ComputeHeavyTask(),
              ComputeHeavyTask(),
              ComputeHeavyTask(),
            ],
          )
        ],
      );
}

class ComputeHeavyTask extends ParallelTask<ComputeHeavyTask> {
  @override
  void execute(ExecutionContext context) {
    for (int i = 0; i < 10000000; i++) {
      // Do something.
    }

    //! During parallel processing, useful functions such as "log.info" are not available.
    //! Instead, use methods such as "sendMessageAsInfo".
    super.sendMessageAsInfo('Completed');
  }
}
