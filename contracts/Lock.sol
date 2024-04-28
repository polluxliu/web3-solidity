// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// 用于锁定资金直到设定的未来时间点
// 合约部署者存一笔钱在这个合约中，过了锁定期就可以提取
contract Lock {
    uint public unlockTime; //用于存储资金可以被提取的时间
    address payable public owner; //存储合约的所有者的地址

    event Withdrawal(uint amount, uint when); //用于在资金被提取时记录提取的金额和时间

    /*
    在Solidity中，当你在构造函数中添加payable修饰符时，
    这允许智能合约在部署过程中接收以太币。这是一种在合约创建时即立即为其提供资金的方法。
    通过这种方式，合约的部署者可以在创建合约的同时发送以太币到合约地址。
    */
    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender); //将合约的所有者设置为部署合约的地址（msg.sender），并确保这个地址是payable
    }

    function withdraw() public {
        // Uncomment this line, and the import of "hardhat/console.sol", to print a log in your terminal
        // console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet"); //当前区块时间是否已经到达或超过了unlockTime
        require(msg.sender == owner, "You aren't the owner"); //调用者（msg.sender）是否是合约的所有者

        // address(this).balance 获取当前智能合约账户的以太币余额。

        emit Withdrawal(address(this).balance, block.timestamp);

        owner.transfer(address(this).balance); //将合约中所有的以太币转账给所有者
    }

    /**
        添加以下代码，用于react前端的测试
     */

    string public message = "hello world";

    event SetMessage(string newMessage);

    function setMessage(string memory _msg) external {
        message = _msg;
        emit SetMessage(_msg);
    }
}
