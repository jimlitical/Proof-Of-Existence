My project enables one to show pictures and timestamp them on a blockchain.

It's basically the proof of existence dapp but it has some differences. 

It doesn't use the address to map to a photo but rather a photo maps to an owner and a timestamp.

The project enables one to take a picture and timestamp it forever. One situation I see this being useful is for when someone goes to a pawn shop to get their items back. The pawn shop doesn't want to risk the customer saying the shop damaged them after they take their item out of the store so they take a picture of the item w/ the happy owner next to a completely undamaged item and put it in the blockchain for extra measure. If the customer still says the item was damaged then the owner would be able to show the picture of the item and the owner to show it was in fine condition until they took it out of the store and there is no liability on the owner. 

My project takes the SHA256 hash and stores that as the key for the owner and timestamp struct I made.

*Ideally users will hold a timestamp or something in the photo to know they actually took the photo during the date that its hash is submitted.

To run:
start ganache-cli
go to project directory and run truffle compile
then run truffle migrate
then npm run dev

localhost will be used as the server for testing.
