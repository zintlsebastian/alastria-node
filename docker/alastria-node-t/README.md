# WIP

## Notas generales
* Desarrollamos este readme en español, para su traducción una vez finalizada la rc1. Sin embargo, mantengamos comentarios en código y commits en inglés, para su mejor mantenimiento

## Repositorios y enlaces relacionados ##

## Agredecimientos

Basado en el trabajo previo de:

* Alfonso de la Rocha
* Marcos Serradilla Diez
* Guillermo Araujo Riestra

Gracias a todos los socios de Alastria, pasados, presentes y futuros

# Alastria

La red "T" de Alastria es una red basada en Quorum, que contempla estos tipos de nodos:

* Validadores: They are in charge of the mining and validation of the blocks using the IBFT consensus algorithm.
* Bootnodes: They are responsible for the permission of the nodes in the network.
* Regulares: They are responsible for accepting transactions, verifying them and delivering them to the “validator”.

Los socios que quieran desplegar SmartContracts y participar en la red, deben de disponer de 

## Componentes ##

Estos son los componentes software de un nodo regular:

* **geth**: Es el nodo Quorum con el que se opera en la red blockchain.

* **constellation**: Es la pieza de software que nos permite realizar transacciones privadas entre socios. Su utilización es opcional.

* **monitor:** Es un servicio REST desarrollado adHoc por el core de desarrolladores de Alastria, que permitirá recabar información y asegurar el correcto funcionamiento de la infraestructura.

Estos son los recursos de red necesarios para operar el nodo:

* **21000/TCP** y **21000/UDP**: Que permite conectarse los nodos Quorum entre sí.

Se debe permitir tráfico de entrada y salida con todos los nodos publicados en [permissioned-nodes.json](https://github.com/alastria/alastria-node/blob/develop/data/permissioned-nodes_general.json).

* **22000/TCP**: Puerto que se utiliza para conectar las Dapps.

Usualmente es de utilización local a la organización y con acceso muy restringido.

* **9000/TCP**: Puerto por el que Constellation transmite las transacciones privadas.

Se debe permitir tráfico de entrada y salida con los nodos publicados en [constellation-nodes.json](https://github.com/alastria/alastria-node/blob/develop/data/constellation-nodes.json).

## Proceso de Instalación desde Imagen Docker

La instalación se puede realizar desde dos puntos:

1) Creación de imagen propia, desde Dockerfile:

```
./docker-build.sh 
./docker-create.sh
```

2) Uso de imagen desde Dockerhub, propuesto por Alastria:
```
./docker-pull.sh
```

3) Inicio de contenedor:
```
./docker-start.sh
```

## Comprobación de instalación

Una vez iniciado el nodo, se puede comprobar el correcto funcionamiento con este comando:

Una forma sencilla de probar que su nodo opera con normalidad, es generar una transacción de envío de fondos desde la cuenta del nodo, a sí misma de 0 weis.

Desde la consola del nodo:

```sh
$ geth attach ~/alastria/data/geth.ipc # conexion por IPC
$ geth attach http://localhost:22000 # conexión por JSON/RPC
> personal.unlockAccount(eth.accounts[0])
Unlock account 0xd77922ed874d7dafa0a847b3d93953a76a36698e
Passphrase:
true
> eth.sendTransaction({from: eth.accounts[0], to: eth.accounts[0], value:0 })
"0x83cc5766c87633cab94282ddd27062cba81462d015d8e04cfcbdceed378cbe05"
```

El resultado de dicha trasacción debería verse reflejado en los logs de quorum, si bien aún no formarán parte de la DLT

``` sh
geth -exec 'eth.blockNumber' attach ~/alastria/data/geth.ipc
geth -exec 'eth.mining' attach ~/alastria/data/geth.ipc
geth -exec 'eth.syncing' attach ~/alastria/data/geth.ipc
geth -exec 'admin.peers' attach ~/alastria/data/geth.ipc
```

## Actualización 

Para que el nodo pueda comendar a interactuar con la red AlastriaT de forma normal, debe estar sincronizado en cuanto a número de transacciones. Para ello, se puede hacer de dos modos:

