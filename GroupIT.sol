pragma solidity >=0.5.0 <0.6.0;

contract GroupeIT {

    event isOfferValid(bool result);
    event allOffers(string result);

    struct Offer {
        string sha_256;
        uint256 createTime;
    }

    // mapping (uint => Offer) offers; --> serait mieux pour consommer moins de gaz
     Offer[] public offers;

    function addOffer(string memory _sha_256) public {
         offers.push(Offer(_sha_256, now));
    }

    function getAllOffer() public {
        string memory result;
        result='{"offers":[';

      for (uint i = 0; i < offers.length ; i++) {
        result=stringsConcat(result,'{');

        result=stringsConcat(result,'"sha":"');
        result=stringsConcat(result,offers[i].sha_256);
        result=stringsConcat(result,'",');

        result=stringsConcat(result,"},");
      }
        //faire au propre avec un if last sans la virgule
        result=stringsConcat(result,"{");
        result=stringsConcat(result,"}");

        result=stringsConcat(result,"]}");
        emit allOffers(result);
    }


//    function checkSha256(string memory _sha_256) public returns (bool) {
    function checkSha256(string memory _sha_256) public {

      bool result= false;
      for (uint i = 0; i < offers.length ; i++) {
        if (stringsEqual(offers[i].sha_256,_sha_256 )) {
         result= true;
        }
      }
      emit isOfferValid(result);
     // return result;
    }


   /*
    function checkSha(string _sha) external view returns(bool) {
    bool memory result = true;

    return result;
   }
   */
/* --> serait mieux pour gérer les updates
    function setGroupeITContractAddress(address _address) external {
    groupeITContract = GroupeItInterface(_address); https://cryptozombies.io/fr/lesson/3/chapter/1 https://cryptozombies.io/fr/lesson/3/chapter/2
  }
*/

function stringsEqual(string memory _a, string memory _b) internal returns (bool) {
    bytes memory a = bytes(_a);
    bytes memory b = bytes(_b);
    if (a.length != b.length) return false;
    // @todo unroll this loop
    for (uint i = 0; i < a.length; i ++){
    if (a[i] != b[i]){
    return false;
    }
    }

    return true;
    }


function stringsConcat(string memory _base, string memory _value) internal returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for(i=0; i<_baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for(i=0; i<_valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i++];
        }

        return string(_newValue);
    }
}
