==Usage

```bash
sudo docker run -it \
    -v </path/to/gitkey>:/gitkey \
	-v </path/to/ec2key>:/ec2key \
	-e STACK_NAME=<test> \
	-e AWS_ACCESS_KEY_ID=<AKIAJNTQUY2HWGT6SZAA> \
	-e AWS_SECRET_ACCESS_KEY=<$AWS_SECRET> \
	flashvoid/romana-build install
	
# gitkey - is ssh key with access to romana git repo
# ec2key - is our shared ec2 key
# STACK_NAME - is obviously a name of CF stack
# AWS_ACCESS_KEY_ID - and AWS_SECRET_ACCESS_KEY are
# aws keys used to create CF stack
```
