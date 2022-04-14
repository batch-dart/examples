// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication()
  ..addJob(
    Job(
      name: 'Job 1',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )..nextStep(
        Step(name: 'Switch Branch Step')
          ..registerTask(SwitchBranchTask())
          ..createBranchOnSucceeded(
            to: Step(name: 'On Succeeded Branch')
              ..registerTask(NotToBeExecutedTask()),
          )
          ..createBranchOnFailed(
            to: Step(name: 'On Failed Branch')
              ..registerTask(ToBeExecutedTask()),
          )
          //! onCompleted branch will always be executed regardless of branch status.
          ..createBranchOnCompleted(
            to: Step(name: 'On Completed Branch')
              ..registerTask(SayHelloWorldTask()),
          ),
      ),
  )
  ..run();

class SwitchBranchTask extends Task<SwitchBranchTask> {
  @override
  void execute(ExecutionContext context) {
    //! You can switch branch by using `switchBranchToXXXXX`.
    context.stepExecution!.switchBranchToFailed();
  }
}

class ToBeExecutedTask extends Task<ToBeExecutedTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('congratulation on the execution of this task!');
  }
}

class NotToBeExecutedTask extends Task<NotToBeExecutedTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('Something wrong if you see this message!');
  }
}

class SayHelloWorldTask extends Task<SayHelloWorldTask> {
  @override
  void execute(ExecutionContext context) {
    log.info('Hello, World!');
  }
}
