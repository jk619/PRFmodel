#! /bin/bash

[ -z "$USERTAG" ] && USERTAG=garikoitz
[ -z "$SOLVER"  ] && SOLVER=vista
[ -z "$VERSION" ] && VERSION=2.0.3

SCRIPTPATH="$( cd "$(dirname "$0")" && pwd -P )"

echo "Building $USERTAG/prfanalyze-$SOLVER:$VERSION"
echo "  Path: $SCRIPTPATH"
echo "------------------------------------------------------------"
echo ""

docker build "$@" --tag "$USERTAG/prfanalyze-$SOLVER:$VERSION" "$SCRIPTPATH"
