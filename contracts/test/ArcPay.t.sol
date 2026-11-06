// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {ArcPay} from "../src/ArcPay.sol";

contract Rejecter {
    receive() external payable {
        revert("no");
    }
}

contract ArcPayTest is Test {
    event Paid(address indexed payer, address indexed merchant, uint256 amount, string memo);

    ArcPay pay;
    address customer = makeAddr("customer");
    address merchant = makeAddr("chai-wala");

    function setUp() public {
        pay = new ArcPay();
        vm.deal(customer, 100 ether);
    }

    function test_forwardsFundsAndEmits() public {
        vm.expectEmit(true, true, false, true);
        emit Paid(customer, merchant, 0.25 ether, "2 cutting chai");

        vm.prank(customer);
        pay.pay{value: 0.25 ether}(merchant, "2 cutting chai");

        assertEq(merchant.balance, 0.25 ether);
        assertEq(address(pay).balance, 0);
    }

    function test_revertsOnZeroAmount() public {
        vm.prank(customer);
        vm.expectRevert(ArcPay.ZeroAmount.selector);
        pay.pay(merchant, "");
    }

    function test_revertsOnZeroMerchant() public {
        vm.prank(customer);
        vm.expectRevert(ArcPay.ZeroMerchant.selector);
        pay.pay{value: 1}(address(0), "");
    }

    function test_revertsWhenMerchantRejects() public {
        address r = address(new Rejecter());
        vm.prank(customer);
        vm.expectRevert(ArcPay.TransferFailed.selector);
        pay.pay{value: 1}(r, "");
    }

    function testFuzz_neverHoldsFunds(uint96 amount) public {
        vm.assume(amount > 0);
        vm.deal(customer, amount);
        vm.prank(customer);
        pay.pay{value: amount}(merchant, "x");
        assertEq(merchant.balance, amount);
        assertEq(address(pay).balance, 0);
    }
}
