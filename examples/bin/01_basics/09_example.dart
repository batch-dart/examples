// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication(
      jobs: [TestBranchJob()],
    )..run();

class TestBranchJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Test Branch Job',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(
            name: 'Switch Branch Step',
            task: SwitchBranchTask(),
            branchesOnSucceeded: [
              Step(name: 'On Succeeded Branch', task: NotToBeExecutedTask())
            ],
            branchesOnFailed: [
              Step(name: 'On Failed Branch', task: ToBeExecutedTask())
            ],
            branchesOnCompleted: [
              Step(name: 'On Completed Branch', task: SayHelloWorldTask())
            ],
          ),
        ],
      );
}

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
