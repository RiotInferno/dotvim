Installation:
   git clone git://github.com/RiotInferno/dotvim.git ~/.vim

Create symlinks:
   ln -s ~/dotfiles/vimrc ~/.vimrc

Update plugins:
   git submodule update --init --recursive

Future submodule updates:
   git submodule foreach git pull origin master --recurse-submodules

Convert Line Endings in bundle/jcommentor

Local install of YCM:
   pip install flake8
   change line 129 to: cmake_args="-DCMAKE_INSTALL_PREFIX:PATH=$HOME"

Future bindings for Shift+FN:
   use ctrl+v+Shift+FN to mape it
