# teleporter-template • [![CI](https://github.com/0xduality/teleporter-template/actions/workflows/tests.yml/badge.svg)](https://github.com/0xduality/teleporter-template/actions/workflows/tests.yml)

Streamlined template for getting started with Foundry, Solmate, and Teleporter.

## Contributing

You will need a copy of [Foundry](https://github.com/foundry-rs/foundry) installed before proceeding. See the [installation guide](https://github.com/foundry-rs/foundry#installation) for details.

### Setup

```sh
git clone https://github.com/0xduality/teleporter-template.git
cd teleporter-template
forge install
```

### Sample Usage

Copy `.env.example` to `.env`. Open `.env` in an editor and add a private key associated with an address that
has native tokens on the Fuji C-chain and on the Fuji Echo subnet. Then run

```sh
bash scripts/crosschain.sh
```

### Contents

The repo contains 
- `SampleSender.sol` a sender contract
- `SampleReceiver.sol` a receiver contract 
- Teleporter related interface files such as `ITeleporterMessenger.sol`
- `hexify.py` a script for converting blockchain IDs from base58 encoding to a hex encoding suitable for Teleporter. 
- a `foundry.toml` with rpc endpoints for two subnets `primary` and `echo` where Teleporter is deployed
- `crosschain.sh` deploys the contracts on the two subnets, sends a message from `primary` to `echo`, and reads the result in `echo`.

### 

### Forge Tests

For now, Foundry does not support the warp precompile. Thus,

```sh
forge test
```

runs a test that expects the call to the Warp precompile to revert. 
