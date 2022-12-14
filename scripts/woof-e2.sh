#!/bin/bash

cd $HOME

rm -R $HOME/.canine
rm -R $HOME/canine-chain
rm $GOPATH/bin/canined

git clone https://github.com/JackalLabs/canine-chain
cd canine-chain
git switch woof-e1

make install

cd $HOME

canined init $MONIKER --chain-id $CHAIN
canined keys add $ALIAS --keyring-backend="test"
canined config keyring-backend test

canined add-genesis-account $(canined keys show $ALIAS -a) 250000000ujkl
canined gentx $ALIAS 200000000ujkl --chain-id $CHAIN

sed -i 's/mode = "full"/mode = "validator"/g' $HOME/.canine/config/config.toml
sed -i 's/indexer = \["null"\]/indexer = \["kv"\]/g' $HOME/.canine/config/config.toml

KEY=$(jq '.pub_key' ~/.canine/config/priv_validator_key.json -c)
echo $KEY > ~/key.json

echo "done running"