from superyaml import *
import yaml

sy=superyaml({'config_file': 'simple.yml',
              })
sy.load()


print "sy.config is %s" % yaml.dump(sy.config)



