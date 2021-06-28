import React, { Component } from 'react';

class SendTransaction extends Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit() {
    let self = this;
    const transactionParameters = {
      from: this.props.metaMask.account, 
      to: this.props.metaMask.account,
      value: this.props.web3.toWei(1, 'ether'),
      data: 'dead' 
    };
    
    async() => {
      const txHash = await ethereum.request({
        method: 'eth_sendTransaction',
        params: [transactionParameters],
      });

      if (txHash == null) {
        self.props.handleWarningOpen("Error sending transaction");
      } else {
        self.props.handleWarningOpen(result);
      }
    }
  }

  render() {
    return (
      <div style={{padding: '1em', margin: '1em', border: '1px solid black'}}>
        <h1>Send Transaction</h1>
        <div>To: {this.props.metaMask.account}</div>
        <div>Network: {this.props.metaMask.network}</div>
        <button onClick={() => this.handleSubmit()}>Submit</button>
      </div>
    );
  }
}

export default SendTransaction;