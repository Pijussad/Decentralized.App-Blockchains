// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LectureDApp {
    mapping(address => bool) public isTeacher;
    mapping(address => uint) public userBalances; // New mapping to store user balances

    uint public lectureCount = 0;
    mapping(uint => Lecture) public lectures;

    event LectureUploaded(uint id, string link, string information, uint price);
    event LecturePurchased(uint id, address buyer);

    modifier onlyTeacher() {
        require(isTeacher[msg.sender], "Only teachers can call this function");
        _;
    }

    constructor() {
        isTeacher[msg.sender] = true;
    }

    function addTeacher(address _teacher) public onlyTeacher {
        isTeacher[_teacher] = true;
    }

    function uploadLecture(string memory _link, string memory _information, uint _price) public onlyTeacher {
    emit LectureUploaded(++lectureCount, _link, _information, _price);

    // Set teacher to the deployer's address
    lectures[lectureCount] = Lecture(lectureCount, _link, _information, _price, payable(msg.sender));
    // Update the teacher field in the Lecture struct
    lectures[lectureCount].teacher = payable(msg.sender);
}


    function viewAvailableLectures() public view returns (Lecture[] memory) {
        Lecture[] memory allLectures = new Lecture[](lectureCount);
        for (uint i = 1; i <= lectureCount; i++) {
            allLectures[i - 1] = lectures[i];
        }
        return allLectures;
    }

    function purchaseLecture(uint _id) public payable {
        require(_id > 0 && _id <= lectureCount, "Invalid lecture ID");

        Lecture storage lecture = lectures[_id];
        require(lecture.price > 0, "Invalid lecture price");
        require(msg.value >= lecture.price, "Insufficient funds");

        // Transfer funds to the teacher
        lecture.teacher.transfer(lecture.price);

        // Add the ether to the teacher's balance
        userBalances[lecture.teacher] += lecture.price;

        emit LecturePurchased(_id, msg.sender);
    }

    struct Lecture {
        uint id;
        string link;
        string information;
        uint price;
        address payable teacher;
    }
}
