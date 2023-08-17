import * as util from "util";
import * as cp from "child_process";

const exec = util.promisify(cp.exec);
// const { stdout, stderr } = await exec(command);
