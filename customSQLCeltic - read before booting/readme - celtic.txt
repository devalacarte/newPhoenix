DO NOT RUN FOLDER: it is what it means. I sent you an updated world db with all the customs, so no need for these things.
scripts to update auth: run to insert broadcasts


THIS MUST BE RUN BEFORE YOU BOOT THE SERVER AND LET PEOPLE LOG IN, THEY WILL LOSE THEIR ITEMS IF YOU DON'T
Go to the src - sql - updated
and run all the character sqls and auth sqls if there are any. Do not bother with the world ones. I've already done those.

scripts to update char db; will create custom tables
will change all the inventory itemids to the correct ids.


you can keep updating the core with trinity updates.
Get a new git from trinitycore and revert to the folowing commit:

Author:		Vincent-Michael <Vincent_Michael@gmx.de>
Date:		2 hours ago (zo aug 11 11:51:59 2013)
Commit hash:	9e45731f3270b44d45d1b96e96d0fceb6ccf4ec3
Parent(s):	c0bf535e5b


Scripted/ToC5: Add missing stuff in c0bf535e5bc978257952c9bd4e258eed238d1828


Contained in branches: master
Contained in no tag

delete everything from the folder you just downloaded to, and move my core in it
stash changes
download new trinity commits
apply them
apply my changes again

I'll do this once in a while and update my own core and my git