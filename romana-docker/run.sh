#!/bin/bash -e

die () {
	echo $1
	exit $2
}

[[ $ROMANA_REPO ]]           || ROMANA_REPO="git@github.com:romana/romana.git"
[[ $ROMANA_BRANCH ]]         || ROMANA_BRANCH="master"
[[ $STACK_NAME ]]            || STACK_NAME=default
[[ $AWS_ENCRYPTED_SECRET ]]  && AWS_SECRET_ACCESS_KEY=$(echo -e $AWS_ENCRYPTED_SECRET | openssl aes-256-cbc -a -d)
[[ $AWS_ACCESS_KEY_ID ]]     || die "Please provide AWS credentials to spin up CF template, use -e AWS_ACCESS_KEY_ID=<aws key id> -e AWS_SECRET_ACCESS_KEY=<aws key>" 2
[[ $AWS_SECRET_ACCESS_KEY ]] || die "Please provide AWS credentials to spin up CF template, use -e AWS_ACCESS_KEY_ID=<aws key id> -e AWS_SECRET_ACCESS_KEY=<aws key>" 2

COMMAND=$1

[[ $COMMAND ]] || COMMAND=install

test -f /gitkey && cp /gitkey /root/.ssh/id_rsa || die "SSH key required to clone romana repo, use -v /path/to/key:/gitkey" 1
test -f /ec2key && cp /ec2key /root/.ssh/ec2_id_rsa || die "SSH key required to login in EC2 instances, use -v /path/to/key:/ec2key" 1
test -f /root/.ssh/id_rsa.pub || ssh-keygen -yf /root/.ssh/id_rsa > /root/.ssh/id_rsa.pub

chmod 600 /root/.ssh/*rsa*

test -d /root/romana || git clone $ROMANA_REPO --branch $ROMANA_BRANCH /root/romana
test -f /ansible.cfg && cp -f /ansible.cfg /root/romana/romana-install

cd /root/romana/romana-install
./romana-setup $COMMAND -e devstack_name=$STACK_NAME
