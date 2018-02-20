#!/usr/bin/env python3
import os
import re
import subprocess

def nbconvert_post(event, context):
    """Handle a POST request to /notebook."""

    jupyter_path = os.path.join(
        os.environ["LAMBDA_TASK_ROOT"],
        "jupyter")

    html_output = {}
    for notebook_filename in event['files']:

        # lambda lets us writek to /tmp
        local_path = os.path.join("/tmp", notebook_filename)

        with open(local_path, "w") as local_notebook:
            local_notebook.write(event["files"][notebook_filename])

        subprocess.run([jupyter_path, "nbconvert", "--to", "html", local_path], check=True)

        # I guess?
        html_path = re.sub("\.ipynb$", ".html", local_path)
        html = open(html_path).read()

        html_output[notebook_filename] = html

    return {
        "metadata": event["metadata"], # but why tho
        "files": html_output
        }
