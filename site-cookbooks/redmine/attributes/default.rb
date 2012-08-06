# generic attribs
default["redmine"]["repo"]      = 'git://github.com/redmine/redmine.git'
default["redmine"]["revision"]  = '1.4.1'
default["redmine"]["path"]      = '/var/www/redmine'

# databases
default["redmine"]["databases"]["adapter"]  = 'mysql'
default["redmine"]["databases"]["database"] = 'redmine'
default["redmine"]["databases"]["username"] = 'redmine'
default["redmine"]["databases"]["password"] = 'password'

default["redmine"]["server_aliases"] = []

# packages
# packages are separated to better tracking
case platform
when "redhat","centos","amazon","scientific","fedora","suse"
  default["redmine"]["packages"] = {
    "rmagick" => %w{ ImageMagick ImageMagick-devel },
    #TODO: SCM packages should be installed only if they are goin to be used
    #NOTE: git will be installed with a recipe because is needed for the deploy resource
    "scm"     => %w{ subversion bzr mercurial darcs cvs }
  }
when "debian","ubuntu"
  default["redmine"]["packages"] = {
    "rmagick" => %w{ libmagickcore-dev libmagickwand-dev librmagick-ruby },
    #TODO: SCM packages should be installed only if they are goin to be used
    #NOTE: git will be installed with a recipe because is needed for the deploy resource
    "scm"     => %w{ subversion bzr mercurial darcs cvs }
  }
end
