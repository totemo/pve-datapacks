#!/bin/bash
#------------------------------------------------------------------------------
# Write template files ending in '.template' in the templates/ directory
# to the correspondly nameed file under the src/ directory, without the
# .template suffix, processing textual inclusions from the items/ and pools/
# subdirectories using the C pre-processor, CPP (GNU variant).
#------------------------------------------------------------------------------

BASE_DIR=$(cd $(dirname "$0") && pwd)
TEMPLATES_DIR="$BASE_DIR/templates"
DATA_DIR="$BASE_DIR/src/data"

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
CPP_DIR="$BASE_DIR/cpp"

# Need to extract vanilla chest loot tables?
if [ ! -f "$DATA_DIR/minecraft/loot_tables/vanilla/chests/simple_dungeon.json" ]; then
    echo "EXTRACTING vanilla chest loot tables."
    mkdir -p "$TMP_DIR"
    cd "$TMP_DIR"
    if ! jar xf "$MINECRAFT_JAR" "$MINECRAFT_JAR_INTERNAL_PATH"; then
        echo >&2 "ERROR: unable to extract vanilla loot tables from \"$MINECRAFT_JAR\"."
        exit 1
    fi

    find "$VANILLA_DEST_DIR" -name '*.json' -exec rm {} \;
    mkdir -p "$VANILLA_DEST_DIR"
    cd "$TMP_DIR/$MINECRAFT_JAR_INTERNAL_PATH"
    cp -r * "$VANILLA_DEST_DIR"
    rm -rf "$TMP_DIR"
fi

#------------------------------------------------------------------------------
# Hack. TODO: make this automatic. 
mkdir -p "$DATA_DIR/minecraft/loot_tables/vanilla/chests/village"

mkdir -p "$CPP_DIR"
for FILE in $(cd "$BASE_DIR/templates" && find . -name '*.template' | sort); do
    T="${FILE##./}"
    mkdir -p "$DATA_DIR"
    JSON="${T%%.template}"
    echo GENERATING "src/data/$JSON"
    CPP="$CPP_DIR/$(basename $T .template)"
    if ! cpp -P -I"$BASE_DIR" < "$TEMPLATES_DIR/$T" > "$CPP"; then
        echo >&2 "ERROR running preprocessor on $CPP."
        exit 1
    fi
    if ! jq . --indent 4 < "$CPP" > "$DATA_DIR/$JSON"; then
        echo >&2 "ERROR processing template inclusions on $T."
        exit 1
    fi
done
