FROM continuumio/anaconda3

# Set the ENTRYPOINT to use bash
# (this is also where you’d set SHELL,
# if your version of docker supports this)
ENTRYPOINT [ "/bin/bash", "-c" ]

EXPOSE 5000

# Conda supports delegating to pip to install dependencies
# that aren’t available in anaconda or need to be compiled
# for other reasons.
RUN apt-get update && apt-get install -y \
 libpq-dev \
 build-essential \
&& rm -rf /var/lib/apt/lists/*

# Use the environment.yml to create the conda environment.
ADD env.yaml /tmp/env.yaml
WORKDIR /tmp
RUN [ "conda", "env", "create", "--file", "env.yaml" ]

ADD . /code

# Use bash to source our new environment for setting up
# private dependencies—note that /bin/bash is called in
# exec mode directly
WORKDIR /code/shared
# RUN [ "/bin/bash", "-c", "source activate token-ANN && python setup.py develop" ]

WORKDIR /code
# RUN [ "/bin/bash", "-c", "source activate token-ANN && python setup.py develop" ]

# We set ENTRYPOINT, so while we still use exec mode, we don’t
# explicitly call /bin/bash
CMD [ "source activate token-ANN && exec python ann.py" ]
