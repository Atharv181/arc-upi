# Arc UPI ☕

UPI-style USDC payments for India. Pay `chai-wala.upi-arc.eth` instead of `0x…`.

A merchant shows a QR code, the customer scans it and pays USDC on **Arc**, and the merchant's
screen shows the payment the moment it settles (Arc has sub-second deterministic finality).
Every merchant name is issued only after a **World ID** proof, so each shop is run by a real human.

Built for ETHGlobal 2026 — sponsor tracks: **Arc (Circle)**, **ENS**, **World**.

## How it works

```
 Merchant phone                         Customer phone
 ──────────────                         ──────────────
 1. Connect wallet                      
 2. Verify with World ID ──► /api/register
                               │ verify proof (World Developer Portal)
                               │ setAddress("chai-wala.upi-arc.eth", coinType(Arc), wallet)
                               ▼ on Sepolia ENSv2 PermissionedResolver
 3. Show QR  ─────────────────────────► 4. Scan QR
                                         5. Resolve name via ENS Universal Resolver
                                            (ENSIP-11 coinType for Arc chain 5042002)
                                         6. ArcPay.pay{value}(merchant, memo) on Arc
 7. "₹ received!" ◄── Paid event ◄───────┘
```

| Piece | Where | What |
|---|---|---|
| `contracts/` | Arc testnet | `ArcPay` — forwards native USDC to the merchant and emits `Paid(payer, merchant, amount, memo)` |
| `web/` | Next.js | Merchant + customer PWA, World ID API routes, ENS record writer |
| ENS | Sepolia (ENSv2) | One PermissionedResolver on the parent name holds records for all merchant subnames (wildcard resolution) |

## Repo layout

- [contracts/](contracts/) — Foundry project
- [web/](web/) — Next.js app

Setup instructions live in each folder's README.

## License

MIT
