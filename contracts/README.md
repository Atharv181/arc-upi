# contracts

`ArcPay` forwards native USDC on Arc to a merchant and emits `Paid(payer, merchant, amount, memo)`.
On Arc the native gas token is USDC with **18 decimals** (the ERC-20 view at `0x3600…0000` uses 6).

```sh
forge test
# deploy to Arc testnet (fund the deployer at https://faucet.circle.com)
forge script script/Deploy.s.sol --rpc-url arc_testnet --broadcast --private-key $DEPLOYER_KEY
```
