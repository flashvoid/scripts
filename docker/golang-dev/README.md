# Development environment for golang

# Build
```
git clone
docker build -t go-dev .
```

# Start working
``` 
# example bash func
dev-start () {
	docker run -it --rm \
		-v `pwd`:/home/void/go/src/github.com/<reponame> \
		-v ~/.ssh:/home/void/.ssh \
		-v ~/.gitconfig:/home/void/.gitconfig \
		-p 8080 \
		go-dev bash
}

cd /path/myrepo
dev-start
```

# Perks
* vim-go
* godoctor
* ctags
* delver
