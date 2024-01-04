module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      gas: 30000000, // Set your desired gas limit here
    },
    
  },
  compilers: {
    solc: {
      version: "0.8.0" // or another version
    }
  }
};
