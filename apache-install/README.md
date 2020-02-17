### Ansible Role

To run the ansible role, checkout out repository

```bash
cd ansible-role
```

To fill the brief's pre-requisites install the necessary requirements from the local infra team

```bash
ansible-galaxy install -r roles/requirements.yaml

OR

ansible-galaxy install git+http://internaltest.example.com/repos/infra/apache.git,1.4

```

Install required role

```bash
ansible-playbook --connection=webserver web.yml

```

### JenkinsFile

The JenkinsFile represents the pipeline specified in the spec document

- Code is checked out via Git
- Initial build is run with mandatory tests, developers should have tests by default when writing scripts else script fails
- NPM project so predefined setup is defined with install and test commands
- Security scanning is done by a tool I've used before, sonarr, the implementation here scans the project and will only pass the pipeline if there is no errors. Pre-requisite is that it should be at least Jenkisn 2.6
- Finally once checks and balances are complete the code then writes to a Dockerfile and pushes to a docker private repo, the method at the top pre-defines the repo details

### User Permission Test

The python script tests the user permissions of the users creates in ansible role.

Script writes tempFile as defined user and catches error:

```bash
userPerm.py dev1
```