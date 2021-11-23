#!/bin/bash

ansible-playbook -e @config/docker_ci_course_switch_cloud.yml ansible/docker-ci-course-01-boot-openstack.yml
ansible-playbook -e @config/docker_ci_course_switch_cloud.yml -i ansible/inventory/docker_ci_course ansible/docker-ci-course-02-configure.yml -f 20
