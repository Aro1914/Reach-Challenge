import { loadStdlib } from '@reach-sh/stdlib';
import * as backend from "./build/index.main.mjs";
const stdlib = loadStdlib();

const initBal = stdlib.parseCurrency(1000);
const accAlice = await stdlib.newTestAccount(initBal);

const format = x => stdlib.formatCurrency(x, 4);
const getBalance = async part => format(await stdlib.balanceOf(part));
const getAddress = async part => part.networkAccount;

console.log('Deploying contract...');
const ctcAlice = accAlice.contract(backend);

const Part = (part, partAcc) => ({
    getBalance: async () => { return getBalance(partAcc); },
    apply: async () => {
        console.log(`${part} sends an application...`);
        return getAddress(partAcc);
    },
    informStatus: async (status) => {
        console.log(`${part}'s application was ${status ? 'successful' : 'unsuccessful, whitelist full'}.`);
    },
    confirmApplication: async (x, n) => {
        console.log(`${part}'s wallet token balance: ${await getBalance(partAcc)}`);
        console.log(`${part}'s wallet Address: ${x[1]}`);
        console.log(`Total participants in whitelist: ${n}`);
    }
});

console.log('Attaching notifications...');
await Promise.all([
    ctcAlice.p.Alice({
        ...Part('Alice', accAlice),
    }),
]);
