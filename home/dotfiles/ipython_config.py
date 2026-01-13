""" Ipython configuration file
    (eye candy-comfy version)
    Place it in .ipython/profile_default/ipython_config.py
"""

import re
import os
import subprocess
from IPython.terminal.prompts import Prompts
from pygments.token import Token

# Get the base configuration file

c = get_config()

# Import alias defined in your shell (zsh in the example)

with open(os.path.expanduser('~/.config/zsh/.zshrc')) as bashrc:
    aliases = []
    for line in bashrc:
        if line.startswith('alias'):
            parts = re.match(r"""^alias (\w+)=(['"]?)(.+)\2$""", line.strip())
            if parts:
                source, _, target = parts.groups()
                aliases.append((source, target))

    c.AliasManager.user_aliases = aliases

# Customize the default prompt and color scheme

c.InteractiveShell.colors = 'Linux'


class MyPrompt(Prompts):
    def in_prompt_tokens(self, cli=None):
        return [
            (Token, ' '),
            (Token.PromptNum, str(self.shell.execution_count)),
            (Token.Prompt, u'│ '), ]

    def continuation_prompt_tokens(self, cli=None, width=None):
        if width is None:
            width = self._width()
        return [
            (Token.Prompt, (' ' * (width - 2)) + u'│ '), ]

    def out_prompt_tokens(self):
        return [
            (Token, ' '),
            (Token.OutPromptNum, str(self.shell.execution_count)),
            (Token.OutPrompt, '> '), ]


c.TerminalInteractiveShell.prompts_class = MyPrompt

# Add here lines of code to run at IPython startup, think on some more alias (bash-like functions)
#    and the %rehashx magic function to get system $PATH (this command can be only used once)

c.InteractiveShellApp.exec_lines = ["""
%alias isrun ps -A | grep %s
%rehashx
""",
                                    'import numpy as np',
                                    'import matplotlib.pyplot as plt',
                                    'import scipy as sp']
