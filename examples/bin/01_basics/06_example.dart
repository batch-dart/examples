// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => runWorkflow(
      jobs: [
        ShouldBeOutputParametersJob(),
        ShouldNotBeOutputParametersJob(),
      ],
      sharedParameters: {
        //! You can add parameters to be shared by this batch application.
        //! The parameter value is a dynamic type, so it can contain any type.
        'token': 'XXXXXX',
        'tokens': ['XXXXXX', 'YYYYYY'],
      },
    );

class ShouldBeOutputParametersJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Job1',
        schedule: CronParser('*/2 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(name: 'Step1', task: OutputSharedParametersTask()),
          Step(name: 'Step2', task: OutputJobParametersTask()),
          Step(name: 'Step3', task: SetJobParametersTask()),
          Step(name: 'Step4', task: OutputJobParametersTask())
        ],
        jobParameters: {'jobToken': 'AAAAAAAAA'},
      );
}

class ShouldNotBeOutputParametersJob implements ScheduledJobBuilder {
  @override
  ScheduledJob build() => ScheduledJob(
        name: 'Job2',
        schedule: CronParser('*/3 * * * *'), // Execute every 2 minutes.
        steps: [
          Step(name: 'Step1', task: OutputSharedParametersTask()),
          Step(name: 'Step2', task: OutputJobParametersTask())
        ],
      );
}

class OutputSharedParametersTask extends Task<OutputSharedParametersTask> {
  @override
  void execute(ExecutionContext context) {
    //! You can access to shared parameters with the execution context.
    log.info(context.sharedParameters['token']);
    log.info(context.sharedParameters['tokens']);
  }
}

class SetJobParametersTask extends Task<SetJobParametersTask> {
  @override
  void execute(ExecutionContext context) {
    //! You can access to job parameters with the execution context.
    //! And job parameters are it's shared only within this job and is
    //! cleared upon completion of the job.
    context.jobParameters['otherToken'] = 'BBBBBB';
  }
}

class OutputJobParametersTask extends Task<OutputJobParametersTask> {
  @override
  void execute(ExecutionContext context) {
    if (context.jobParameters.contains('otherToken')) {
      log.info(context.jobParameters['jobToken']);
      log.info(context.jobParameters['otherToken']);
    } else {
      log.info('Job parameter is not set.');
    }
  }
}
