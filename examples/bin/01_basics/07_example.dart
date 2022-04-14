// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:batch/batch.dart';

void main(List<String> args) => BatchApplication()
  ..addJob(
    Job(
      name: 'Job',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )
      ..nextStep(
        Step(name: 'Step1')..registerTask(OutputSharedParametersTask()),
      )
      ..nextStep(
        Step(name: 'Step2')..registerTask(OutputJobParametersTask()),
      )
      ..nextStep(
        Step(name: 'Step3')..registerTask(SetJobParametersTask()),
      )
      ..nextStep(
        Step(name: 'Step4')..registerTask(OutputJobParametersTask()),
      ),
  )
  ..addJob(
    Job(
      name: 'Job2',
      schedule: CronParser(value: '*/2 * * * *'), // Execute every 2 minutes.
    )
      ..nextStep(
        Step(name: 'Step1')..registerTask(OutputSharedParametersTask()),
      )
      ..nextStep(
        Step(name: 'Step2')..registerTask(OutputJobParametersTask()),
      ),
  )
  //! You can add parameters to be shared by this batch application with the addSharedParameter method.
  //! The parameter value is a dynamic type, so it can contain any type.
  ..addSharedParameter(key: 'key1', value: 'shared value')
  ..addSharedParameter(key: 'key2', value: {'key2-1': 'Any objects'})
  ..run();

class OutputSharedParametersTask extends Task<OutputSharedParametersTask> {
  @override
  void execute(ExecutionContext context) {
    //! You can access to shared parameters with the execution context.
    log.info(context.sharedParameters['key1']);
    log.info(context.sharedParameters['key2']);
  }
}

class SetJobParametersTask extends Task<SetJobParametersTask> {
  @override
  void execute(ExecutionContext context) {
    //! You can access to job parameters with the execution context.
    //! And job parameters are it's shared only within this job and is
    //! cleared upon completion of the job.
    context.jobParameters['key1'] = 'some value';
  }
}

class OutputJobParametersTask extends Task<OutputJobParametersTask> {
  @override
  void execute(ExecutionContext context) {
    if (context.jobParameters.contains('key1')) {
      log.info(context.jobParameters['key1']);
    } else {
      log.info('Job parameter is not set.');
    }
  }
}
