// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test {

    struct LogEntry {
        uint256 id;
        string message;
        address createdBy;
        uint256 timestamp;
    }

    LogEntry[] public logs;

    event LogCreated(uint256 id, string message, address createdBy, uint256 timestamp);

    function addLog(string memory _message) public {
        uint256 id = logs.length;

        logs.push(LogEntry({
            id: id,
            message: _message,
            createdBy: msg.sender,
            timestamp: block.timestamp
        }));

        emit LogCreated(id, _message, msg.sender, block.timestamp);
    }

    function getLog(uint256 _id) public view returns (
        string memory message,
        address createdBy,
        uint256 timestamp
    ) {
        require(_id < logs.length, "Invalid ID");

        LogEntry memory log = logs[_id];
        return (log.message, log.createdBy, log.timestamp);
    }

    function getTotalLogs() public view returns (uint256) {
        return logs.length;
    }
}