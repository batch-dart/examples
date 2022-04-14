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
        Step(name: 'Say Hello Step')
          ..registerParallel(
            Parallel(
              name: 'Compute Heavy Task',
              tasks: [
                ComputeHeavyTask(),
                ComputeHeavyTask(),
                ComputeHeavyTask(),
                ComputeHeavyTask(),
                ComputeHeavyTask(),
              ],
            ),
          ),
      ),
  )
  ..run();

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
