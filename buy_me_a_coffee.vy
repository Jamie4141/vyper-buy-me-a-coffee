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

min_USD: public(uint256)
price_feed: public(AggregatorV3Interface)  #0x694AA1769357215DE4FAC081bf1f309aDC325306 sepolia
owner: public(address)
funders: public(DynArray[address, 1000])
funder_to_amount_funded: public(HashMap[address, uint256])

@deploy
def __init__(price_feed_address: address):
    self.min_USD = as_wei_value(5, "ether")
    self.price_feed = AggregatorV3Interface(price_feed_address)
    self.owner = msg.sender

@external
@payable
def fund():
    """
    Allows users to send $ to this contract
    Have a minimum $ amount send
    """
    usd_value_of_eth: uint256 = self._get_eth_to_usd_rate(msg.value)
    assert usd_value_of_eth >= self.min_USD, "You must spend more ETH"
    self.funders.append(msg.sender)
    self.funder_to_amount_funded[msg.sender] += msg.value


@external
def withdraw():
    assert msg.sender == self.owner, "Not the contract owner!"
    send(self.owner, self.balance)

    # resetting 
    for funder: address in self.funders:
        self.funder_to_amount_funded[funder] = 0
    
    self.funders = []


@internal
@view
def _get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    price: int256 = staticcall self.price_feed.latestAnswer()

    eth_price: uint256 = convert(price, uint256) * (10 ** 10)

    eth_amount_in_usd: uint256 = (eth_amount * eth_price) // (1 * (10 ** 18))

    return eth_amount_in_usd


@external
@view
def get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    return self._get_eth_to_usd_rate(eth_amount)


# @external
# @view
# def get_price() -> int256:
#     price_feed: AggregatorV3Interface = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306)
#     return staticcall price_feed.latestAnswer()

