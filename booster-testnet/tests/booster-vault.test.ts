import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt, Bytes } from "@graphprotocol/graph-ts"
import { AddSupportedToken } from "../generated/schema"
import { AddSupportedToken as AddSupportedTokenEvent } from "../generated/BoosterVault/BoosterVault"
import { handleAddSupportedToken } from "../src/booster-vault"
import { createAddSupportedTokenEvent } from "./booster-vault-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/subgraphs/developing/creating/unit-testing-framework/#tests-structure

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let _token = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let _minAmount = BigInt.fromI32(234)
    let _maxAmount = BigInt.fromI32(234)
    let newAddSupportedTokenEvent = createAddSupportedTokenEvent(
      _token,
      _minAmount,
      _maxAmount
    )
    handleAddSupportedToken(newAddSupportedTokenEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/subgraphs/developing/creating/unit-testing-framework/#write-a-unit-test

  test("AddSupportedToken created and stored", () => {
    assert.entityCount("AddSupportedToken", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "AddSupportedToken",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "_token",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "AddSupportedToken",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "_minAmount",
      "234"
    )
    assert.fieldEquals(
      "AddSupportedToken",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "_maxAmount",
      "234"
    )

    // More assert options:
    // https://thegraph.com/docs/en/subgraphs/developing/creating/unit-testing-framework/#asserts
  })
})
