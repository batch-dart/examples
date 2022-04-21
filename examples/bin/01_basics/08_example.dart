// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

//! Run this example with `dart run ./examples/bin/01_basics/08_example.dart -n batch-dart -r`.
void main(List<String> args) => BatchApplication(
      args: args,
      argsConfigBuilder: (parser) {
        //! You can use args library and you can build your own configuration here.
        //! See more information at https://pub.dev/packages/args
        parser
          ..addOption('appName', abbr: 'n')
          ..addFlag('release', abbr: 'r');
      },
      onLoadArgs: (args) {
        return args['release'] ? {'appName': 'Release ${args['appName']}'} : {};
      },
      jobs: [OutputCommandLineArgumentsJob()],
    )..run();

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
    log.info(context.sharedParameters['appName']);

    //! If the "onLoadArgs" callback is defined, the command line arguments are not set to SharedParameters
    //! unless explicitly defined for processing.
    log.info(context.sharedParameters.contains('release'));
  }
}
