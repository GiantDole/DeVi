var Web3 = require('web3');

const web3 = new Web3(Web3.givenProvider || "ws://localhost:7545");

//Get ethereum node information
web3.eth.getNodeInfo(function(error, result){
    if(error){
       console.log( "error" ,error);
    }
    else{
       console.log( "result",result );  //Ganaache - "EthereumJS TestRPC/v2.1.0/ethereum-js"
    }
});



//Get balance for account
web3.eth.getAccounts(function(error, accounts) {
    if(error) {
      console.log(error);
    }
    
    web3.eth.getBalance(accounts[0]).then(function(result){
     console.log( "Balance : " ,web3.utils.fromWei(result, 'ether'));
    }); 
   });

//get nonce of eth account
//txnCount = web3.eth.getTransactionCount(web3.eth.accounts[0]);
//console.log(txnCount);
//Get Nonce which equals tx count
web3.eth.getAccounts(function(error, accounts) {
    if(error) {
      console.log(error);
    }
    
    web3.eth.getTransactionCount(accounts[1]).then(function(result){
     console.log( "Transactions : " ,result);
    }); 
   });

   