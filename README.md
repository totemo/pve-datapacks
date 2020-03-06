pve-datapacks
=============
This datapack contains custom loot tables supporting gameplay for `p.nerd.nu`
("PvE").


Contents
--------
Some vanilla Minecraft 1.13.2 chest loot tables are modified with additional
custom drops. These loot tables have names of the form
`minecraft:chests/<name>`.

For simplicity, the augmented vanilla Minecraft chest loot tables are defined
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

### Minecraft 1.13.2 (And Later Versions) Loot Table Commands
 * You can set the loot table of a pre-existing chest (under your feet):
```
/data merge block ~ ~ ~ {LootTable:"otgconfigs:chests/end_villager_pod"}
```
 * You can also *read* the loot table (and other NBT data) of that chest:
```
/data get block ~ ~ ~
```
 
### Minecraft 1.12.2 Loot Table Commands
 * You can set the loot table of a pre-existing chest (under your feet):
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

 * Bourne Again Shell (Bash)
 * GNU C Preprocessor
 * `jq` Command-Line JSON Processor
 * Java `jar` utility
 * `zip` command line utility
 
Clone this repository and then run `build.sh`:
```
git clone https://github.com/totemo/pve-datapacks
cd pve-datapacks/chest_loot
./build.sh
```


Updating
--------
The procedure for updating these loot tables in preparation for a new rev is roughly as follows (a UNIX-like environment is assumed):

 1. Change to the `chest_loot` subdirectory of where the repository has been cloned.
```
cd chest_loot
```
 2. Update file `target_settings` with the new revision's Minecraft version.
 3. List all vanilla Minecraft loot tables for that version:
```
. target_settings
./list_chest_loot_tables.sh $MINECRAFT_DIR/versions/$MINECRAFT_VERSION/${MINECRAFT_VERSION}.jar
```
 4. Add any new vanilla loot tables to the checklist of loot tables to consider in the planning spreadsheet.
 1. Assign vanilla `minecraft:` namespace and `otgconfigs:` namespace loot tables to groups wherein all tables in the group have the same configuration of custom item drops (weight, min and max items).
 1. Label each group with a letter, starting with `a`. The custom item drops for the group will be represented by a single pool, represented as a preprocessor macro in a text file in the `chest_loot/pools/` subdirectory. Currently there are pools `a` through `i`.
 1. Design the the drops for each group and write the corresponding pool macros, e.g. `#define POOL_A` in `chest_loot/pools/a`.
 1. For each `otgconfigs:` namespaced loot table, decide which vanilla loot table it should be based on. Loot tables that override vanilla `minecraft:` namespaced tables will simply inherit the vanilla loot table and add an extra pool for the custom drops.
 1. Using BeastMaster's `config.yml` as the definitive source on item properties:
   * Check for mistyped lore strings on items:
```
grep -A3 lore: config.yml | sort -u
```
   * Update `chest_loot/items/all-items` with new macros named after the new revision's custom items.
   * Add one pool for each item to `chest_loot/templates/otgconfigs/loot_tables/chests/all_items.json.template`. When assigned to a chest, that loot table supplies one of each item.
 10. Update all of the `chest_loot/templates/**/*.json.template` files according to the selected pool assignments and inherited vanilla loot tables.
 1. Build the loot tables:
```
cd chest_loot
./clean.sh && ./build.sh && cp dist/chest_loot.zip ~/minecraft/test1.15/world/datapacks/ && mark2 send ~restart
```
   * The command will vary depending on the server name and directory.
   * If the preprocessor spouts errors, fix your macros.
   * If `jq` complains of malformed JSON, you will need to temporarily remove `| jq . --indent 4` in order to see the raw preprocessor output that `jq` is being asked to format. The file containing the malformed text will be the last one before the error message, in the `src/` directory.
   > *NOTE: the `src/` directory contains the output of `generate.sh`, which is then packed into a ZIP file to make the datapack. It is the source code of the datapack. However, the input of `generate.sh` is in the `templates/` directory.*
 

Checking Items
--------------
To verify that all chest loot items are identical to the items in the BeastMaster configuration:

 1. Create an empty chest.
 2. Stand on it and run:
```
/data merge block ~ ~ ~ {LootTable:"otgconfigs:chests/all_items"}
```
 3. Take all of the items in the chest, and then use BeastMaster commands to get the same items from BeastMaster, e.g.:
```
/beast-item get golem-soul
```
   * If the BeastMaster item stacks with the one in the chest, then they are the same.


Checking Loot Tables
--------------------
When verifying loot tables, there are two points to consider:

 1. Does the table include the correct inherited vanilla loot?
 2. Does the table include the right additional custom items for its pool/group?

To check Point 1, you need to create at least one chest for each loot table type. To check Point 2, you want to see a few examples of custom loot from the same group.

Since all loot tables in the same group share the same pool definition file, a reasonable test is therefore to test all loot tables (by creating a chest with that loot) at least once until you have seen a few examples of custom loot from each of the pools.
