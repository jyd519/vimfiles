from invoke import call, Call, task, Context 
from invoke.main import program

def make_context(self, config):
    if config.get('ctx'):
        return config.ctx
    return Context(config=config)

Call.make_context = make_context

## invoke on remote machine 
def invoke_remote(context, task_name, **kwargs):
    context.config.load_overrides({'ctx': context})
    executor = program.executor_class(
        program.collection, config=context.config, core=program.core
    )
    results = executor.execute((task_name, kwargs))
    return results[program.collection[task_name]]

