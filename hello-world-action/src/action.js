const core = require('@actions/core');

async function run() {
    try {
        const nameToGreet = core.getInput('who-to-greet');
        console.log(`Hello ${nameToGreet}!`);
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
