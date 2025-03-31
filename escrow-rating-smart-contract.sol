// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract pracDapps {

    // ----------------------------
    // Order Structure and Storage
    // ----------------------------
    struct Order {
        address buyer;       // The buyer who places the order
        address seller;      // The seller to receive payment
        uint amount;         // Amount of Ether held in escrow
        bool confirmed;      // Delivery confirmation flag
    }

    mapping(uint => Order) public Orders;  // Maps order ID to Order struct
    uint public orderId;                   // Order ID counter

    event OrderPlaced(uint orderId, address buyer, address seller, uint amount, bool confirmed);

    // ----------------------------
    // Place an Order (with escrow)
    // ----------------------------
    function placeOrder(address _seller) public payable {
        require(msg.value > 0, "You must send some Ether");
        require(_seller != address(0), "Invalid seller address");

        orderId++;

        Orders[orderId] = Order({
            buyer: msg.sender,
            seller: _seller,
            amount: msg.value,
            confirmed: false
        });

        emit OrderPlaced(orderId, msg.sender, _seller, msg.value, false);
    }

    event OrderConfirmed(uint orderId, uint amount);

    // ----------------------------
    // Confirm Delivery and Release Payment
    // ----------------------------
    function confirmOrder(uint _orderId) public {
        require(_orderId > 0 && _orderId <= orderId, "Invalid order ID");

        Order storage orderInfo = Orders[_orderId];

        require(msg.sender == orderInfo.buyer, "Only the buyer can confirm");
        require(orderInfo.confirmed == false, "Order already confirmed");
        require(orderInfo.amount > 0, "No amount to transfer");

        // Release payment to the seller
        (bool success, ) = orderInfo.seller.call{value: orderInfo.amount}("");
        require(success, "Failed to send Ether");

        orderInfo.confirmed = true;

        emit OrderConfirmed(_orderId, orderInfo.amount);
    }

    // ----------------------------
    // Rating System
    // ----------------------------

    struct Rating {
        uint totalScore;  // Sum of all scores
        uint count;       // Number of ratings received
    }

    mapping(address => Rating) public ratings; // Stores ratings per user
    mapping(uint => mapping(address => bool)) public hasRated; // Tracks if a user rated a specific order

    event RatedByCustomer(address customer, address target, uint score);

    // ----------------------------
    // Allow buyer to rate seller
    // ----------------------------
    function rateUserByCustomer(uint _orderId, address _target, uint _score) public {
        require(_score >= 1 && _score <= 5, "Score must be between 1 and 5");
        require(_orderId > 0 && _orderId <= orderId, "Invalid order ID");
        require(_target != address(0), "Invalid target address");

        Order memory order = Orders[_orderId];

        require(msg.sender == order.buyer, "Only buyer can rate");
        require(_target == order.seller, "Can only rate the seller");
        require(!hasRated[_orderId][msg.sender], "You already rated");

        ratings[_target].totalScore += _score;
        ratings[_target].count++;
        hasRated[_orderId][msg.sender] = true;

        emit RatedByCustomer(order.buyer, _target, _score);
    }

    // ----------------------------
    // Get average rating of a user
    // ----------------------------
    function getAverageRating(address _target) public view returns(uint) {
        require(ratings[_target].count != 0, "Not rated yet");
        return ratings[_target].totalScore / ratings[_target].count;
    }
}
