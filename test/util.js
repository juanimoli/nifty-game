const promisify = inner =>
  new Promise((resolve, reject) =>
    inner((err, res) => {
      if (err) {
        reject(err);
      }
      resolve(res);
    })
  );

const getBalance = async addr => {
  const web3eth = new Web3(window.ethereum);
  const res = await promisify(cb => web3eth.eth.getBalance(addr, cb));
  return new web3eth.BigNumber(res);
};

module.exports = {
  getBalance
};
