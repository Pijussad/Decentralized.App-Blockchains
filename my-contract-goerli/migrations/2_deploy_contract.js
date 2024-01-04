"use strict";

const LectureDApp = artifacts.require("LectureDApp");

module.exports = function (deployer) {
  deployer.deploy(LectureDApp);
};
