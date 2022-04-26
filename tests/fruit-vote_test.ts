import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v0.28.0/index.ts";
import { assertEquals } from "https://deno.land/std@0.90.0/testing/asserts.ts";

Clarinet.test({
  name: "Ensure that <...>",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const sender = accounts.get("wallet_1")!.address;

    let block = chain.mineBlock([
      Tx.contractCall("fruit-vote", "vote", [types.utf8("\u{e345}")], sender),
    ]);

    console.log("block", block);

    assertEquals(block.receipts.length, 1);
  },
});
