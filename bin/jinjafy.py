#!/usr/bin/env python
# by FND
"""
command-line wrapper for Jinja2

Usage:
  $ templater.py [-o <output directory>] [templates directory] <template file>

optionally accepts template variables as JSON via STDIN
"""

import sys
import os
import json

import jinja2


def main(args):
	args = [unicode(arg, "utf-8") for arg in args][1:]

	output_dir = False
	try:
		pos = args.index("-o")
		output_dir = args.pop(pos + 1)
		args.pop(pos)
	except ValueError:
		pass

	template_file = args.pop()
	try:
		template_dir = args.pop()
	except IndexError, exc:
		template_dir = os.path.dirname(os.path.abspath(template_file)) # XXX: hardly elegant!?
	template_file = os.path.basename(template_file)
	
	if not sys.stdin.isatty():
		data = json.loads(sys.stdin.read())
	else:
		data = {} # XXX: hardly elegant!?

	output = render(template_file, template_dir, **data) # TODO: arguments
	output = output.encode('utf-8')
	if output_dir:
		if os.path.abspath(output_dir) == os.path.abspath(template_dir): # XXX: not safe!?
			raise ValueError("must not overwrite existing template")
		with open(os.path.join(output_dir, template_file), "w") as f:
			f.write(output)
	else:
		print output

	return True


def render(template_file, template_dir, **kwargs):
	loader = jinja2.FileSystemLoader(template_dir) # XXX: use PackageLoader?
	env = jinja2.Environment(loader=loader,line_comment_prefix="##")

	template = env.get_template(template_file)

	return template.render(**kwargs)


if __name__ == "__main__":
	status = not main(sys.argv)
	sys.exit(status)
