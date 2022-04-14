// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

//! Run this example with `dart run ./examples/bin/01_basics/08_example.dart -n batch-dart -r`.
void main(List<String> args) => BatchApplication(
      //! By default, all command line arguments passed are set as SharedParameters
      //! and can be referenced through ExecutionContext.
      //!
      //! See the example below if you want to generate objects to be set in SharedParameters
      //! using command line arguments at the start of a batch application.
      args: argParser.parse(args),
    )
      ..addJob(
        Job(
          name: 'Say Hello World Job',
          schedule:
              CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
        )..nextStep(
            Step(name: 'Say Hello World Step')
              ..registerTask(OutputCommandLineArgumentsTask()),
          ),
      )
      ..run();

//! You can use args library.
//! See more information at https://pub.dev/packages/args
ArgParser get argParser => ArgParser()
  ..addOption('appName', abbr: 'n')
  ..addFlag('release', abbr: 'r');

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
