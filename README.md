pve-datapacks
=============
This datapack contains custom loot tables supporting gameplay for `p.nerd.nu`
("PvE").


Contents
--------
Some vanilla Minecraft 1.13.2 chest loot tables are modified with additional
custom drops. These loot tables have names of the form
`minecraft:chests/<name>`.

For simplicity the augmented vanilla Minecraft chest loot tables are defined
in terms of an unmodified copy of the vanilla Minecraft chest loot tables,
renamed as `minecraft:vanilla/chests/<name>`.

The datapack also contains custom chest loot tables used by custom structures
generated using OpenTerrainGenerator according to the configurations in
[totemo/OTGConfigs](https://github.com/totemo/OTGConfigs). Those loot tables
have names in the `otgconfigs:` namespace, e.g.
`otgconfigs:chests/end_villager_pod`.


Installation
------------
Download the zip file from [the releases page](https://github.com/totemo/pve-datapacks/releases)
and place it in the `world/datapacks/` folder under the server directory.


Testing Loot Tables
-------------------
It's prohibitively inconvenient to have to find a generated structure in order
to verify the correct operation of these loot tables. The commands listed below
can check and set the loot table associated with a chest.

 * In Minecraft 1.13.2:
   * You can set the loot table of a pre-existing chest (under your feet):
```
/data merge block ~ ~ ~ {LootTable:"otgconfigs:chests/end_villager_pod"}
```
   * You can also *read* the loot table (and other NBT data) of that chest:
```
/data get block ~ ~ ~
```
 
 * In Minecraft 1.12.2, the commands are a little different:
   * You can create a new chest with a specific loot table like so:
```
/setblock ~ ~ ~ minecraft:chest facing=south {LootTable:"otgconfigs:chests/end_egg_endermite"}
```
   * Or you can set the loot table of a pre-existing chest (under your feet):
```
/blockdata ~ ~-1 ~ {LootTable:"otgconfigs:chests/end_egg_endermite"}
```
   * You can also *read* the loot table (and other NBT data) of that chest:
```
/blockdata ~ ~-1 ~ {}
```


Building
--------
If you would prefer to build the datapack yourself rather than download it from
here, follow these instructions.

You will need a UNIX-like environment with:

 * The Bourne Again Shell (Bash)
 * The GNU C Preprocessor
 * The Java `jar` utility
 * The `zip` command line utility
 
Clone this repository and then run `build.sh`:
```
git clone https://github.com/totemo/pve-datapacks
cd pve-datapacks/chest_loot
./build.sh
```

