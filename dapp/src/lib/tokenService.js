import { getSimpleTokenAddress } from './web3Service';
import SimpleToken from './simpleToken';

let simpleTokenAddress = '0x0';

const setWeb3Provider = (networkId) => {
  simpleTokenAddress = getSimpleTokenAddress(networkId);
}

export const getName = (networkId) => {
  try {
    setWeb3Provider(networkId);
    const simpleToken = new SimpleToken(simpleTokenAddress);
    const result = simpleToken.name();
    return result;
  } catch (err) {
    console.log('getName: ', err);
    return 'name not found';
  }
}

export const getSymbol = (networkId) => {
  try {
    setWeb3Provider(networkId);
    const simpleToken = new SimpleToken(simpleTokenAddress);
    const result = simpleToken.symbol();
    return result;
  } catch (err) {
    console.log('getSymbol: ', err);
    return 'symbol not found';
  }
}

export const getDecimals = (networkId) => {
  try {
    setWeb3Provider(networkId);
    const simpleToken = new SimpleToken(simpleTokenAddress);
    const result = simpleToken.decimals();
    return result;
  } catch (err) {
    console.log('getDecimals: ', err);
    return 'decimals not found';
  }
}
