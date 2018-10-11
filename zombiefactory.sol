pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna); //Evento que notifica la creacion de un nuevo Zombie

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner; //diccionarios que iremos guardando (de forma clave-valor) a quien pertenece un zombie. clave-Zombie1 => valor-direccion del propietario.
    mapping (address => uint) ownerZombieCount; //diccionario de cuantos zombies tiene un usuario. Clave-direccion_usuario => valor- Numero de zombies

    function _createZombie(string _name, uint _dna) internal { //hemos cambiado el metodo a internal para que al heredar otro contrado de este pueda usarlo
        uint id = zombies.push(Zombie(_name, _dna)) - 1; //Añadimos el zombie al array y nos quedamos con la posicion de este
        zombieToOwner[id] = msg.sender; //Asignamos el zombie creado a la direccion del que lo ha creado.
        ownerZombieCount[msg.sender]++; //aumentamos en 1 el registro de zombies que tenia el creador
        NewZombie(id, _name, _dna); //Una vez creado llamamos al evento
    }

    function _generateRandomDna(string _str) private view returns (uint) { //funcion que genera a partir del nombre un ADN. Lo genera a partir de cualquier string pero será del nombre
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0); //comprobamos que el creador no tiene mas zombies creados de esta forma. Require lanza error si no se cumple la condicion.
        uint randDna = _generateRandomDna(_name); 
        randDna = randDna - randDna % 100; // modificamos el ADN generado dejando a 0 el ADN de los zombies en las 2 ultimas cifras. Mas adelante modificaremos el de los zombies gato.
        _createZombie(_name, randDna); //finalmente creamos el zombie.
    }

}
