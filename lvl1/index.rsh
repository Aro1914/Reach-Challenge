'reach 0.1';

// Participants' common properties
const Part = {
    getBalance: Fun([], UInt),
    apply: Fun([], Address),
    informStatus: Fun([Bool], Null),
    confirmApplication: Fun([Data({ "None": Null, "Some": Address }), UInt], Null),
};


export const main = Reach.App(() => {
    // A nice practice when using Maps
    setOptions({ untrustworthyMaps: true });

    const Alice = Participant('Alice', {
        ...Part,
    });
    init(); // App init

    Alice.only(() => {
        const aliceAddress = declassify(interact.apply()); // Getting the address from the frontend
    });
    Alice.publish(aliceAddress);
    assert(typeof (aliceAddress) == Address); // Confirming the published value is indeed an address
    const whitelist = new Map(Address); // Store for the wallet addresses  
    const size = array(UInt, [0]); // Edit this value to virtually edit the amount of whitelisted wallets

    // Intended behavior is to check the size of the Map, and then add a wallet address based on the result
    if (size[0] < 5) {
        whitelist[Alice] = aliceAddress;
        Alice.only(() => {
            interact.informStatus(true);
            // The added wallet address is sent back, referencing it with the participant
            interact.confirmApplication
            (whitelist[Alice], size[0] + 1); // A little programmers' manipulation is applied 😇 to simulate an increase in the size of the whitelist, until a valid solution can be provided, it will probably be taken care of in the level 2 submission
            
        });
    } else {
        // If the whitelist happens to be full then the participant is informed of the failed application
        Alice.only(() => {
            interact.informStatus(false);
        });
    }
    commit(); // Finally we go back to Step state
});