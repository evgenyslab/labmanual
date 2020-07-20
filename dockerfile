# Docker file for prototype development with CLion, Pycharm & Webstorm
#
# Build and run:
#   LINK SSH:
#   ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2222"
#
#   Latest:
#   docker build -t dev/development-env -f dockerfile .
#   docker run -d --cap-add sys_ptrace -p127.0.0.1:2222:22 -p8888:8888 --name dev en/development-env:0.1
#
# Access the image remotely:
#   docker exec -it <container_name> zsh
#
# stop:
#   docker stop dev
#
# ssh credentials (test user):
#   user@password
#


FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install -y ssh \
      build-essential \
      gcc \
      g++ \
      gdb \
      git \
      clang \
      cmake \
      rsync \
      tar \
      htop \
      tree \
      screen \
      zsh \
      vim \
      npm \
      python \
      python-pip \
      python3-pip \
      libgtest-dev \
      libsm6 \
      libxext6 \
      libxrender-dev \
  && apt-get clean

# Finalize gtest install:
RUN cd /usr/src/gtest \
    && cmake CMakeLists.txt \
    && make \
    && cp *.a /usr/lib


RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_dev \
  && mkdir /run/sshd

RUN useradd -m user \
  && yes password | passwd user

# install npx:
RUN npm install -g npx

# set up zsh:
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# add prompt notice that you are in docker/screen:
Run echo "if [[ \$TERM == screen ]]; then \n\tPROMPT=\"%B%F{red}(DOCKER[%b%f%B%F{green}SCREEN%b%f%B%F{red}])%b%f \$PROMPT\" \nelse\n\tPROMPT=\"%B%F{red}(DOCKER)%b%f \$PROMPT \" \nfi" >> /root/.zshrc


# Screen shell link:
RUN echo "shell \"/usr/bin/zsh\"" >> /etc/screenrc

# pip install requirements:
COPY requirements.txt /tmp/requirements.txt

# copy over requirements & install to system python
RUN cd /tmp && pip3 install -r requirements.txt

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_dev"]
