// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

//! Run this example with `dart run ./examples/bin/01_basics/07_example.dart -n batch-dart -r`.
void main(List<String> args) => runWorkflow(
      //! By default, all command line arguments passed are set as SharedParameters
      //! and can be referenced through ExecutionContext.
      //!
      //! See the example below if you want to generate objects to be set in SharedParameters
      //! using command line arguments at the start of a batch application.
      args: args,
      argsConfigBuilder: (parser) {
        //! You can use args library and you can build your own configuration here.
        //! See more information at https://pub.dev/packages/args
        parser
          ..addOption('appName', abbr: 'n')
          ..addFlag('release', abbr: 'r');
      },
      jobs: [OutputCommandLineArgumentsJob()],
    );

class OutputCommandLineArgumentsJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Output Command Line Arguments Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(
            name: 'Output Command Line Arguments Step',
            task: OutputCommandLineArgumentsTask(),
          ),
        ],
      );
}

class OutputCommandLineArgumentsTask
    extends Task<OutputCommandLineArgumentsTask> {
  @override
  void execute(ExecutionContext context) {
    //! By default, all command line arguments passed are set as SharedParameters
    //! and can be referenced through ExecutionContext.
    log.info(context.sharedParameters['appName']);
    log.info(context.sharedParameters['release']);
  }
}
