import { keccak256, toUtf8Bytes } from "ethers";

for (let idx = 10000000; idx < 100000000; idx++) {
    let sig = `requestClaim_${idx}(address,uint256,bool)`
    let selector = keccak256(toUtf8Bytes(sig)).slice(0, 10);
    if (sig.startsWith('0x000000')) {
        console.log(`Found sig: ${sig}, selector: ${selector}`)
        break
    } else {
        console.log(`Miss sig: ${sig}, selector: ${selector}`)
    }
}
