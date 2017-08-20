pragma solidity ^0.4.11;


contract Purchase {
    address public seller;
    address public buyer;
    uint public initValue;
    uint public state = 0;
    mapping (address => uint) mortgages;


    modifier onlyDoubleInitValue() {
        require(msg.value % 2 == 0);
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer);
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller);
        _;
    }

    event PurchaseConfirmed(address _sender, string _msg);
    event ItemReceived(address _sender, string _msg);
    event Aborted(address _sender, string _msg);

    function Purchase() payable {
        seller = msg.sender;
        initValue = msg.value / 2;
        mortgages[seller] = initValue;
    }

    function value() constant returns (uint) {
        if (msg.sender == seller) {
            return mortgages[seller];
        }else {
            return mortgages[buyer];
        }
    }

    function confirmPurchase() onlyDoubleInitValue payable {
        buyer = msg.sender;
        mortgages[buyer] = initValue;
        state = 1;
        PurchaseConfirmed(msg.sender, "PurchaseConfirmed");
    }

    function confirmReceived() onlyBuyer {
        ItemReceived(msg.sender, "ItemReceived");
        state = 2;
        seller.transfer(this.balance - mortgages[buyer]);
        buyer.transfer(mortgages[buyer]);
    }

    function abort() onlySeller {
        seller.transfer(mortgages[seller] * 2);
        buyer.transfer(mortgages[buyer] * 2);
        state = 2;
        Aborted(msg.sender, "Aborted");
    }

}
