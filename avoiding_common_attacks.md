My tests test the edge cases outside of the require statement. Testing the require statement just took too long and I ended up scrapping it to save time... 
My contract doesn't utilize recursion at all so I'm good with recursive call attacks / recentrancy.
I validate the side of the string before using it and I don't have any integers to worry about overflow / underflow.
For poison data safety I use require to make sure the string is a valid hash and disable any other kind of string input. The require just checks the string is a valid length.
The timestamp vulnerabilities don't seem to affect my contract because miners can only affect it within a certain amount of time within a minute. If that's the case, a user can put their photo in and the timestamp will still be around the time they submitted the photohash which is okay in my case / the contract's use case.
I don't give any user special privileges. I don't use tx.origin. Lastly, I do make a max length for the string I use for the photohash.
