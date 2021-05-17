#!/bin/bash

ansible-playbook -e @config/openmp_course_switch_cloud.yml ansible/openmp-course-01-boot-openstack.yml
ansible-playbook -e @config/openmp_course_switch_cloud.yml -i ansible/inventory/openmp_course ansible/openmp-course-02-configure.yml
