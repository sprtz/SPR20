//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;



contract SPR20 {

    /**
    ERC-20 События
     */
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint _value);

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint _value);


    mapping(address => mapping (address => uint)) private allowed;
    mapping(address => uint) private balances;


    uint private contractTotalSupply = 1000000000;
    string private contractName = "Spritzen"; 
    string private contractSymbol = "SPR";
    uint8 private contractDecimals = 18;
    address private contractOwner;


    /**
    Метод инициализации класса. В нем все необходимые начальные присваивания и настройки.
     */
    constructor() 
    {
        contractOwner = msg.sender;
    }


    /**
    Проверка что вызов метода совершает создатель контракта
     */
    modifier onlyOwner() {
        require(
            msg.sender == contractOwner,
            "Only owner can do this");
        _;
    }


    /**
    Проверка на некорректный адрес
     */
    modifier ifAddressIsNotZero(
        address _account) 
    {
        require(
            _account != address(0),
            "Zero address are not allowed");
        _;
    }


    /**
    Выводимая сумма должна быть меньше или равна балансу
     */
    modifier ifBalanceGreatherThanOrEqualToAmount(
        uint _balance,
        uint _amount) 
    {
        require(
            _balance >= _amount,
            "Not enough tokens");
        _;
    }


    modifier ifAllowedGreatherThanOrEqualToAmount(
        uint _allowed,
        uint _amount)
    {
        require(
            _allowed >= _amount,
            "Allowed limit exceeded");
        _;
    }


    /**
    Возвращает имя контракта.
     */
    function name() 
     public 
     view 
     returns (string memory) {
         return contractName;
    }


    /**
    Возвращает символ, ассоциируемый с контрактом.
     */
    function symbol() 
     public view 
     returns (string memory) 
    {
         return contractSymbol;
    }


    /**
    Возвращает количество десятичных знаков для токенов. 
     */
    function decimals() 
     public 
     view
     returns (uint8) 
    {
        return contractDecimals;
    }


    /**
    Возвращает общее количество токенов в обращении.
     */
    function totalSupply() 
     public 
     view 
     returns (uint) 
    {
        return contractTotalSupply; 
    }


    /**
    Возвращает баланс(хранимое кол-во токенов) для конкретного адреса.
     */
    function balanceOf(
        address _owner)
        public 
        view
        ifAddressIsNotZero(_owner) 
        returns (uint balance)
    {
        balance = balances[_owner];
    }


    /**
    Перемещает указанное кол-во токенов с баланса адреса вызвавшего метод, на баланс указанного адреса .
     */
    function transfer(
        address _to,
        uint _value)
        public
        ifAddressIsNotZero(_to)
        ifBalanceGreatherThanOrEqualToAmount(balances[msg.sender], _value)
        returns (bool success) 
    {

        balances[msg.sender] -=  _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        success = true;
    }


    /**
    Позволяет адресу, вызвавшему метод перевести разрешенное кол-во токенов с баланса другого адреса на третий адрес.
     */
    function transferFrom(
        address _from,
        address _to,
        uint _value) 
        public 
        ifAddressIsNotZero(_from)
        ifAddressIsNotZero(_to)
        ifAllowedGreatherThanOrEqualToAmount(allowance(_from, msg.sender), _value)
        ifBalanceGreatherThanOrEqualToAmount(balances[_from], _value)
        returns (bool success) 
    {

        allowed[_from][msg.sender] -= _value;
        emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
        
        balances[_from] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        success = true;
    }


    /**
    Разрешает перевод с баланса другого адреса определенного кол-ва токенов. При повторном вызове для одного и того же адреса, разрешенное кол-во токенов перезаписывается.
     */
    function approve(
        address _spender,
        uint _value)
        public
        ifAddressIsNotZero(_spender)
        ifBalanceGreatherThanOrEqualToAmount(balances[msg.sender], _value)
        returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
    }


    /**
    Возвращает кол-во токенов, которое разрешено списать одному адресу с баланса другого адреса.
     */
    function allowance(
        address _owner,
        address _spender)
        public 
        view
        ifAddressIsNotZero(_owner)
        ifAddressIsNotZero(_spender)
        returns (uint remaining) 
    {
        remaining = allowed[_owner][_spender];
    }


    /**
    Уменьшает баланс конкретного адреса, уменьшает totalSupply. Уменьшает общее количество токенов в обращении.
     */
    function burn(
        address _account,
        uint _amount) 
        public
        onlyOwner
        ifAddressIsNotZero(_account)
        ifBalanceGreatherThanOrEqualToAmount(balances[_account], _amount)
    {
        balances[_account] -= _amount;
        contractTotalSupply -= _amount;
        emit Transfer(_account, address(0), _amount);
    }


    /**
    Увеличивает баланс конкретного адреса, повышает totalSupply. Увеличивает общее количество токенов в обращении.
     */
    function mint(
        address _account,
        uint _amount)
        public  
        onlyOwner 
        ifAddressIsNotZero(_account)
    {
        balances[_account] += _amount;
        contractTotalSupply += _amount;
        emit Transfer(address(0), _account, _amount);
    }

}
