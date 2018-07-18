#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2017, David Baumann <dabondi@noreply.users.github.com>
# No Licenc defined

DOCUMENTATION = '''
---
module: win_pacman
version_added: "devel"
short_description: Windows Package Manager Module
description: |
     Manage Windows Package Manager
options:
  name:
      description:
        - Name of the Package
      required: yes
  state:
    choices:
      - "present"
      - "absent"
author: David Baumann
'''

EXAMPLES = '''

'''
