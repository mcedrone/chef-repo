Overview
========

Every Chef installation needs a Chef Repository. This is the place where
cookbooks, roles, config files and other artifacts for managing systems
with Chef will live. We strongly recommend storing this repository in a
version control system such as Git and treat it like source code.

While we prefer Git, and make this repository available via GitHub, you
are welcome to download a tar or zip archive and use your favorite
version control system to manage the code.

Repository Directories
======================

This repository contains several directories, and each directory contains
a README file that describes what it is for in greater detail, and how to
use it for managing your systems with Chef.

* `certificates/` - SSL certificates generated by `rake ssl_cert` live here.
* `config/` - Contains the Rake configuration file, `rake.rb`.
* `cookbooks/` - Cookbooks managed by librarian.
* `data_bags/` - Store data bags and items in .json in the repository.
* `roles/` - Store roles in .rb or .json in the repository.
* `site-cookbooks/` - Cookbooks that you've created and are keeping in
  this repository

Rake Tasks
==========

The repository contains a `Rakefile` that includes tasks that are installed
with the Chef libraries. To view the tasks available with in the repository
with a brief description, run `rake -T`.

The default task (`default`) is run when executing `rake` with no arguments.
It will call the task `test_cookbooks`.

The following tasks are not directly replaced by knife sub-commands.

* `bundle_cookbook[cookbook]` - Creates cookbook tarballs in the `pkgs/` dir.
* `install` - Calls `update`, `roles` and `upload_cookbooks` Rake tasks.
* `ssl_cert` - Create self-signed SSL certificates in `certificates/` dir.
* `update` - Update the repository from source control server, understands git and svn.

The following tasks duplicate functionality from knife and may be removed in a
future version of Chef.

* `metadata` - replaced by `knife cookbook metadata -a`.
* `new_cookbook` - replaced by `knife cookbook create`.
* `role[role_name]` - replaced by `knife role from file`.
* `roles` - iterates over the roles and uploads with `knife role from file`.
* `test_cookbooks` - replaced by `knife cookbook test -a`.
* `test_cookbook[cookbook]` - replaced by `knife cookbook test COOKBOOK`.
* `upload_cookbooks` - replaced by `knife cookbook upload -a`.
* `upload_cookbook[cookbook]` - replaced by `knife cookbook upload COOKBOOK`.

Configuration
=============

The repository uses two configuration files.

* config/rake.rb
* .chef/knife.rb

The first, `config/rake.rb` configures the Rakefile in two sections.

* Constants used in the `ssl_cert` task for creating the certificates.
* Constants that set the directory locations used in various tasks.

If you use the `ssl_cert` task, change the values in the `config/rake.rb` file
appropriately. These values were also used in the `new_cookbook` task, but
that task is replaced by the `knife cookbook create` command which can be
`configured below.

The second config file, `.chef/knife.rb` is a repository specific configuration
file for knife. If you're using the Opscode Platform, you can download one for
your organization from the management console. If you're using the Open Source
Chef Server, you can generate a new one with `knife configure`. For more
information about configuring Knife, see the [Knife documentation][knifedoc].

This particular repository comes with a slightly UMTS specific `.chef/knife.rb`
file.  It expects the following things:

* That your chef server username is the same as either your local username _or_
  the value of the `CHEF\_SERVER\_USER` environment variable (your might consider
  setting this in a `.rvmrc.local` file -- see below)
* That your orgname (OpsCode Platform only) is either "umts" or set in the
  `ORGNAME` environment variable
* That your client key is stored in `~/.chef/username.pem` (where "username"
  is your chef server username mentioned above)
* That your validation key is stored in `~/.chef/orgname-validator.pem`

Librarian
=========

[Librarian-chef][lib] is a gem for managing cookbooks and their dependencies.
It is included in the `Gemfile`, and it changes the conventional file
structure and workflow of a Chef repository a little.

First, cookbooks you need should be put in the `Cheffile`.  If you are
familiar with Bundler, this file should seem familiar.  Cookbooks in the
`Cheffile` and their dependancies are handled by Librarian, and you
don't have to worry too much about them.

To see what our cookbook collection looks like, run `librarian-chef install`
and they will be downloaded into the `cookbooks/` directory.  The
`cookbooks/` directory is completely ignored by both Librarian and Chef.

The traditional locations for cookbooks have been modified slightly.
`cookbooks/` is completely ignored, it's just there for your reference.
You can use knife to upload any cookbooks that Librarian knows about,
whether or not you've downloaded them to `cookbooks/`.
`site-cookbooks/` contains cookbooks that you don't feel warrant their
own git repo.  Unlike a "normal" chef repository, however, it is not in
the "`cookbook\_path`".  This is by design.  You can keep cookbooks in
`site-cookbooks/` if you like, but they must also be added to the
`Cheffile` with a path argument:

```ruby
cookbook "some-cookbook",
  :path => "site-cookbooks/some-cookbook"
```

Only then can the cookbook be uploaded to the chef server.

rvm and Bundler
===============

There is a `Gemfile` in the project that installs chef, vagrant, and some other
tools.  You can `bundle` and get it all set up.

However, I'm also adding a fairly sophisticated `.rvmrc` file to the project.
If you let it, rvm will create a gemset called "chef" and automatically use
bundler to install the necessary gems into it.

If you have personal customizations to add to the `.rvmrc` file -- say, for
example, setting your chef server username environment variable -- add them to
a file named `.rvmrc.local` in the project root.  That file will be sourced
if it exists.

Next Steps
==========

Read the README file in each of the subdirectories for more information about
what goes in those directories.

[knifedoc]: http://help.opscode.com/faqs/chefbasics/knife
[lib]: https://github.com/applicationsonline/librarian
