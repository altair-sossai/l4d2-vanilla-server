# Custom Left 4 Dead 2 Vanilla Server
The server is a mix between the standard Vanilla developed by Valve and the community developed Zone. 

Currently the settings only support game mode versus 4x4.

**My Steam account:**

https://steamcommunity.com/id/altairsossai/

## Based on another repository
Several existing files/plugins in this repository were copied from the repository below:
- https://github.com/SirPlease/L4D2-Competitive-Rework

## What changes?
- Players can request !pause during games.
- At the beginning of each round, 1 medkit and 3 pills are distributed to survivors.
- Map medkits have been removed.
- Only 2 molotovs present on the maps.
- Only 2 pipe bombs present in the maps.
- The amount of t2 weapons are limited for survivors.
- The maps have the changes (stripper) present in the zone.
- At the beginning of each round players need to type !ready to start.
- Tank and witch on all maps (except finale)
- If the witch is killed without incapacitating any player, 100 points are awarded to the survivors.
- !mix functionality
- !fila functionality
- Tank is distributed equally among players
- Player stats are displayed (Tank damage, MVP)
- SMAC enabled

## How to install the default server (Linux)

Use the commands below on a Linux operating system to install a standard server version of Left 4 Dead.

```
# Create a folder to store game files
cd /home
sudo mkdir steam
cd /home/steam

# Installs all the tools needed to start and manage the server
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install screen -y
sudo apt-get install ufw -y
sudo apt-get install lib32gcc1 libc6-i386 -y
sudo apt-get install wget -y

# Install the game
sudo wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
sudo tar -xvzf steamcmd_linux.tar.gz
sudo ./steamcmd.sh +force_install_dir ./l4d2/ +login anonymous +app_update 222860 validate +exit

# Go to installation folder
cd /home/steam/l4d2/
```

## How to update the game version (Linux)

If there is any update in the game, it will be necessary to update the server too, for that, execute the commands below.

```
# Go to game folder
cd /home/steam

# Install updates
sudo ./steamcmd.sh +force_install_dir ./l4d2/ +login anonymous +app_update 222860 validate +exit
```

## Install the files present in this repository

After configuring the default server, it will be necessary to copy the files present in this repository for the settings / plugins to work

```
# Go to 'left4dead2' game folder
cd /home/steam/l4d2/left4dead2

# Copy all files present in this repository to folder 'left4dead2'
```
