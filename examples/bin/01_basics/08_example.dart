// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

//! Run this example with `dart run ./examples/bin/01_basics/09_example.dart -n batch-dart -r`.
void main(List<String> args) => BatchApplication(
      args: argParser.parse(args),
      onLoadArgs: (args, addSharedParameter) {
        if (args['release']) {
          addSharedParameter(
              key: 'appName', value: 'Release ${args['appName']}');
        }
      },
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
    log.info(context.sharedParameters['appName']);

    //! If the "onLoadArgs" callback is defined, the command line arguments are not set to SharedParameters
    //! unless explicitly defined for processing.
    log.info(context.sharedParameters.contains('release') == false);
  }
}
