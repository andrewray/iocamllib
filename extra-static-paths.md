The following configures the tornado webserver so it can serve files from
directories other than `~/ipython/profile_xxx/static`.

This is mainly useful when using the XmlHttpRequest APIs of js_of_ocaml.

Edit ipython_notebook_config.py and enable a line like

```
c.NotebookApp.extra_static_paths = [ '/your/arbitrary/path/datafiles' ]
```

Given a file called `myfile` in the above directory you can access it with 
the path `/static/myfile`.
