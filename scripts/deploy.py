from brownie import accounts, SimpleBank, network

def deploy_simple_bank():
    account = get_account()
    simple_bank = SimpleBank.deploy({"from": account})
    stored_total_bank_balance = simple_bank.getBankBalance()
    print(stored_total_bank_balance)

def get_account():
    if network.show_active() == 'development':
        return accounts[0]

def main():
    deploy_simple_bank()