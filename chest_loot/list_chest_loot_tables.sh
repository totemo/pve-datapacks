#!/bin/bash
# List chest loot tables in a vanilla Minecraft or Spigot server JAR.
# NOTE: PaperSpigot JARs don't work because they don't include Mojang code.

if [ $# -ne 1 ]; then
    echo "ERROR: you must specify the path to the Minecraft server JAR file." >&2
    echo "Note: only vanilla Minecraft and Spigot JARs work. Not PaperSpigot." >&2
    exit 1
fi

JAR="$1"
if [ ! -f "$JAR" ]; then 
    echo "ERROR: the specified JAR file does not exist." >&2
    exit 1
fi

if ! jar tf "$JAR" | egrep -E '\.json$' | \
   grep data/minecraft/loot_tables/chests | \
   cut -d/ -f 4- | cut -d. -f1 | \
   awk '{ printf "minecraft:"$0"\n"; }' 2>/dev/null; then
    echo "ERROR: that doesn't seem to be a Minecraft server JAR." >&2
    exit 1   
fi

