
const FS = require('fs');
const Util = require('util');
const { exec } = require('child_process');

//  Test folder
const testFolder = './Tests/RoxTests/Sources';
// Swift Command
const command = './.build/debug/Rox';
/* Helper functions */

// Splits between directories and files
function filterDirectory(files) {
  // Enumerate the directories
  let dirs = files.filter(file => !file.includes(".rx") && !file.includes(".skip"))
  // Enumerate the files
  files = files.filter(file => file.includes(".rx"))
  return { dirs, files: files };
}

// Returns the files that are not to be skipped
function filterFile(file) {
  let data = FS.readFileSync(file, 'utf8');
  let lines = data.split('\n');
  return lines[0].includes('!skip') ? null : file;
}

// Get the filered files and directories
let filtered = filterDirectory(FS.readdirSync(testFolder))

// Get the filtered files
let files = filtered.files.map(file => `${testFolder}/${file}`)

// Enumerate the files from the child directory i.e. Tests/Sources/{child-dir}
filtered.dirs.forEach(dir => {
  let folder = `${testFolder}/${dir}/`
  let contents = `${folder}${FS.readdirSync(folder)}`;
  contents
    .split(',')
    .forEach(file => files.push(file.includes('Sources') ? file : `${folder}${file}`));
});

// Remove null values
files = files.filter(file => filterFile(file) != null);

// Executes Rox and returns an array of outputs
async function execute(array, filter) {
  return Promise.all((filter ? files.filter(filter) : files).map(file => {
    return new Promise((resolve, reject) => {
      exec(`${command} ${file}`, { maxBuffer: 1024 * 10000 }, (error, stdout, stderr) => {
        // console.log(`processing file : ${file}`)
        const content = FS.readFileSync(file, 'utf8')
        let filter = (output) => output.trim().split('\n').filter(s => s != '')
        if (error) {
          console.error(`error: ${error}`);
          reject({ file, error, content })
        }
        resolve({ file, stdout: filter(stdout), stderr: filter(stderr), content, error })
      });
    });
  }));
}

(async () => {
  try {
    let passed = 0, failed = 0
    let status = () => ({ passed, failed })
    let regex = {
      error: /Error (.+): (.+)/,
      errorAt: /Error (.+) at (.+)\: (.+)/,
      expect: /# expect: (.+)/,
      expectRuntime: /# expect runtime error: (.+)/,
      location: /(\(\d\,\d\))/
    };
    const red = (string) => `\x1b[31m${string}\x1b[0m`
    const green = (string) => `\x1b[32m${string}\x1b[0m`
    const yellow = (string) => `\x1b[33m${string}\x1b[0m`

    const match = (content) => {
      return content.match(regex.expect) || content.match(regex.expectRuntime) || []
    }
    
    const result = await execute(files, file => !file.includes("benchmark") && !file.includes("class"))

    let tests = result.map(output => ({ output, expects: match(output.content) }));

    let batches = tests.map((test, index) => {
      // Define stdeout and stderr
      const stdout = test.output.stdout, stderr = test.output.stderr;
      const file = test.output.file;

      // Test the ones that have expectations
      if (test.expects.length > 0) {
        function runtime() {
          let expected = (regex.expectRuntime.exec(test.expects[0]) || [])[1]
          return stdout.map(out => {
            let got = regex.error.exec(out) || []
            if (got[2] === expected) {
              passed++
              return { ok: true, status: status() }
            } else {
              failed++
            }
            return { ok: false, status: status(), got: got[3], expected, file: test.output.file }
          });
        }
        function error() {
          let expect = test.expects[0]
          return stdout.map(out => {
            let isErrorAt = regex.errorAt.test(out)
            let got = isErrorAt ? (regex.errorAt.exec(out) || []) : (regex.error.exec(out) || [])
            let expected = isErrorAt ? (regex.errorAt.exec(expect) || []) : (regex.error.exec(expect) || [])
            let index = 3
            if (got[index] === expected[index]) {
              passed++
              return { ok: true, status: status() }
            } else {
              failed++
            }
            return { ok: false, status: status(), got: got[index], expected: expected[index], file: test.output.file }
          });
        }
        // Test runtime errors
        if (/runtime/.test(test.expects[0])) {
            return runtime()
        }
        // Test parse error
        if (/Error/.test(test.expects[0])) {
            return error()
        }
        // Test literals or others
        let expects = test.output.content
        .split('\n')
        .map(line => (regex.expect.exec(line) || [])[1])
        .filter(line => !!line)
        if (JSON.stringify(stdout) === JSON.stringify(expects)) {
          passed++
          return { ok: true, status: status() }
        } else {
          failed++
          return { ok: false, status: status(), got: stdout, expected: expects, file: test.output.file }
        }
      } else {
        // It's possible that some files do not have expectations.
        // It might be safe to say that if we have nothing in stdout
        // then we will consider it passing
        if (stdout.length === 0 && test.expects.length === 0) {
          passed++
          return { ok: true, status: status() }
        } else {
          failed++
          return { ok: false, status: status(), got: stdout, expected: test.expects, file: test.output.file }     
        }
      }
    });
    
    const report = (batch) => {
      batch.forEach(unit => {
        if (!unit.ok){
          const message = `Expected: "${unit.expected || "None" }" but got "${unit.got}"`
          console.error(`${red('FAIL')}:`, `${unit.file}`,`\n\t${red(message)}`)
          console.log('Passed', green(`${unit.status.passed}`), 'Failed', green(`${unit.status.failed}`))
        }
      });
    }

    batches.filter(batch => batch.length > 0).forEach(report)
    // console.log(`passed: ${green(`${passed}`)}, failed: ${red(`${failed}`)}`)

  } catch (error) {clearImmediate
    console.log(error)
  }
})()