import * as core from '@actions/core';
import * as github from '@actions/github';
import * as exec from '@actions/exec';

async function run() {
    try {
        const { repoToken, branchType, branchName } = {
            repoToken: core.getInput('repo-token', { required: true }),
            branchType: core.getInput('branch-type', { required: true }),
            branchName: core.getInput('branch-name', { required: true })
        };
        const fullBranchName = `${branchType}/${branchName}`;

        const octokit = github.getOctokit(repoToken);
        const { owner, repo } = github.context.repo;

        // Ensure development branch exists
        try {
            await octokit.rest.repos.getBranch({
                owner,
                repo,
                branch: 'development',
            });
        } catch (error) {
            if (error.status === 404) {
                await exec.exec('git checkout -b development');
                await exec.exec('git push origin development');
            } else {
                throw error;
            }
        }

        // Create the new branch from development
        await exec.exec('git fetch origin');
        await exec.exec('git checkout development');
        await exec.exec('git pull origin development');
        await exec.exec(`git checkout -b ${fullBranchName}`);
        await exec.exec(`git push origin ${fullBranchName}`);

        console.log(`:: Branch '${fullBranchName}' created and pushed to remote.`);
    } catch (error) {
        core.setFailed(error.message);
    }
}

run();
