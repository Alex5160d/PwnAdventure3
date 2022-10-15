Install Pwn Adventure 3 server
==============================

The official installation guide may be a bit confusing. Therefore, here is a tutorial to install and configure your own Pwn Adventure 3 server.

> __note:__ In case you want clean, fast and easy docker deployment, have a look at my [PwnAventure3 Docker](https://github.com/beaujeant/PwnAdventure3Servers-docker/) repository.

Server configuration
--------------------

### Host

According to the requirement listed on the official page, you need an [Ubuntu 14.04](http://www.ubuntu.com/download/server) 64-bit with at least 2Go of RAM.

> __note:__ Ubuntu 16.04 Server/Desktop works as well

### Download the resources

Download the following compressed archive:

* https://pwnadventure.com/PwnAdventure3_Linux.zip
* https://pwnadventure.com/PwnAdventure3Server.tar.gz

Decompress both archive, then move `PwnAdventure3Servers/GameServer/PwnAdventure3Server` to `PwnAdventure3/PwnAdventure3/Binaries/Linux/`.

### Install psql

```
sudo apt-get update
sudo apt-get install postgresql
```

### Create user

```
useradd pwn3
```

### Configure psql

You can use the provided SQL file `PwnAdventure3Servers/MasterServer/initdb.sql`, but I would recommend you to use my [initdb.sql](), which already set up a game server account and an admin team.

```
sudo su postgres

# template1 is the default source database name for CREATE DATABASE
psql template1
```

```
# We create user "pwn3" without password
# Note: You just need to type "CREATE USER pwn3;"
template1=# CREATE USER pwn3;

# We create the database "master"
template1=# CREATE DATABASE master;

# We grant all privileges on "master" to "pwn3"
template1=# GRANT ALL PRIVILEGES ON DATABASE master TO pwn3;

# Quit the psql interface
template1=# \q
```

```
psql -f initdb.sql -d master -U pwn3
```

### Configure the game server

Edit the file `PwnAdventure3/servers/GameServer/PwnAdventure3_Data/PwnAdventure3/PwnAdventure3/Content/Server/server.ini` and write the following content:

```
[MasterServer]
Hostname=localhost
Port=3333

[GameServer]
Hostname=localhost
Port=3000
Username=GameServer
Password=PasswordForGameServer!!!
Instances=5
```

### Run the servers

```
su pwn3
cd PwnAdventure3Servers/MasterServer/
chmod +x MasterServer
./MasterServer
```

```
su pwn3
cd PwnAdventure3/PwnAdventure3/Binaries/Linux/
chmod +x PwnAdventure3Server
./PwnAdventure3Server
```

### (Optional) Customize you server

Change greeting message:

```
psql -d master -U pwn3

master=# UPDATE info SET contents='My custom server' WHERE name='login_title';
master=# UPDATE info SET contents='Hello everyone and welcome to my custome server!' WHERE name='login_text';
```

Create a new admin team

```
cd PwnAdventure3Servers/MasterServer/
./MasterServer --create-admin-team NewAdminTeam
```

Create a new game server account

```
cd PwnAdventure3Servers/MasterServer/
./MasterServer --create-server-account
```

Don't forget to change the `server.ini` accordingly.

### Troubleshoot

You shouldn't see any error message or debug message. You can also run `netstat` to make sure the master server is listening on port 3333 on all interface:

```
$ netstat -plnt

Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
...      
tcp        0      0 0.0.0.0:3333            0.0.0.0:*               LISTEN      2853/MasterServer
...
```


Client configuration
--------------------

On your client (i.e. the computer you will use to play the game) download the [client archive](http://pwnadventure.com/#downloads), extract the archive and run the executable. Here again, it will download the data file (about 2Go). Once done, you can close launcher and edit the `server.ini` file available here:

* Linux: `PwnAdventure3_Data/PwnAdventure3/PwnAdventure3/Content/Server/server.ini`
* macOS: `Pwn\ Adventure\ 3.app/Contents/PwnAdventure3/PwnAdventure3.app/Contents/UE4/PwnAdventure3/Content/Server/server.ini`
* Windows: `PwnAdventure3_Data/PwnAdventure3/PwnAdventure3/Content/Server/server.ini`

Here we want to point the master server to our server instead of the official one. For this, we will replace the `Hostname` value of the `[MasterServer]` to `pwn3.server`:

```
[MasterServer]
Hostname=localhost
Port=3333
```

> __note:__ You can remove the `[GameServer]` part

Now you should be good to play!
