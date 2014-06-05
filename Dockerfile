# This file creates the Docker image for the current working version of the Koala
# api. It is a self-contained image, requiring all of the application dependencies
# and gems.

# Start with a Ruby install of 2.0.0
# https://index.docker.io/u/paintedfox/ruby/
FROM paintedfox/ruby

MAINTAINER Mark Stratmann <mark@stratmann.me.uk>

# Setup the working directory
WORKDIR /project

# Install application system dependencies
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y git-core
RUN apt-get install -y libgtkmm-2.4 libsasl2-dev
RUN apt-get install -y libnotify-dev imagemagick
RUN apt-get install -y nodejs

# Install Bundler
RUN gem install bundler

# Add the application to the container (cwd)
ADD ./ /project

VOLUME ["/project"]

# Bundle install the applications gem dependencies
RUN bundle install

# Setup the entrypoint
# CMD ["start", "-c", "web=8", "-p", "3000"]
ENTRYPOINT ["/bin/bash"]
