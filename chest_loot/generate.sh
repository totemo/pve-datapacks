#!/bin/bash
#------------------------------------------------------------------------------
# Write template files ending in '.template' in the templates/ directory
# to the correspondly nameed file under the src/ directory, without the
# .template suffix, processing textual inclusions from the items/ directory
# using the C pre-processor, CPP (GNU variant).
#------------------------------------------------------------------------------

BASE_DIR=$(cd $(dirname "$0") && pwd)
ITEMS_DIR="$BASE_DIR/items"
TEMPLATES_DIR="$BASE_DIR/templates"
DATA_DIR="$BASE_DIR/src/data"

#------------------------------------------------------------------------------

for FILE in $(cd templates && find . -name '*.template' | sort); do
    T="${FILE##./}"
    mkdir -p "$DATA_DIR"
    JSON="${T%%.template}"
    echo GENERATING "src/data/$JSON"
    cpp -P -I"$ITEMS_DIR" < "$TEMPLATES_DIR/$T" > "$DATA_DIR/$JSON"
done

#------------------------------------------------------------------------------
# Include vanilla minecraft loot tables, renamed to:
# "minecraft:vanilla/chests/<name>.json" so that they can be referenced by
# custom replacements in the "minecraft:" and "otgconfigs:" namespaces.
#------------------------------------------------------------------------------

. "$BASE_DIR/target_settings"

MINECRAFT_JAR="$MINECRAFT_DIR/versions/$MINECRAFT_VERSION/$MINECRAFT_VERSION.jar"
MINECRAFT_JAR_INTERNAL_PATH=data/minecraft/loot_tables/chests
VANILLA_DEST_DIR="$DATA_DIR/minecraft/loot_tables/vanilla/chests"
TMP_DIR="$BASE_DIR/tmp"

# Need to extract vanilla chest loot tables?
if [ ! -f "$DATA_DIR/minecraft/loot_tables/vanilla/chests/simple_dungeon.json" ]; then
    echo "EXTRACTING vanilla chest loot tables."
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"
    if ! jar xf "$MINECRAFT_JAR" "$MINECRAFT_JAR_INTERNAL_PATH"; then
        echo >&2 "ERROR: unable to extract vanilla loot tables from \"$MINECRAFT_JAR\"."
        exit 1
    fi
    
    rm -f "$VANILLA_DEST_DIR"/*.json
    mv "$TMP_DIR/$MINECRAFT_JAR_INTERNAL_PATH"/*.json "$VANILLA_DEST_DIR"
fi

