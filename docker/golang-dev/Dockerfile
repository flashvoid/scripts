FROM golang
LABEL maintainer stas.kraev

RUN apt-get update && apt-get install -y exuberant-ctags sudo vim-nox git screen && \
    useradd -m void -s /bin/bash -G sudo && \
    sed -i 's/%sudo.*ALL=(ALL:ALL).*ALL/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

USER void
WORKDIR /home/void

ENV GOPATH="/home/void/go"
ENV PATH="/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/void/go/bin"

ADD vimrc /home/void/.vimrc
RUN mkdir -p /home/void/.vim/autoload /home/void/.vim/bundle && \
    sudo chown void /home/void/.vimrc && \
    go get golang.org/x/tools/cmd/gorename && \
    go get golang.org/x/tools/refactor/eg && \
    go get golang.org/x/tools/refactor/importgraph && \
    go get golang.org/x/tools/refactor/satisfy && \
    go get github.com/fatih/gomodifytags && \
    go get github.com/zmb3/gogetdoc && \
    go get github.com/josharian/impl && \
    go get github.com/derekparker/delve/cmd/dlv && \
    echo "InstallGoBinaries" && \
    go get github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get github.com/derekparker/delve/cmd/dlv && \
    go get github.com/kisielk/errcheck && \
    go get github.com/davidrjenni/reftools/cmd/fillstruct && \
    go get github.com/nsf/gocode && \
    go get github.com/rogpeppe/godef && \
    go get github.com/zmb3/gogetdoc && \
    go get golang.org/x/tools/cmd/goimports && \
    go get golang.org/x/lint/golint && \
    go get github.com/alecthomas/gometalinter && \
    go get github.com/fatih/gomodifytags && \
    go get golang.org/x/tools/cmd/gorename && \
    go get github.com/jstemmer/gotags && \
    go get golang.org/x/tools/cmd/guru && \
    go get github.com/josharian/impl && \
    go get github.com/dominikh/go-tools/cmd/keyify && \
    go get github.com/fatih/motion && \
    go get -u golang.org/x/tools/gopls && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone https://github.com/fholgado/minibufexpl.vim.git /home/void/.vim/bundle/minibufexpl.vim && \
    git clone https://github.com/majutsushi/tagbar.git /home/void/.vim/bundle/tagbar && \
    git clone https://github.com/xolox/vim-easytags.git /home/void/.vim/bundle/vim-easytags && \
    git clone https://github.com/fatih/vim-go.git /home/void/.vim/bundle/vim-go && \
    git clone https://github.com/xolox/vim-misc.git /home/void/.vim/bundle/vim-misc && \
    git clone https://github.com/godoctor/godoctor.vim.git /home/void/.vim/bundle/godoctor.vim && \
    git clone https://github.com/SirVer/ultisnips /home/void/.vim/bundle/ultisnips && \
    git clone https://github.com/terryma/vim-multiple-cursors /home/void/.vim/bundle/vim-multiple-cursors && \
    vim +GoDoctorInstall +qall
