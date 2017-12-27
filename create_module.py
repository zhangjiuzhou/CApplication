#!/usr/local/bin/python3
#coding=utf-8

import os

module_name = ''
class_prefix = ''
while True:
    try:
        if len(module_name) == 0:
            module_name = input('>>> 请输入模块名称：\n')
        elif len(class_prefix) == 0:
            class_prefix = input('>>> 请输入类名前缀：\n')
        else:
            break
    except EOFError:
        exit()

template_git = 'https://github.com/nbyh100/ModuleTemplate'
template_project_name = 'ModuleTemplate'
template_project_dir = '%s.xcodeproj' % template_project_name
template_project_file = '%s/project.pbxproj' % template_project_dir
template_project_source_dir = template_project_name
template_project_develop_source_dir = '%sDevelop' % template_project_name

project_dir = '%s.xcodeproj' % module_name
project_source_dir = module_name
project_develop_source_dir = '%sDevelop' % module_name


os.system('git clone %s "%s"' % (template_git, module_name))
os.chdir(module_name)

def listdir(path):
    return list(map(lambda x:'%s/%s' % (path, x), os.listdir(path)))

def replace(file, origin, replace):
    f = open(file, 'r')
    content = f.read()
    f.close()

    content = content.replace(origin, replace)
    f = open(file, 'w')
    f.write(content)
    f.close()

# read project file
project_file = open(template_project_file, 'r')
project_file_content = project_file.read()
project_file.close()

# set class prefix
project_file_content = project_file_content.replace('CLASSPREFIX = ""', 'CLASSPREFIX = "%s"' % class_prefix)

# replace project name
project_file_content = project_file_content.replace(template_project_name, module_name)
files = ['%s/main.m' % template_project_develop_source_dir] + \
    listdir('%s/Classes' % template_project_source_dir) + \
    listdir('%s/Protocols' % template_project_source_dir) + \
    listdir('%s/Classes' % template_project_develop_source_dir)
for file in files:
    replace(file, template_project_name, module_name)

# save project file
project_file = open(template_project_file, 'w')
project_file.write(project_file_content)
project_file.close()

# rename dirs
os.rename(template_project_dir, project_dir)
os.rename(template_project_source_dir, project_source_dir)
os.rename(template_project_develop_source_dir, project_develop_source_dir)

os.system('open ./%s' % project_dir)
