// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/SimpleToken.sol";

contract SimpleTokenTest is Test {
    SimpleToken public token;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        
        token = new SimpleToken();
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 1000000 * 10**18);
        assertEq(token.balanceOf(owner), 1000000 * 10**18);
    }

    function testTokenDetails() public {
        assertEq(token.name(), "SimpleToken");
        assertEq(token.symbol(), "STK");
        assertEq(token.decimals(), 18);
    }

    function testTransfer() public {
        uint256 transferAmount = 1000 * 10**18;
        
        assertTrue(token.transfer(user1, transferAmount));
        assertEq(token.balanceOf(user1), transferAmount);
        assertEq(token.balanceOf(owner), 1000000 * 10**18 - transferAmount);
    }

    function testMint() public {
        uint256 mintAmount = 5000 * 10**18;
        uint256 initialSupply = token.totalSupply();
        
        token.mint(user1, mintAmount);
        
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), initialSupply + mintAmount);
    }

    function testMintOnlyOwner() public {
        uint256 mintAmount = 5000 * 10**18;
        
        vm.prank(user1);
        vm.expectRevert();
        token.mint(user2, mintAmount);
    }

    function testBurn() public {
        uint256 burnAmount = 1000 * 10**18;
        uint256 initialBalance = token.balanceOf(owner);
        uint256 initialSupply = token.totalSupply();
        
        token.burn(burnAmount);
        
        assertEq(token.balanceOf(owner), initialBalance - burnAmount);
        assertEq(token.totalSupply(), initialSupply - burnAmount);
    }

    function testBurnInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert();
        token.burn(1000 * 10**18);
    }
}