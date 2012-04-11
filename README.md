Keyset
======

A utility for managing multiple sets of dotfiles ('keysets') within the same UNIX account.  I wrote this to manage my named SSH keys, though it can be used for other things as well.

Setup
-----

To use this, you'll want to:

0. create a ~/.keysets directory.
1. Within that directory will need to be one directory for each of your keysets.
2. Within each keyset directory, you'll want to have copies of the relevant dotfiles to be rotated in and out, with the leading dots removed:

	~/.keysets/dann
	~/.keysets/dann/ssh
	~/.keysets/dann/ssh/config
	~/.keysets/dann/ssh/known_hosts
	~/.keysets/dann/ssh/id_dsa
	~/.keysets/dann/ssh/id_dsa.pub
	~/.keysets/dann/gitconfig
	~/.keysets/dann/eyrc
	~/.keysets/another_account/eyrc
	~/.keysets/another_account/ssh/config

3. Finally, you'll want to symlink 'current' in the .keysets directory to whichever keyset is currently loaded.
4. Needless to say, CREATE BACKUPS OF YOUR KEYS BEFORE RUNNING THIS SCRIPT.
5. Ahem. Thank you.

Runtime
-------

The `keyset` script serves three functions:

* `keset` - reports the current keyset, good for embedding in your bash prompt
* `keyset list` - lists all available keysets
* `keyset load <keyset_name>` - loads the requested keyset into your home directory and restarts ssh-agent

Output
------

    $ keyset
    dann

    $ keyset list
    another_account
    * dann

    $ keyset load another_account
    Removing link to ssh/config
    Removing link to ssh/known_hosts
    Removing link to ssh/id_dsa
    Removing link to ssh/id_dsa.pub
    Removing link to gitconfig
    Setting link /home/dann/.keysets/another_account/ssh/config ---> /home/dann/.ssh/config
    Setting link /home/dann/.keysets/another/ssh/id_rsa.pub ---> /home/dann/.ssh/id_rsa.pub
    Setting link /home/dann/.keysets/another/ssh/known_hosts ---> /home/dann/.ssh/known_hosts
    Setting link /home/dann/.keysets/another/ssh/id_rsa ---> /home/dann/.ssh/id_rsa
    Setting link /home/dann/.keysets/another/gitconfig ---> /home/dann/.gitconfig
    Identity added: /home/dann/.ssh/id_rsa (/home/dann/.ssh/id_rsa)

License
=======

Copyright (C) 2012 Dann Stayskal

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

