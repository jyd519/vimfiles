class IgnoreDynamicRequire {
  apply (compiler) {
    compiler.hooks.normalModuleFactory.tap('IgnoreDynamicRequire', factory => {
      factory.hooks.parser.for('javascript/auto').tap('IgnoreDynamicRequire', (parser, options) => {
        parser.hooks.call.for('require').tap('IgnoreDynamicRequire', expression => {
          // This is a SyncBailHook, so returning anything stops the parser, and nothing allows to continue
          if (expression.arguments.length !== 1 || expression.arguments[0].type === 'Literal') {
            return
          }
          const arg = parser.evaluateExpression(expression.arguments[0])
          if (!arg.isString() && !arg.isConditional()) {
            return true;
          }
        });
      });
    });
  }
}
