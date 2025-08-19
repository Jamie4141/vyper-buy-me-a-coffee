# Get fund from users
# Withdraw funds
# Set a minimum value for funds (in USD)

# pragma version 0.4.0
# @license MIT
# @author : Jamie

interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view

min_USD: uint256

@deploy
def __init__():
    self.min_USD = 5

@external
@payable
def fund():
    """
    Allows users to send $ to this contract
    Have a minimum $ amount send
    """
    assert msg.value >= as_wei_value(1, "ether"), "You must spend more ETH"
    # or --------------- 1 * (10 ** 18)

@external
def withdraw():
    pass

@internal
def _get_eth_to_usd_rate():
    pass

@external
@view
def get_price() -> int256:
    price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
    return staticcall price_feed.latestAnswer()

