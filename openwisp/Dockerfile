#ARG BUILD_FROM
#FROM ${BUILD_FROM}
FROM ghcr.io/home-assistant/aarch64-base-debian:bullseye

RUN apt update
RUN apt install -y python3 python3-pip git 

RUN pip3 install --upgrade pip
RUN pip3 install wheel

RUN pip3 install cffi
RUN pip3 install Jinja2>=2.11 
RUN pip3 install --user ansible

# Add ansible bin path 
ENV PATH="/root/.local/bin/:${PATH}" 

# Verify python installation
RUN which python3

# Check ansible version
RUN ansible --version

# Ansible addons "galaxy" 
RUN ansible-galaxy collection install "community.general:>=3.6.0"
RUN ansible-galaxy collection install "ansible.posix"
RUN ansible-galaxy install openwisp.openwisp2


# Clone ansible-openwisp project
RUN git clone https://github.com/openwisp/ansible-openwisp2
COPY openwisp2/playbook.yml ansible-openwisp2/playbook.yml
WORKDIR ansible-openwisp2/


# Run playbook
RUN ansible-playbook -i hosts playbook.yml -b -k -K --become-method=su 

CMD [ "ansible-playbook -i hosts playbook.yml -b -k -K --become-method=su" ]
