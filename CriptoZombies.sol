pragma solidity ^0.4.19; //todos los arhivos .sol empiezan con esta linea

contract ZombieFactory { // el contrato encapsula todo el código

    event NewZombie(uint zombieId, string name, uint dna); //el evento será frente a lo que reaccionará la aplicación

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie { //definicion de los objetos con los que trabajaremos
        string name;
        uint dna;
    }

    Zombie[] public zombies; //Array dinámico que usaremos como BBDD

    function _createZombie(string _name, uint _dna) private { //Hay que indicar especificamente las funciones que serán privadas y públicas.
        uint id = zombies.push(Zombie(_name, _dna))-1;
        NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string _str) private view returns (uint) { //view lo usaremos en los metodos que acceden a los datos pero no los modifican. 
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public { //finalmente a partir de un nombre generamos un dna aleatorio y junto con el nombre creamos un zombie. Una vez se añade a la base de datos salta el evento.
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