### Copía en caliente de DLT

Será necesario iniciar geth. Una vez un nodo validador haya aceptado el nodo regular, se iniciará el proceso

### Copía en frío de DLT

Es necesario disponer de una copia de la DLT. Los ficheros deberán ser copiados, con geth parado, en el directorio /data/chaincode

## Tareas post-script

* Actualizar zoneinfo
* Añadir crontab para actualización de nodos
* Añadir crontab para actualización de nginx

## Enlaces

* [Monitor de la red](http://netstats.telsius.alastria.io/) aparece una nueva transacción es que su nodo opera apropiadamente.

## Despligues de SmartContract

Los SmartContacts deben hacer uso del protocolo Instanbul, 

## Alastria network resources

### [Regular node] Quorum node + Constellation + Access point + Monitor

* [(English) Installation Guide](https://medium.com/babel-go2chain/setting-in-motion-a-regular-node-in-the-telsius-network-of-alastria-c2d67b8369c7)
* [(Spanish) Installation Guide](https://medium.com/babel-go2chain/c%C3%B3mo-poner-en-marcha-un-nodo-regular-en-la-red-telsius-de-alastria-876d9dcf7ccb)
* Repository of the access-point that comes installed inside the docker of the regular node [Access-point](https://github.com/alastria/alastria-access-point)

### [Regular node] Quorum node installation using Ansible from host machine

* [(English) Installation Guide](https://github.com/alastria/alastria-node/blob/testnet2/ansible/README.md)

### [Validator node] Quorum node + Access point + Monitor

* [(English) Installation Guide](https://medium.com/babel-go2chain/setting-in-motion-a-validator-node-in-the-telsius-network-of-alastria-906629bc6920)
* [(Spanish) Installation Guide](https://medium.com/babel-go2chain/c%C3%B3mo-poner-en-marcha-un-nodo-validador-en-la-red-telsius-de-alastria-676bdccc253a)

### [Bootnode node] Quorum node

* [(English) Installation Guide](https://medium.com/babel-go2chain/setting-in-motion-a-bootnode-in-the-telsius-network-of-alastria-8e13915cb85d)
* [(Spanish) Installation Guide](https://medium.com/babel-go2chain/c%C3%B3mo-poner-en-marcha-un-bootnode-en-la-red-telsius-de-alastria-18eacb20b224)

## Deployment of Smart Contracts on Alastria Network
To know more about the use of Alastria Network, you can visit the Smart Contract Deployment Guides:
* [Deploying to Alastria's network T (Quorum)](https://github.com/rogargon/copyrightly.io/blob/master/docs/NetworkT.md), created by Roberto Garcia, from Lleida University
* [Deploying to Alastria's Red T using Remix & Metamask](https://medium.com/@jmolino/como-desplegar-un-smart-contract-en-la-red-t-de-alastria-utilizando-remix-y-metamask-782463997a34) created by Jose María del Molino, from AYESA
* [Deploying to Alastria's Red T using Truffle (Quorum)](https://medium.com/babel-go2chain/como-desplegar-un-smart-contract-contra-la-red-t-de-alastria-56939034e884) created by Guillermo Araujo, from Babel

## Connection from External Applications using WebSockets
* [Connecting to an Alastria's Red T node using WebSockets](https://tech.tribalyte.eu/blog-websockets-red-t-alastria) created by Ronny Demera, from Tribalyte

* **WIKI**
	* [Home](https://github.com/alastria/alastria-node/wiki)
	* [F.A.Q.](https://github.com/alastria/alastria-node/wiki/FAQ_INDEX_EN)

* **Resources**
	* [Network Monitors (ethnetstats)](https://github.com/alastria/alastria-node/wiki/Links)
	* [Blockexplorers](https://github.com/alastria/alastria-node/wiki/Links)
	* [Access-point](https://github.com/alastria/alastria-access-point)

* **¿Need Help?**
	* [Slack](https://github.com/alastria/alastria-node/wiki/HELP)
	* [Github (use & governance)](https://github.com/alastria/alastria-node/wiki/HELP)