// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Erc20{
string name;
string symbol;
uint8 decimal;
uint256 totalSupply;
mapping (address => uint256) balances;
mapping(address => mapping(address => uint256)) allowances;

event Transfer(address indexed _from, address indexed _to, uint256 _value);
event Approval(address indexed _owner, address indexed _spender, uint256 _value);

constructor(string memory _name, string memory _symbol, uint256 _totalSupply){
    name = _name;
    symbol = _symbol;
    decimal = 18;
    totalSupply = _totalSupply;
    balances[msg.sender] = _totalSupply; 
}

function BalanceOf(address _owner) public view returns(uint256){
    require(_owner != address(0), "Address zero");
    return balances[_owner];
}

 function Transfers(address _to, uint256 _value) public returns (bool){
    require((balances[msg.sender] >= _value) && (balances[msg.sender] > 0), "No Token");
    balances[msg.sender] -= _value; 
    balances[_to] += _value; 
    emit Transfer(msg.sender, _to, _value);
    uint256 burnAmount = _value / 10; 
    balances[msg.sender] -= burnAmount;
    balances[0x0000000000000000000000000000000000000000] += burnAmount; 
    emit Transfer(msg.sender, 0x0000000000000000000000000000000000000000, burnAmount); 
    return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
        require(allowances[msg.sender][_from] >= _value, "No allowance");
        require((balances[_from] >= _value) && (balances[_from]>0) , "No Balance");
        balances[_from] -= _value; 
        balances[_to] += _value; 
        allowances[msg.sender][_from] -= _value; 
        emit Transfer(_from, _to, _value); 
        uint256 burnAmount = _value / 10;
        balances[_from] -= burnAmount; 
        balances[0x0000000000000000000000000000000000000000] += burnAmount;
        emit Transfer(_from, 0x0000000000000000000000000000000000000000, burnAmount);
        return true;
    }

    function Approve(address _spender, uint256 _value) public returns(bool){
        require(balances[msg.sender] >= _value, "No Balance");
        allowances[_spender][msg.sender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256){
        return allowances[_spender][_owner];
    }

}


