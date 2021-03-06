## Makefile to build a Chocolatey package with chocomilk

## CUSTOMIZATION ###############################################################
#

# Ansible playbook repository which contains the playbook referenced
ANSIBLE_PLAYBOOK_REPO ?= https://github.com/itigoag/chocomilk.git

# Ansible before provisioning playbook
ANSIBLE_PLAYBOOK_BEFORE ?= chocomilk/before.yml

# Ansible provisioning playbook
ANSIBLE_PLAYBOOK ?= chocomilk/play.yml

.PHONY: all

all: clone \
    hosts \
	travis \
	play

before: clone \
    hosts \
	travis

clone: 
	@git clone $(ANSIBLE_PLAYBOOK_REPO) chocomilk 2>&1

hosts: 
	@echo "chocomilk" > hosts

travis: 
	ansible-playbook $(ANSIBLE_PLAYBOOK_BEFORE) -i hosts

play:
	ansible-playbook $(ANSIBLE_PLAYBOOK) -i hosts

debug:
	ansible-playbook $(ANSIBLE_PLAYBOOK) -i hosts -vvvvv

package:
	ansible-playbook $(ANSIBLE_PLAYBOOK) -i hosts --skip-tags "deployment,notifications"

package-debug:
	ansible-playbook $(ANSIBLE_PLAYBOOK) -i hosts --skip-tags "deployment,notifications" -vvvvv
