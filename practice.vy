# pragma version 0.4.0
# @license MIT
# @author: Jamie

# 1. fund the contract
# 2. withdraw
# 3. set a minimum amount for funding

interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

# ABI
# Address 0x694AA1769357215DE4FAC081bf1f309aDC325306

@external
@payable
def fund():
    assert msg.value == as_wei_value(1, "ether"), "You need to send more ETH"

@external
def withdraw():
    pass

@external
@view
def _get_price() -> int256:
    price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
    return staticcall price_feed.latestAnswer()



