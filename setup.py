import setuptools
import bento.distutils
from bento.distutils.monkey_patch import monkey_patch
monkey_patch()
setuptools.setup()
