import { parseEther, getAddress } from "ethers";


const constructorArgs = [
    [
        getAddress("0x55d398326f99059fF775485246999027B3197955"),
    ],
    [
        getAddress("0x3c4b067622bF104FEc23463B0A4Cb912161D9319"),
    ],
    [
        776n,
    ],
    [
        parseEther("10"),
    ],
    [
        parseEther("115792089237316195423570985008687907853269984665640564039457.584007913129639935"),
    ],
    getAddress("0x25f9f26F954ED5F8907dF2a5f69776aD8564792C"),
    getAddress("0x29980fd30951B7f8B767555FE0b21cf98C814336"),
    getAddress("0xc3e666a71b38b258e6517d5d6eafaa30e46eb5ec"),
    7 * 24 * 60 * 60,
    getAddress("0x1946bC20466813ae2153c6E073DB677a529c4401"),
    getAddress("0x29980fd30951B7f8B767555FE0b21cf98C814336")
];
  
  export default constructorArgs;
  