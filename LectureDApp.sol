// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LectureDApp {
    
    mapping(address => bool) public isTeacher; // mappingas ar mokytojas ar ne
    uint public lectureCount = 0;
    mapping(uint => Lecture) public lectures; //mappingas kad susieti su id numeriu

    //eventai
    event LectureUploaded(uint id, string link, string information, uint price);
    event LecturePurchased(uint id, address buyer);

    //kad galetu tik mokytojas
    modifier onlyTeacher() {
        require(isTeacher[msg.sender], "Only teachers can call this function");
        _;
    }
    constructor() {
        isTeacher[msg.sender] = true;
    }

    //mokytojo funkcijos
    function addTeacher(address _teacher) public onlyTeacher {
        isTeacher[_teacher] = true;
    }
    function uploadLecture(string memory _link, string memory _information, uint _price) public onlyTeacher {
        emit LectureUploaded(++lectureCount, _link, _information, _price);
        lectures[lectureCount] = Lecture(lectureCount, _link, _information, _price);
    }


    //bendros funkcijos
    function viewAvailableLectures() public view returns (Lecture[] memory) {
        Lecture[] memory allLectures = new Lecture[](lectureCount);
        for (uint i = 1; i <= lectureCount; i++) {
            allLectures[i - 1] = lectures[i];
        }
        return allLectures;
    }
    function purchaseLecture(uint _id) public payable {
        Lecture storage lecture = lectures[_id];
        require(msg.value >= lecture.price, "Insufficient funds");
        payable(msg.sender).transfer(msg.value);
        emit LecturePurchased(_id, msg.sender);
    }

    struct Lecture {//pamokos info
        uint id; 
        string link;
        string information;
        uint price;
    }
}
