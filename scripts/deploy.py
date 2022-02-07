from brownie import SmartSplitter, SmartSplitterFactory, network, config
from scripts.helpful_scripts import get_account


def deploy():
    account = get_account()
    contract = SmartSplitterFactory.deploy(
        {"from": account},
        publish_source=config["networks"][network.show_active()]["verify"],
    )
    print("DividePayment contract has been deployed")
    return contract


def main():
    deploy()
