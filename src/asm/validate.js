/* 
    Asserts that register file output from simulator is as expected
*/

const fs = require('fs');
const path = require('path');

let expected_file = process.argv[2];
let actual_file = process.argv[3];


let expected = fs.readFileSync(
    path.resolve(__dirname, expected_file),  { encoding: 'utf8', flag: 'r' })
        .toString()
        .split("\n")
        .filter(line => line.includes("TESTASSERTOUTPUT") || line.includes("TESTASSERTIGNORE"));
let actual = fs.readFileSync(
    path.resolve(__dirname, actual_file),  { encoding: 'utf8', flag: 'r' })
        .toString()
        .split("\n")
        .filter(line => line.includes("TESTASSERTOUTPUT") || line.includes("TESTASSERTIGNORE"));

for(let i = 0; i < expected.length; i++) {
    console.log(expected[i])
    console.log(actual[i]);

    if(expected[i].includes("TESTASSERTIGNORE")) {
        // pass
    }
    else if(i == actual.length) {
        console.error("[ERROR] FAILED TO ASSERT REGISTER FILE STATE NOT ENOUGH LINES!!!!!!!");
    }
    else if(expected[i] != actual[i]) {
        console.error("[ERROR] FAILED TO ASSERT REGISTER FILE STATE !!!!!!!");
        process.exit(1);
    }


}

process.exit(0)
